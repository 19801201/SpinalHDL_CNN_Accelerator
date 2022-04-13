package shape

import spinal.core._
import spinal.lib._
import wa.WaCounter

case class UpSamplingConfig(DATA_WIDTH: Int, COMPUTE_CHANNEL_NUM: Int, FEATURE: Int, CHANNEL_WIDTH: Int, ROW_MEM_DEPTH: Int) {
    val STREAM_DATA_WIDTH = DATA_WIDTH * COMPUTE_CHANNEL_NUM
    val FEATURE_WIDTH = log2Up(FEATURE)
    val channelMemDepth = 512 / COMPUTE_CHANNEL_NUM //最多支持512通道
}

class UpSampling(upSamplingConfig: UpSamplingConfig) extends Component {
    //    val io = new Bundle{
    //        val sData = slave Stream UInt(upSamplingConfig.STREAM_DATA_WIDTH bits)
    //        val mData = master Stream UInt(upSamplingConfig.STREAM_DATA_WIDTH bits)
    //        val rowNumIn = in UInt (upSamplingConfig.FEATURE_WIDTH bits)
    //        val colNumIn = in UInt (upSamplingConfig.FEATURE_WIDTH bits)
    //        val channelIn = in UInt (upSamplingConfig.CHANNEL_WIDTH bits)
    //    }
    val io = ShapePort(upSamplingConfig.STREAM_DATA_WIDTH, upSamplingConfig.FEATURE_WIDTH, upSamplingConfig.CHANNEL_WIDTH)
    noIoPrefix()

    val computeChannelTimes = io.channelIn >> log2Up(upSamplingConfig.COMPUTE_CHANNEL_NUM)
    val computeColumn = io.colNumIn << 1
    val computeRow = io.rowNumIn << 1

    val fsm = ShapeStateMachine(io.start)

    val channelCnt = WaCounter(io.mData.fire, upSamplingConfig.CHANNEL_WIDTH, computeChannelTimes - 1)
    val columnCnt = WaCounter(channelCnt.valid && io.mData.fire, computeColumn.getWidth, computeColumn - 1)
    val rowCnt = WaCounter(fsm.computeEnd, computeRow.getWidth, computeRow - 1)


    val initCount = WaCounter(fsm.currentState === ShapeStateMachineEnum.INIT, 3, 5)
    fsm.initEnd := initCount.valid
    fsm.fifoReady := io.fifoReady
    when(computeChannelTimes === 1) {
        fsm.computeEnd := channelCnt.valid && columnCnt.valid.rise()
    } otherwise {
        fsm.computeEnd := channelCnt.valid && columnCnt.valid
    }
    fsm.last := RegNext(rowCnt.valid)

    val dataTemp = StreamFifo(UInt(upSamplingConfig.STREAM_DATA_WIDTH bits), upSamplingConfig.ROW_MEM_DEPTH)

    val channelMem = StreamFifo(UInt(upSamplingConfig.STREAM_DATA_WIDTH bits), upSamplingConfig.channelMemDepth)

    //    when(fsm.currentState === ShapeStateMachineEnum.COMPUTE) {

    when(!rowCnt.count(0)) {
        when(!columnCnt.count(0)) {
            io.sData.ready := io.mData.ready && dataTemp.io.push.ready && channelMem.io.push.ready
            io.mData.valid := io.sData.fire
            io.mData.payload := io.sData.payload
            dataTemp.io.push.payload := io.sData.payload
            dataTemp.io.push.valid := io.sData.fire
            dataTemp.io.pop.ready := False
            channelMem.io.push.payload := io.sData.payload
            channelMem.io.push.valid := io.sData.fire
            channelMem.io.pop.ready := False
        } otherwise {
            io.sData.ready := False
            dataTemp.io.push.valid := False
            dataTemp.io.push.payload := 0
            dataTemp.io.pop.ready := False
            io.mData <> channelMem.io.pop
            channelMem.io.push.valid := False
            channelMem.io.push.payload := 0
        }
    } otherwise {
        io.sData.ready := False
        when(!columnCnt.count(0)) {
            dataTemp.io.pop.ready := io.mData.ready && channelMem.io.push.ready
            io.mData.valid := dataTemp.io.pop.valid
            io.mData.payload := dataTemp.io.pop.payload
            dataTemp.io.push.payload := 0
            dataTemp.io.push.valid := False
            channelMem.io.push.payload := dataTemp.io.pop.payload
            channelMem.io.push.valid := dataTemp.io.pop.valid
            channelMem.io.pop.ready := False
        } otherwise {
            dataTemp.io.push.valid := False
            dataTemp.io.push.payload := 0
            dataTemp.io.pop.ready := False
            io.mData <> channelMem.io.pop
            channelMem.io.push.valid := False
            channelMem.io.push.payload := 0
        }
    }
    when(fsm.currentState === ShapeStateMachineEnum.IDLE || fsm.currentState === ShapeStateMachineEnum.INIT) {
        io.sData.ready := False
    }
    //    } otherwise {
    //        io.sData.ready := False
    //        channelMem.io.push.valid := False
    //        channelMem.io.push.payload := 0
    //        channelMem.io.pop.ready := False
    //        dataTemp.io.push.valid := False
    //        dataTemp.io.push.payload := 0
    //        dataTemp.io.pop.ready := False
    //        io.mData.payload := 0
    //        io.mData.valid := False
    //    }

}

object UpSampling extends App {
    SpinalVerilog(new UpSampling(UpSamplingConfig(8, 8, 640, 10, 1024)))
}
