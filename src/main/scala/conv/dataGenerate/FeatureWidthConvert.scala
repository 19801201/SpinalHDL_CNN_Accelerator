package conv.dataGenerate

import spinal.core._
import spinal.lib._
import wa.WaCounter
import wa.xip.axi.StreamDataWidthConvert

object FeatureWidthConvertEnum extends SpinalEnum(defaultEncoding = binaryOneHot) {
    val IDLE, INIT, FIFO_READY, SEND, END = newElement
}

case class FeatureWidthConvertFsm(start: Bool) extends Area {

    val initEnd = Bool()
    val fifoReady = Bool()
    val sendEnd = Bool()
    val last = Bool()


    val currentState = Reg(FeatureWidthConvertEnum()) init FeatureWidthConvertEnum.IDLE
    val nextState = FeatureWidthConvertEnum()
    currentState := nextState

    switch(currentState) {
        is(FeatureWidthConvertEnum.IDLE) {
            when(start) {
                nextState := FeatureWidthConvertEnum.INIT
            } otherwise {
                nextState := FeatureWidthConvertEnum.IDLE
            }
        }
        is(FeatureWidthConvertEnum.INIT) {
            when(initEnd) {
                nextState := FeatureWidthConvertEnum.FIFO_READY
            } otherwise {
                nextState := FeatureWidthConvertEnum.INIT
            }
        }
        is(FeatureWidthConvertEnum.FIFO_READY) {
            when(fifoReady) {
                nextState := FeatureWidthConvertEnum.SEND
            } otherwise {
                nextState := FeatureWidthConvertEnum.FIFO_READY
            }
        }
        is(FeatureWidthConvertEnum.SEND) {
            when(sendEnd) {
                nextState := FeatureWidthConvertEnum.END
            } otherwise {
                nextState := FeatureWidthConvertEnum.SEND
            }
        }
        is(FeatureWidthConvertEnum.END) {
            when(last) {
                nextState := FeatureWidthConvertEnum.IDLE
            } otherwise {
                nextState := FeatureWidthConvertEnum.FIFO_READY
            }
        }

    }
}

class FeatureWidthConvert(featureGenerateConfig: FeatureGenerateConfig) extends Component {
    val S_DATA_WIDTH = featureGenerateConfig.COMPUTE_CHANNEL_NUM * 8
    val M_DATA_WIDTH = 8 * S_DATA_WIDTH

    val io = new Bundle {
        val sData = slave Stream UInt(S_DATA_WIDTH bits)
        val mData = GenerateMatrixPort(S_DATA_WIDTH, featureGenerateConfig.KERNEL_NUM)
        val rowNumIn = in UInt (featureGenerateConfig.FEATURE_WIDTH bits)
        val colNumIn = in UInt (featureGenerateConfig.FEATURE_WIDTH bits)
        val start = in Bool()
        val channelIn = in UInt (featureGenerateConfig.CHANNEL_WIDTH bits)
    }
    noIoPrefix()

    val fsm = FeatureWidthConvertFsm(io.start)

    val initCnt = WaCounter(fsm.currentState === FeatureWidthConvertEnum.INIT, 3, 7)
    fsm.initEnd := initCnt.valid
    val dataCvt = StreamDataWidthConvert(S_DATA_WIDTH, M_DATA_WIDTH, "conv11DataCvt", true)
    val channelInTimes = RegNext(io.channelIn >> (log2Up(featureGenerateConfig.COMPUTE_CHANNEL_NUM) + 3))
    val channelCnt = WaCounter(dataCvt.io.mData.fire, featureGenerateConfig.CHANNEL_WIDTH, channelInTimes - 1)
    val columnCnt = WaCounter(channelCnt.valid, featureGenerateConfig.FEATURE_WIDTH, io.colNumIn - 1)
    val rowCnt = WaCounter(fsm.currentState === FeatureWidthConvertEnum.END, featureGenerateConfig.FEATURE_WIDTH, io.rowNumIn - 1)
   // val mCount = RegNext(channelInTimes * io.colNumIn)
    fsm.fifoReady := io.mData.ready
    fsm.sendEnd := channelCnt.valid && columnCnt.valid
    fsm.last := rowCnt.valid && channelCnt.valid && columnCnt.valid

    dataCvt.io.sData <> io.sData
    (0 until 8).foreach(i => {
        io.mData.mData(i).payload <> dataCvt.io.mData.payload.subdivideIn(8 slices)(i)
        io.mData.mData(i).valid <> dataCvt.io.mData.fire
    })
    io.mData.mData(8).payload := 0
    io.mData.mData(8).valid := dataCvt.io.mData.fire

    //val cnt = WaCounter(dataCvt.io.mData.fire, mCount.getWidth, mCount - 1)
    //val ready = Reg(Bool()) setWhen io.mData.ready clearWhen cnt.valid
    when(fsm.currentState === FeatureWidthConvertEnum.SEND) {
        //        when(cnt.valid) {
        //            dataCvt.io.mData.ready.clear()
        //        } otherwise {
        dataCvt.io.mData.ready.set()
        //        }
    } otherwise {
        dataCvt.io.mData.ready.clear()
    }

}
//object FeatureWidthConvert {
//    def main(args: Array[String]): Unit = {
//        SpinalVerilog(new FeatureWidthConvert(FeatureGenerateConfig(8, 10, 8, 8, 9, 10)))
//    }
//}