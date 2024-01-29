package conv.dataGenerate

import spinal.core._
import spinal.lib.slave
import wa.WaCounter

class FeatureConv11Convert(featureGenerateConfig: FeatureGenerateConfig) extends Component {
    val S_DATA_WIDTH = featureGenerateConfig.COMPUTE_CHANNEL_NUM * 8

    val io = new Bundle {
        val sData = slave Stream UInt(S_DATA_WIDTH bits)
        val mData = GenerateMatrixPort(S_DATA_WIDTH, featureGenerateConfig.KERNEL_NUM)
        val rowNumIn = in UInt (featureGenerateConfig.FEATURE_WIDTH bits)
        val colNumIn = in UInt (featureGenerateConfig.FEATURE_WIDTH bits)
        val start = in Bool()
        val channelIn = in UInt (featureGenerateConfig.CHANNEL_WIDTH bits)
    }

    val fsm = FeatureWidthConvertFsm(io.start)

    val initCnt = WaCounter(fsm.currentState === FeatureWidthConvertEnum.INIT, 3, 7)
    fsm.initEnd := initCnt.valid

    val channelInTimes = RegNext(io.channelIn >> log2Up(featureGenerateConfig.COMPUTE_CHANNEL_NUM)) init(0)
    val channelCnt = WaCounter(io.sData.fire, featureGenerateConfig.CHANNEL_WIDTH, channelInTimes - 1)
    val columnCnt = WaCounter(channelCnt.last_valid, featureGenerateConfig.FEATURE_WIDTH, io.colNumIn - 1)
    val rowCnt = WaCounter(fsm.currentState === FeatureWidthConvertEnum.END, featureGenerateConfig.FEATURE_WIDTH, io.rowNumIn - 1)
    // val mCount = RegNext(channelInTimes * io.colNumIn)
    fsm.fifoReady := io.mData.ready
    fsm.sendEnd := columnCnt.last_valid
    fsm.last := rowCnt.last_valid

    (1 until featureGenerateConfig.KERNEL_NUM).foreach(i => {
        io.mData.mData(i).payload := 0
        io.mData.mData(i).valid := io.sData.fire
    })
    io.mData.mData(0).payload := io.sData.payload
    io.mData.mData(0).valid := io.sData.fire

    when(fsm.currentState === FeatureWidthConvertEnum.SEND) {
        io.sData.ready.set()
    } otherwise {
        io.sData.ready.clear()
    }

}
