package shape

import spinal.core._
import spinal.lib._
import wa.WaCounter


case class MaxPoolingConfig(DATA_WIDTH: Int, COMPUTE_CHANNEL_NUM: Int, FEATURE: Int, CHANNEL_WIDTH: Int, ROW_MEM_DEPTH: Int) {
    val STREAM_DATA_WIDTH = DATA_WIDTH * COMPUTE_CHANNEL_NUM
    val FEATURE_WIDTH = log2Up(FEATURE)
    val channelMemDepth = 512 / COMPUTE_CHANNEL_NUM //最多支持512通道
}

class MaxPooling(maxPoolingConfig: MaxPoolingConfig) extends Component {
    //    val io = new Bundle {
    //        //  val start = in Bool()
    //        val sData = slave Stream (UInt(maxPoolingConfig.STREAM_DATA_WIDTH bits))
    //        val mData = master Stream (UInt(maxPoolingConfig.STREAM_DATA_WIDTH bits))
    //        val rowNumIn = in UInt (maxPoolingConfig.FEATURE_WIDTH bits)
    //        val colNumIn = in UInt (maxPoolingConfig.FEATURE_WIDTH bits)
    //        val channelIn = in UInt (maxPoolingConfig.CHANNEL_WIDTH bits)
    //    }
    val io = ShapePort(maxPoolingConfig.STREAM_DATA_WIDTH, maxPoolingConfig.FEATURE_WIDTH, maxPoolingConfig.CHANNEL_WIDTH)
    noIoPrefix()
    val computeChannelTimes = io.channelIn >> log2Up(maxPoolingConfig.COMPUTE_CHANNEL_NUM)

    /** ******************************************************************************************** */
    /* computeState使用reg可能造成慢一个时钟周期，测试的时候需要注意一下,如果有问题考虑旁路寄存器方案                */
    //val computeState = Reg(Bool()) setWhen (io.start)
    //computeState.clearWhen(rowCnt.valid && channelCnt.valid && columnCnt.valid)
    /** ******************************************************************************************** */
    val channelCnt = WaCounter(io.sData.fire, maxPoolingConfig.CHANNEL_WIDTH, computeChannelTimes - 1)
    val columnCnt = WaCounter(channelCnt.valid, maxPoolingConfig.FEATURE_WIDTH, io.colNumIn - 1)
    val rowCnt = WaCounter(channelCnt.valid && columnCnt.valid, maxPoolingConfig.FEATURE_WIDTH, io.rowNumIn - 1)
    val channelMem = StreamFifo(UInt(maxPoolingConfig.STREAM_DATA_WIDTH bits), maxPoolingConfig.channelMemDepth)
    channelMem.io.push.valid <> (io.sData.valid && !columnCnt.count(0))
    (channelMem.io.push.ready || columnCnt.count(0)) <> io.sData.ready
    channelMem.io.push.payload <> io.sData.payload
    channelMem.io.pop.ready <> columnCnt.count(0)


    def compare(dataIn1: UInt, dataIn2: UInt): UInt = {
        val dataOut = Reg(UInt(maxPoolingConfig.DATA_WIDTH bits))
        when(dataIn1 > dataIn2) {
            dataOut := dataIn1
        } otherwise {
            dataOut := dataIn2
        }
        dataOut
    }

    val dataTemp = Vec(UInt(maxPoolingConfig.DATA_WIDTH bits), maxPoolingConfig.COMPUTE_CHANNEL_NUM)


    val rowMem = StreamFifo(UInt(maxPoolingConfig.STREAM_DATA_WIDTH bits), maxPoolingConfig.ROW_MEM_DEPTH)
    rowMem.io.push.valid <> (RegNext(columnCnt.count(0)) && (!rowCnt.count(0)))
    rowMem.io.push.payload.subdivideIn(maxPoolingConfig.COMPUTE_CHANNEL_NUM slices) <> dataTemp

    rowMem.io.pop.ready <> rowCnt.count(0)

    val dataOut = Vec(UInt(maxPoolingConfig.DATA_WIDTH bits), maxPoolingConfig.COMPUTE_CHANNEL_NUM)
    for (i <- 0 until maxPoolingConfig.COMPUTE_CHANNEL_NUM) {
        dataTemp(i) := compare(io.sData.payload.subdivideIn(maxPoolingConfig.COMPUTE_CHANNEL_NUM slices)(i), channelMem.io.pop.payload.subdivideIn(maxPoolingConfig.COMPUTE_CHANNEL_NUM slices)(i))
        dataOut(i) := compare(dataTemp(i), rowMem.io.pop.payload.subdivideIn(maxPoolingConfig.COMPUTE_CHANNEL_NUM slices)(i))
    }
    io.mData.payload.subdivideIn(maxPoolingConfig.COMPUTE_CHANNEL_NUM slices) <> dataTemp
    io.mData.valid <> RegNext(rowCnt.count(0))


}

object MaxPooling extends App {
    SpinalVerilog(new MaxPooling(MaxPoolingConfig(8, 8, 100, 10, 1024)))
}
