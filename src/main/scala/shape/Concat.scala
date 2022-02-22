package shape


import spinal.core._
import spinal.lib._

case class ConcatConfig(DATA_WIDTH: Int, COMPUTE_CHANNEL_NUM: Int, FEATURE: Int, CHANNEL_WIDTH: Int, ROW_MEM_DEPTH: Int) {
    val STREAM_DATA_WIDTH = DATA_WIDTH * COMPUTE_CHANNEL_NUM
    val FEATURE_WIDTH = log2Up(FEATURE)
    val channelMemDepth = 512 / COMPUTE_CHANNEL_NUM //最多支持512通道
}

class Concat(concatConfig: ConcatConfig) extends Component {

    val dataPort = ShapePort(concatConfig.STREAM_DATA_WIDTH,concatConfig.FEATURE_WIDTH,concatConfig.CHANNEL_WIDTH)
    noIoPrefix()


}

object Concat extends App {
//    SpinalVerilog(new Concat)
}
