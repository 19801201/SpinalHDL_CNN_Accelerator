package wa.dma

import spinal.core._

import spinal.lib._
import spinal.lib.bus.amba4.axi._

class DmaRead(dmaReadConfig: DmaConfig) extends Component {
    val io = new Bundle {
        val M_AXI_MM2S = master(Axi4ReadOnly(Axi4Config(addressWidth = dmaReadConfig.addrWidth, dataWidth = dmaReadConfig.axiDataWidth, useQos = false, useId = false, useRegion = false, useLock = false, useCache = false, useProt = false)))
        Axi4SpecRenamer(M_AXI_MM2S)
        val M_AXIS_MM2S = master(Stream(UInt(dmaReadConfig.streamDataWidth bits)))

        val cmd = DmaCmd()
    }
    noIoPrefix()




}

object DmaRead extends App {
    SpinalVerilog(new DmaRead(DmaConfig(32, 64, 8, 32))).printPruned()
}
