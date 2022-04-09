package shape

import spinal.core._
import spinal.lib._

case class ShapeConfig(DATA_WIDTH: Int, COMPUTE_CHANNEL_NUM: Int, FEATURE: Int, CHANNEL_WIDTH: Int, ROW_MEM_DEPTH: Int) {
    val STREAM_DATA_WIDTH = DATA_WIDTH * COMPUTE_CHANNEL_NUM

    val concatConfig = ConcatConfig(DATA_WIDTH, COMPUTE_CHANNEL_NUM, FEATURE, CHANNEL_WIDTH)
    val splitConfig = SplitConfig(DATA_WIDTH, COMPUTE_CHANNEL_NUM, FEATURE, CHANNEL_WIDTH)
    val upSamplingConfig = UpSamplingConfig(DATA_WIDTH, COMPUTE_CHANNEL_NUM, FEATURE, CHANNEL_WIDTH, ROW_MEM_DEPTH)
    val maxPoolingConfig = MaxPoolingConfig(DATA_WIDTH, COMPUTE_CHANNEL_NUM, FEATURE, CHANNEL_WIDTH, ROW_MEM_DEPTH)

}


class Shape(shapeConfig: ShapeConfig) extends Component {
    val io = new Bundle {
        val sData = Vec(slave Stream (UInt(shapeConfig.STREAM_DATA_WIDTH bits)), 2)
        val mData = master Stream (UInt(shapeConfig.STREAM_DATA_WIDTH bits))
        val dmaReadValid = out Vec(Bool(), 2)
        val dmaWriteValid = out Bool()
        val control = in Bits (4 bits)
        val state = out Bits (4 bits)
        val introut = in Bool()
    }
    noIoPrefix()

    val shapeState = new ShapeState
    shapeState.io.dmaReadValid <> io.dmaReadValid
    shapeState.io.dmaWriteValid <> io.dmaWriteValid
    shapeState.io.control <> io.control
    shapeState.io.state <> io.state

    val concat = new Concat(shapeConfig.concatConfig)

    val start = shapeState.io.start.map(_.rise()).reduce(_ || _)



    val fifo = StreamFifo(UInt(shapeConfig.STREAM_DATA_WIDTH bits), shapeConfig.ROW_MEM_DEPTH << 1)
    fifo.io.pop <> io.mData
}

object Shape extends App {
    SpinalVerilog(new Shape(ShapeConfig(8, 8, 640, 10, 1024)))
}
