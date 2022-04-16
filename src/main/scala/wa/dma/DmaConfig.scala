package wa.dma

import spinal.core._


case class DmaCmd() extends Bundle {
    val valid = in Bool()
    val addr = in UInt (32 bits)
    val len = in UInt (32 bits)
    val introut = out Bool()
}

case class DmaConfig(addrWidth: Int, dataWidth: Int, burstSize: Int) {
    require((dataWidth & (dataWidth - 1)) == 0, "dataWidth需要是2的幂次")
    require((burstSize & (burstSize - 1)) == 0, "burstSize需要是2的幂次")
    val byteConut = dataWidth / 8
    val awSize = (scala.math.log(dataWidth / 8) / scala.math.log(2)).toInt

}