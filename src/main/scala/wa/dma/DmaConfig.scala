package wa.dma

import spinal.core._


case class DmaCmd() extends Bundle {
    val valid = in Bool()
    val addr = in UInt (32 bits)
    val len = in UInt (32 bits)
    val introut = out Bool()
}

case class DmaConfig(addrWidth: Int, axiDataWidth: Int, streamDataWidth:Int, burstSize: Int) {
    require((axiDataWidth & (axiDataWidth - 1)) == 0, "axiDataWidth需要是2的幂次")
    require((burstSize & (burstSize - 1)) == 0, "burstSize需要是2的幂次")
    val byteConut = axiDataWidth / 8
    val awSize = (scala.math.log(axiDataWidth / 8) / scala.math.log(2)).toInt

}