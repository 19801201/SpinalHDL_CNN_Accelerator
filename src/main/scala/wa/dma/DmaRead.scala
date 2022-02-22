package wa.dma
import spinal.core._

import spinal.lib._
import spinal.lib.bus.amba4.axi._

class DmaRead(dmaReadConfig: DmaConfig) extends Component {
    val io = new Bundle {
        val M_AXI_MM2S = master(Axi4ReadOnly(Axi4Config(32, dataWidth = dmaReadConfig.dataWidth, useQos = false, useId = false, useRegion = false, useLock = false, wUserWidth = 0, awUserWidth = 0, bUserWidth = 0)))
        Axi4SpecRenamer(M_AXI_MM2S)
        val M_AXIS_MM2S = master(Stream(Bits(dmaReadConfig.dataWidth bits)))

        val cmd = DmaCmd()
    }
    noIoPrefix()

    when(io.M_AXI_MM2S.ar.fire) {
        io.M_AXI_MM2S.ar.burst := B"2'b01"
        io.M_AXI_MM2S.ar.size := dmaReadConfig.awSize

    } otherwise {
        io.M_AXI_MM2S.ar.burst := 0
        io.M_AXI_MM2S.ar.size := 0

    }
    io.M_AXI_MM2S.ar.cache := B"4'd3"
    io.M_AXI_MM2S.ar.prot := 0


    io.M_AXIS_MM2S.valid := io.M_AXI_MM2S.r.valid
    io.M_AXI_MM2S.r.ready := io.M_AXIS_MM2S.ready
    io.M_AXIS_MM2S.payload := io.M_AXI_MM2S.r.payload.data


    val addr = Reg(UInt(32 bits)) init 0
    when(io.cmd.valid) {
        addr := io.cmd.addr
    } elsewhen (io.M_AXI_MM2S.ar.fire) {
        addr := addr + (dmaReadConfig.byteConut * dmaReadConfig.burstSize)
    }
    val cnt = Reg(UInt(32 bits)) init 0
    val cntLast = Reg(UInt(32 bits)) init 0
    when(io.M_AXI_MM2S.r.fire) {
        when(io.cmd.introut) {
            cntLast := 0
        } otherwise {
            cntLast := cntLast + 1
        }

    }
    when(io.M_AXI_MM2S.ar.fire) {
        cnt := cnt + dmaReadConfig.burstSize
    } elsewhen (io.cmd.introut) {
        cnt := 0
    } otherwise {
        cnt := cnt
    }
    val len = Reg(UInt(32 bits))
    when(io.cmd.valid) {
        len := io.cmd.len
    }
    when(cntLast === len - 1) {
        io.cmd.introut := True
    } otherwise {
        io.cmd.introut := False
    }
    when(io.M_AXI_MM2S.ar.fire) {
        io.M_AXI_MM2S.ar.addr := addr
    } otherwise {
        io.M_AXI_MM2S.ar.addr := 0
    }
    when(io.M_AXI_MM2S.ar.fire) {
        when(len - cnt > dmaReadConfig.burstSize) {
            io.M_AXI_MM2S.ar.len := dmaReadConfig.burstSize - 1
        } otherwise {
            io.M_AXI_MM2S.ar.len := (len - 1 - cnt).resized
        }
    } otherwise {
        io.M_AXI_MM2S.ar.len := 0
    }


    val aValid = Bool()
    val cntAv = Reg(UInt(32 bits))
    when(aValid && io.M_AXI_MM2S.ar.ready) {
        cntAv := 0
    } elsewhen (aValid) {
        cntAv := cntAv
    } otherwise {
        cntAv := cntAv + 1
    }
    val trans = Reg(Bool()) init False setWhen (io.cmd.valid) clearWhen (io.cmd.introut)
    when(RegNext(io.cmd.valid)) {
        aValid := True
    } elsewhen (cntAv === dmaReadConfig.burstSize - 1 && cnt < len && trans) {
        aValid := True
    } otherwise {
        aValid := False
    }
    io.M_AXI_MM2S.ar.valid := aValid


}

object DmaRead extends App {
    SpinalVerilog(new DmaRead(DmaConfig(64, 32))).printPruned()
}
