package conv.dataGenerate

import conv.compute.CONV_STATE
import spinal.core._
import spinal.lib.{master, slave}


case class DataGenerateConfig(DATA_WIDTH: Int, CHANNEL_WIDTH: Int, COMPUTE_CHANNEL_NUM: Int, ROW_WIDTH: Int, COL_WIDTH: Int, KERNEL_NUM: Int, FEATURE_RAM_DEPTH: Int) {
    val PICTURE_NUM = 1
    val STREAM_DATA_WIDTH = DATA_WIDTH * PICTURE_NUM * COMPUTE_CHANNEL_NUM
    val paddingConfig = PaddingConfig(DATA_WIDTH, CHANNEL_WIDTH, COMPUTE_CHANNEL_NUM, ROW_WIDTH, COL_WIDTH)
    val featureGenerateConfig = FeatureGenerateConfig(DATA_WIDTH, CHANNEL_WIDTH, COMPUTE_CHANNEL_NUM, ROW_WIDTH + 1, COL_WIDTH + 1, KERNEL_NUM, FEATURE_RAM_DEPTH)
}

class DataGenerate(dataGenerateConfig: DataGenerateConfig) extends Component {
    val io = new Bundle {
        val sData = slave Stream (UInt(dataGenerateConfig.STREAM_DATA_WIDTH bits))
        val start = in Bool()
        val enPadding = in Vec(Bool(), 4)
        val channelIn = in UInt (dataGenerateConfig.CHANNEL_WIDTH bits)
        val rowNumIn = in UInt (dataGenerateConfig.ROW_WIDTH bits)
        val colNumIn = in UInt (dataGenerateConfig.COL_WIDTH bits)
        val zeroDara = in Bits (dataGenerateConfig.DATA_WIDTH bits)
        //        val zeroNum = in UInt (dataGenerateConfig.paddingConfig.ZERO_NUM_WIDTH bits)
        //        val mData = master(FeaturePort(dataGenerateConfig.STREAM_DATA_WIDTH, dataGenerateConfig.KERNEL_NUM))
        val mData = GenerateMatrixPort(dataGenerateConfig.featureGenerateConfig.STREAM_DATA_WIDTH, dataGenerateConfig.featureGenerateConfig.KERNEL_NUM)
        val convType = in Bits (2 bits)
        //        val last = out Bool()
    }
    noIoPrefix()
    val padding = new Padding(dataGenerateConfig.paddingConfig)
    padding.io.enPadding <> io.enPadding
    padding.io.channelIn <> io.channelIn
    padding.io.rowNumIn <> io.rowNumIn
    padding.io.colNumIn <> io.colNumIn
    //    padding.io.zeroNum <> io.zeroNum
    padding.io.zeroDara <> io.zeroDara
    val featureGenerate = new FeatureGenerate(dataGenerateConfig.featureGenerateConfig)
    val featureWidthConvert = new FeatureWidthConvert(dataGenerateConfig.featureGenerateConfig)
    val featureConv11Convert = new FeatureConv11Convert(dataGenerateConfig.featureGenerateConfig)

    featureWidthConvert.io.channelIn <> io.channelIn
    featureWidthConvert.io.colNumIn <> io.colNumIn
    featureWidthConvert.io.rowNumIn <> io.rowNumIn

    featureConv11Convert.io.channelIn <> io.channelIn
    featureConv11Convert.io.colNumIn <> io.colNumIn
    featureConv11Convert.io.rowNumIn <> io.rowNumIn
    //    when(io.convType === CONV_STATE.CONV33) {
    //        padding.io.sData <> io.sData
    //        padding.io.start <> io.start
    //        featureGenerate.io.mData <> io.mData
    //        featureWidthConvert.io.sData.valid := False
    //        featureWidthConvert.io.sData.payload := 0
    //        featureWidthConvert.io.mData.ready := False
    //        featureWidthConvert.io.start := False
    //
    //    } elsewhen (io.convType === CONV_STATE.CONV11_8X) {
    //        featureWidthConvert.io.sData <> io.sData
    //        featureWidthConvert.io.mData <> io.mData
    //        featureWidthConvert.io.start <> io.start
    //
    //        featureGenerate.io.mData.ready := False
    //        padding.io.start <> False
    //        padding.io.sData.valid := False
    //        padding.io.sData.payload := 0
    //    } elsewhen (io.convType === CONV_STATE.CONV11) {
    //
    //    } otherwise {
    //
    //    }

    switch(io.convType) {
        is(CONV_STATE.CONV33) {
            padding.io.sData <> io.sData
            padding.io.start <> io.start
            featureGenerate.io.mData <> io.mData
            featureWidthConvert.io.sData.valid := False
            featureWidthConvert.io.sData.payload := 0
            featureWidthConvert.io.mData.ready := False
            featureWidthConvert.io.start := False

            featureConv11Convert.io.sData.valid := False
            featureConv11Convert.io.sData.payload := 0
            featureConv11Convert.io.mData.ready := False
            featureConv11Convert.io.start := False
        }
        is(CONV_STATE.CONV11_8X) {
            featureWidthConvert.io.sData <> io.sData
            featureWidthConvert.io.mData <> io.mData
            featureWidthConvert.io.start <> io.start

            featureGenerate.io.mData.ready := False
            padding.io.start <> False
            padding.io.sData.valid := False
            padding.io.sData.payload := 0

            featureConv11Convert.io.sData.valid := False
            featureConv11Convert.io.sData.payload := 0
            featureConv11Convert.io.mData.ready := False
            featureConv11Convert.io.start := False
        }
        is(CONV_STATE.CONV11) {

            featureConv11Convert.io.sData <> io.sData
            featureConv11Convert.io.mData <> io.mData
            featureConv11Convert.io.start <> io.start

            padding.io.start <> False
            padding.io.sData.valid := False
            padding.io.sData.payload := 0
            featureGenerate.io.mData.ready := False

            featureWidthConvert.io.sData.valid := False
            featureWidthConvert.io.sData.payload := 0
            featureWidthConvert.io.mData.ready := False
            featureWidthConvert.io.start := False
        }
        default {
            padding.io.start <> False
            padding.io.sData.valid := False
            padding.io.sData.payload := 0
            featureGenerate.io.mData.ready := False

            featureWidthConvert.io.sData.valid := False
            featureWidthConvert.io.sData.payload := 0
            featureWidthConvert.io.mData.ready := False
            featureWidthConvert.io.start := False

            featureConv11Convert.io.sData.valid := False
            featureConv11Convert.io.sData.payload := 0
            featureConv11Convert.io.mData.ready := False
            featureConv11Convert.io.start := False

            io.mData.mData.foreach(i => {
                i.valid := False
                i.payload := 0
            })
            io.sData.ready := False
        }
    }

    padding >> featureGenerate
    //    featureGenerate.io.last <> io.last
}

object DataGenerate {
    def main(args: Array[String]): Unit = {
        SpinalConfig(
        ).generateVerilog(new DataGenerate(DataGenerateConfig(8, 12, 8, 10, 9, 11, 1)))
    }
}
