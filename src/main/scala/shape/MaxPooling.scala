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

    val fsm = ShapeStateMachine(io.start)
    fsm.fifoReady := io.fifoReady

    val initCount = WaCounter(fsm.currentState === ShapeStateMachineEnum.INIT, 3, 5)
    fsm.initEnd := initCount.valid


    val channelCnt = WaCounter(io.sData.fire, maxPoolingConfig.CHANNEL_WIDTH, computeChannelTimes - 1)
    val columnCnt = WaCounter(channelCnt.valid && io.sData.fire, maxPoolingConfig.FEATURE_WIDTH, io.colNumIn - 1)
    val rowCnt = WaCounter(fsm.currentState === ShapeStateMachineEnum.LAST, maxPoolingConfig.FEATURE_WIDTH, io.rowNumIn - 1)
    val channelMem = Mem(UInt(maxPoolingConfig.STREAM_DATA_WIDTH bits), maxPoolingConfig.channelMemDepth)

    val channelMemWriteAddr = WaCounter(!columnCnt.count(0) && io.sData.fire, log2Up(maxPoolingConfig.channelMemDepth), computeChannelTimes - 1)
    channelMem.write(channelMemWriteAddr.count, io.sData.payload, enable = !columnCnt.count(0) && io.sData.fire)
    val channelMemReadAddr = WaCounter(columnCnt.count(0) && io.sData.fire, log2Up(maxPoolingConfig.channelMemDepth), computeChannelTimes - 1)


    when(fsm.currentState === ShapeStateMachineEnum.COMPUTE) {
        io.sData.ready := True
    } otherwise {
        io.sData.ready := False
    }

    fsm.computeEnd := (columnCnt.valid && channelCnt.valid)
    fsm.last := rowCnt.valid

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


    val depth = RegNext(io.colNumIn * computeChannelTimes)
    val rowMem = Mem(UInt(maxPoolingConfig.STREAM_DATA_WIDTH bits), maxPoolingConfig.ROW_MEM_DEPTH)
    val rowMemWriteAddr = WaCounter(RegNext(columnCnt.count(0) && (!rowCnt.count(0)) && io.sData.fire), log2Up(maxPoolingConfig.ROW_MEM_DEPTH), depth - 1)
    rowMem.write(rowMemWriteAddr.count, dataTemp.reverse.reduce(_ @@ _), enable = RegNext(columnCnt.count(0) && (!rowCnt.count(0))))
    val rowMemReadAddr = WaCounter(RegNext(columnCnt.count(0) && (rowCnt.count(0)) && io.sData.fire), log2Up(maxPoolingConfig.ROW_MEM_DEPTH), depth - 1)
    //    rowMem.readAsync(rowMemReadAddr.count)
    val dataOut = Vec(UInt(maxPoolingConfig.DATA_WIDTH bits), maxPoolingConfig.COMPUTE_CHANNEL_NUM)
    val pix12 = Vec(UInt(maxPoolingConfig.DATA_WIDTH bits), maxPoolingConfig.COMPUTE_CHANNEL_NUM)
    val pix11 = Vec(UInt(maxPoolingConfig.DATA_WIDTH bits), maxPoolingConfig.COMPUTE_CHANNEL_NUM)
    val maxPix2 = Vec(UInt(maxPoolingConfig.DATA_WIDTH bits), maxPoolingConfig.COMPUTE_CHANNEL_NUM)
    val maxPix1 = Vec(UInt(maxPoolingConfig.DATA_WIDTH bits), maxPoolingConfig.COMPUTE_CHANNEL_NUM)

    pix12 := io.sData.payload.subdivideIn(maxPoolingConfig.COMPUTE_CHANNEL_NUM slices)
    pix11 := channelMem.readAsync(channelMemReadAddr.count).subdivideIn(maxPoolingConfig.COMPUTE_CHANNEL_NUM slices)
    maxPix2 := dataTemp
    maxPix1 := rowMem.readAsync(rowMemReadAddr.count).subdivideIn(maxPoolingConfig.COMPUTE_CHANNEL_NUM slices)
    for (i <- 0 until maxPoolingConfig.COMPUTE_CHANNEL_NUM) {
        dataTemp(i) := compare(pix12(i), pix11(i))
        dataOut(i) := compare(maxPix2(i), maxPix1(i))
    }
    io.mData.payload.subdivideIn(maxPoolingConfig.COMPUTE_CHANNEL_NUM slices) <> dataOut
    io.mData.valid <> RegNext(RegNext(rowCnt.count(0) && columnCnt.count(0)))


}

object MaxPooling extends App {
    SpinalVerilog(new MaxPooling(MaxPoolingConfig(8, 8, 100, 10, 1024)))
}
