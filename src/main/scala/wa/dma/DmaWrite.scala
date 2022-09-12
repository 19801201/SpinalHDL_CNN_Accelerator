package wa.dma

import spinal.core._

import spinal.lib._
import spinal.lib.bus.amba4.axi._


class DmaWrite(dmaWriteConfig: DmaConfig) extends Component {
    val io = new Bundle {
        val M_AXI_S2MM = master(Axi4WriteOnly(Axi4Config(addressWidth = dmaWriteConfig.addrWidth, dataWidth = dmaWriteConfig.axiDataWidth, useQos = false, useId = false, useRegion = false, useLock = false, wUserWidth = 0, awUserWidth = 0, bUserWidth = 0)))
        Axi4SpecRenamer(M_AXI_S2MM)
        val M_AXIS_S2MM = slave(Stream(UInt(dmaWriteConfig.streamDataWidth bits)))

        val cmd = DmaCmd()
    }
    noIoPrefix()



}

object DmaWrite extends App {
    SpinalVerilog(new DmaWrite(DmaConfig(32, 64, 8, 32))).printPruned()
}