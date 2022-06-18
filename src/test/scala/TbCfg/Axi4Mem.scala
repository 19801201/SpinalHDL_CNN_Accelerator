package TbCfg

import spinal.core._
import spinal.lib._
import spinal.lib.bus.amba4.axi._

class Axi4Mem(dataWidth: Int, byteCount: BigInt, idWidth: Int = 0, arwStage: Boolean = false) extends Component {
    val io = new Bundle {
        val axi = slave(Axi4(Axi4Config(log2Up(byteCount))))
    }
    noIoPrefix()
}

