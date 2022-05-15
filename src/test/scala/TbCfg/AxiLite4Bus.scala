package TbCfg

import spinal.core._
import spinal.core.sim._
import spinal.lib.bus.amba4.axilite._

case class AxiLite4Bus(axi: AxiLite4) {
    def reset(): Unit = {
        axi.aw.valid #= false
        axi.w.valid #= false
        axi.ar.valid #= false
        axi.r.ready #= true
        axi.b.ready #= true
    }

    def write(address: BigInt, data: BigInt): Bool ={
        val end = Reg(Bool()) init False

        axi.aw.payload.prot.assignBigInt(0)
        axi.w.payload.strb.assignBigInt(15)

        axi.aw.valid := True
        axi.aw.payload.addr #= address

        when(axi.aw.ready){
            axi.aw.valid := False
        }

        end := True
        end
    }
}
