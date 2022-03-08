package conv.dataGenerate

import spinal.core._
import spinal.lib._
import wa.WaCounter
import wa.xip.axi.StreamDataWidthConvert

class FeatureWidthConvert(featureGenerateConfig: FeatureGenerateConfig) extends Component {
    val S_DATA_WIDTH = featureGenerateConfig.COMPUTE_CHANNEL_NUM * 8
    val M_DATA_WIDTH = 8 * S_DATA_WIDTH

    val io = new Bundle {
        val sData = slave Stream UInt(S_DATA_WIDTH bits)
        val mData = GenerateMatrixPort(S_DATA_WIDTH, featureGenerateConfig.KERNEL_NUM)
        //val rowNumIn = in UInt (featureGenerateConfig.FEATURE_WIDTH bits)
        val colNumIn = in UInt (featureGenerateConfig.FEATURE_WIDTH bits)
        //val start = in Bool()
        val channelIn = in UInt (featureGenerateConfig.CHANNEL_WIDTH bits)
    }
    noIoPrefix()
    val channelInTimes = RegNext(io.channelIn >> (log2Up(featureGenerateConfig.COMPUTE_CHANNEL_NUM) + 3))
    val mCount = RegNext(channelInTimes * io.colNumIn)
    val dataCvt = StreamDataWidthConvert(S_DATA_WIDTH, M_DATA_WIDTH, "conv11DataCvt", true)
    dataCvt.io.sData <> io.sData
    (0 until 8).foreach(i => {
        io.mData.mData(i).payload <> dataCvt.io.mData.payload.subdivideIn(8 slices)(i)
        io.mData.mData(i).valid <> dataCvt.io.mData.fire
    })
    io.mData.mData(8).payload := 0
    io.mData.mData(8).valid := dataCvt.io.mData.fire

    val cnt = WaCounter(dataCvt.io.mData.fire, mCount.getWidth, mCount - 1)
    val ready = Reg(Bool()) setWhen io.mData.ready clearWhen cnt.valid
    when(ready) {
        when(cnt.valid) {
            dataCvt.io.mData.ready.clear()
        } otherwise {
            dataCvt.io.mData.ready.set()
        }
    } otherwise {
        dataCvt.io.mData.ready.clear()
    }

}
//object FeatureWidthConvert {
//    def main(args: Array[String]): Unit = {
//        SpinalVerilog(new FeatureWidthConvert(FeatureGenerateConfig(8, 10, 8, 8, 9, 10)))
//    }
//}