package TbCfg

import spinal.core._
import spinal.core.sim._
import spinal.lib.bus.amba4.axilite._

case class AxiLite4Bus(axi: AxiLite4) {
    def reset(): Unit = {
        axi.aw.valid := False
        axi.w.valid := False
        axi.ar.valid := False
        axi.r.ready := True
        axi.b.ready := True
    }

    def write(address: UInt, data: Bits, start: Bool): Bool = {
        val end = Reg(Bool()) init False

        axi.aw.payload.prot.assignBigInt(0)
        axi.w.payload.strb.assignBigInt(15)

        val awValid = Reg(Bool()) init False
        axi.aw.valid := awValid
        when(start) {
            awValid := True
        } elsewhen (axi.aw.ready && awValid) {
            awValid := False
        } otherwise {
            awValid := awValid
        }
        axi.aw.payload.addr := address

        val wValid = Reg(Bool()) init False
        axi.w.valid := wValid
        when(start) {
            wValid := True
        } elsewhen (axi.w.ready && wValid) {
            wValid := False
        } otherwise {
            wValid := wValid
        }

        axi.w.payload.data.assignFromBits(data)
        //
        //        val bReady = Reg(Bool()) init False
        //        when(axi.b.valid && !bReady) {
        //            bReady := True
        //        } elsewhen (bReady) {
        //            bReady := False
        //        } otherwise {
        //            bReady := bReady
        //        }
        //        axi.b.ready := bReady
        axi.b.ready := True
        when(axi.b.fire) {
            end := True
        } otherwise {
            end := False
        }
        end
    }

    def read(address: UInt, start: Bool): (Bool, Bits) = {
        val data = Reg(Bits(32 bits)) init 0
        val end = Reg(Bool())
        axi.ar.payload.prot.assignBigInt(0)

        val arValid = Reg(Bool()) init False
        axi.ar.valid := arValid
        when(start) {
            arValid := True
        } elsewhen (axi.ar.ready && arValid) {
            arValid := False
        } otherwise {
            arValid := arValid
        }

        axi.ar.payload.addr := address

        //        val rReady = Reg(Bool()) init False
        //        when(axi.r.valid && !rReady) {
        //            rReady := True
        //        } elsewhen (rReady) {
        //            rReady := False
        //        } otherwise {
        //            rReady := rReady
        //        }
        axi.r.ready := True
        when(axi.r.fire) {
            end := True
            data := axi.r.payload.data
        } otherwise {
            end := False
            data := data
        }

        (end, data)
    }
}
