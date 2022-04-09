package shape

import spinal.lib._
import spinal.core._
import wa.WaCounter

case class SplitConfig(DATA_WIDTH: Int, COMPUTE_CHANNEL_NUM: Int, FEATURE: Int, CHANNEL_WIDTH: Int) {
    val STREAM_DATA_WIDTH = DATA_WIDTH * COMPUTE_CHANNEL_NUM
    val FEATURE_WIDTH = log2Up(FEATURE)
}

class Split(splitConfig: SplitConfig) extends Component {
    //    val io = new Bundle {
    //        val sData = slave Stream UInt(splitConfig.STREAM_DATA_WIDTH bits)
    //        val mData = master Stream UInt(splitConfig.STREAM_DATA_WIDTH bits)
    //        val rowNumIn = in UInt (splitConfig.FEATURE_WIDTH bits)
    //        val colNumIn = in UInt (splitConfig.FEATURE_WIDTH bits)
    //        val channelIn = in UInt (splitConfig.CHANNEL_WIDTH bits)
    //    }
    val io = ShapePort(splitConfig.STREAM_DATA_WIDTH, splitConfig.FEATURE_WIDTH, splitConfig.CHANNEL_WIDTH)
    noIoPrefix()
    val computeChannelTimes = io.channelIn >> log2Up(splitConfig.COMPUTE_CHANNEL_NUM)
    val channelOut = computeChannelTimes >> 1
    val channelCnt = WaCounter(io.sData.fire, splitConfig.CHANNEL_WIDTH, computeChannelTimes - 1)
    val columnCnt = WaCounter(channelCnt.valid, splitConfig.FEATURE_WIDTH, io.colNumIn - 1)
    val rowCnt = WaCounter(channelCnt.valid && columnCnt.valid, splitConfig.FEATURE_WIDTH, io.rowNumIn - 1)

    val fsm = ShapeStateMachine(io.start)
    val initCount = WaCounter(fsm.currentState === ShapeStateMachineEnum.INIT, 3, 5)
    fsm.initEnd := initCount.valid
    fsm.fifoReady := io.fifoReady
    fsm.computeEnd := channelCnt.valid && columnCnt.valid
    fsm.last := channelCnt.valid && columnCnt.valid && rowCnt.valid

    io.mData.arbitrationFrom(io.sData.haltWhen(fsm.currentState =/= ShapeStateMachineEnum.COMPUTE).throwWhen(channelCnt.count < channelOut))
    io.mData.payload := io.sData.payload
    //    when(channelCnt.count >= channelOut) {
    //        io.sData <> io.mData
    //    } otherwise {
    //        io.mData.valid := False
    //        io.mData.payload := 0
    //        io.sData.ready := True
    //    }

}

object Split extends App {
    SpinalVerilog(new Split(SplitConfig(8, 8, 640, 10))).printPruned()
}
