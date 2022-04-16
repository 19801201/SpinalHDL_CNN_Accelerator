package wa.dma

import spinal.core._

import spinal.lib._
import spinal.lib.bus.amba4.axi._


class DmaWrite(dmaWriteConfig: DmaConfig) extends Component {
    val io = new Bundle {
        val M_AXI_S2MM = master(Axi4WriteOnly(Axi4Config(addressWidth = dmaWriteConfig.addrWidth, dataWidth = dmaWriteConfig.dataWidth, useQos = false, useId = false, useRegion = false, useLock = false, wUserWidth = 0, awUserWidth = 0, bUserWidth = 0)))
        Axi4SpecRenamer(M_AXI_S2MM)
        val M_AXIS_S2MM = slave(Stream(UInt(dmaWriteConfig.dataWidth bits)))

        val cmd = DmaCmd()
    }
    noIoPrefix()

    when(io.M_AXI_S2MM.aw.fire) {
        io.M_AXI_S2MM.aw.burst := B"2'b01"
        io.M_AXI_S2MM.aw.size := dmaWriteConfig.awSize

    } otherwise {
        io.M_AXI_S2MM.aw.burst := 0
        io.M_AXI_S2MM.aw.size := 0

    }
    io.M_AXI_S2MM.aw.cache := B"4'd3"
    io.M_AXI_S2MM.aw.prot := 0
    io.M_AXI_S2MM.b.ready := True


    io.M_AXI_S2MM.w.valid <> io.M_AXIS_S2MM.valid
    io.M_AXI_S2MM.w.ready <> io.M_AXIS_S2MM.ready
    io.M_AXI_S2MM.w.payload.data.assignFromBits(io.M_AXIS_S2MM.payload.asBits)
    io.M_AXI_S2MM.w.payload.strb.setAll()


    val addr = Reg(UInt(32 bits)) init 0
    when(io.cmd.valid) {
        addr := io.cmd.addr
    } elsewhen (io.M_AXI_S2MM.aw.fire) {
        addr := addr + (dmaWriteConfig.byteConut * dmaWriteConfig.burstSize)
    }
    val cnt = Reg(UInt(32 bits)) init 0
    val cntBrust = Reg(UInt(32 bits)) init 0
    when(io.M_AXI_S2MM.w.fire) {
        when(cntBrust === dmaWriteConfig.burstSize - 1 || io.cmd.introut) {
            cntBrust := 0
        } otherwise {
            cntBrust := cntBrust + 1
        }

    }
    val cntLast = Reg(UInt(32 bits)) init 0
    when(io.M_AXI_S2MM.w.fire) {
        when(io.cmd.introut) {
            cntLast := 0
        } otherwise {
            cntLast := cntLast + 1
        }

    }
    when(io.M_AXI_S2MM.aw.fire) {
        cnt := cnt + dmaWriteConfig.burstSize
    } elsewhen (io.cmd.introut) {
        cnt := 0
    } otherwise {
        cnt := cnt
    }
    val len = Reg(UInt(32 bits))
    when(io.cmd.valid) {
        len := io.cmd.len
    }
    when(cntBrust === dmaWriteConfig.burstSize - 1 || cntLast === len - 1) {
        io.M_AXI_S2MM.w.last := True
    } otherwise {
        io.M_AXI_S2MM.w.last := False
    }
    when(cntLast === len - 1) {
        io.cmd.introut := True
    } otherwise {
        io.cmd.introut := False
    }
    when(io.M_AXI_S2MM.aw.fire) {
        io.M_AXI_S2MM.aw.addr := addr
    } otherwise {
        io.M_AXI_S2MM.aw.addr := 0
    }
    when(io.M_AXI_S2MM.aw.fire) {
        when(len - cnt > dmaWriteConfig.burstSize) {
            io.M_AXI_S2MM.aw.len := dmaWriteConfig.burstSize - 1
        } otherwise {
            io.M_AXI_S2MM.aw.len := (len - 1 - cnt).resized
        }
    } otherwise {
        io.M_AXI_S2MM.aw.len := 0
    }


    val aValid = Bool()
    val cntAv = Reg(UInt(32 bits))
    when(aValid && io.M_AXI_S2MM.aw.ready) {
        cntAv := 0
    } elsewhen (aValid) {
        cntAv := cntAv
    } otherwise {
        cntAv := cntAv + 1
    }
    val trans = Reg(Bool()) init False setWhen (io.cmd.valid) clearWhen (io.cmd.introut)
    when(RegNext(io.cmd.valid)) {
        aValid := True
    } elsewhen (cntAv === dmaWriteConfig.burstSize - 1 && cnt < len && trans) {
        aValid := True
    } otherwise {
        aValid := False
    }
    io.M_AXI_S2MM.aw.valid := aValid


}

object DmaWrite extends App {
    SpinalVerilog(new DmaWrite(DmaConfig(32, 64, 32))).printPruned()
}