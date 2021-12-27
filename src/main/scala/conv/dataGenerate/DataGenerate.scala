package conv.dataGenerate
import spinal.core._
import spinal.lib.{master, slave}


case class DataGenerateConfig(DATA_WIDTH: Int,  CHANNEL_WIDTH: Int, COMPUTE_CHANNEL_NUM: Int, FEATURE_WIDTH: Int, KERNEL_NUM: Int, FEATURE_RAM_ADDR_WIDTH: Int, ZERO_NUM: Int) {
    val PICTURE_NUM = 1
    val STREAM_DATA_WIDTH = DATA_WIDTH * PICTURE_NUM * COMPUTE_CHANNEL_NUM
    val paddingConfig = PaddingConfig(DATA_WIDTH, CHANNEL_WIDTH, COMPUTE_CHANNEL_NUM, FEATURE_WIDTH,ZERO_NUM)
    val featureGenerateConfig = FeatureGenerateConfig(DATA_WIDTH,  CHANNEL_WIDTH, COMPUTE_CHANNEL_NUM, FEATURE_WIDTH, KERNEL_NUM, FEATURE_RAM_ADDR_WIDTH)
}

class DataGenerate(dataGenerateConfig: DataGenerateConfig) extends Component {
    val io = new Bundle {
        val sData = slave Stream (UInt(dataGenerateConfig.STREAM_DATA_WIDTH bits))
        val start = in Bool()
        val enPadding = in Bool()
        val channelIn = in UInt (dataGenerateConfig.CHANNEL_WIDTH bits)
        val rowNumIn = in UInt (dataGenerateConfig.FEATURE_WIDTH bits)
        val colNumIn = in UInt(dataGenerateConfig.FEATURE_WIDTH bits)
        val zeroDara = in Bits (dataGenerateConfig.DATA_WIDTH bits)
        val zeroNum = in UInt (dataGenerateConfig.paddingConfig.ZERO_NUM_WIDTH bits)
        //        val mData = master(FeaturePort(dataGenerateConfig.STREAM_DATA_WIDTH, dataGenerateConfig.KERNEL_NUM))
        val mData = Vec(master Stream UInt(dataGenerateConfig.STREAM_DATA_WIDTH bits), dataGenerateConfig.KERNEL_NUM)
        val last = out Bool()
    }
    noIoPrefix()
    val padding = new Padding(dataGenerateConfig.paddingConfig)
    padding.io.sData <> io.sData
    padding.io.start <> io.start
    padding.io.enPadding <> io.enPadding
    padding.io.channelIn <> io.channelIn
    padding.io.rowNumIn <> io.rowNumIn
    padding.io.colNumIn <> io.colNumIn
    padding.io.zeroNum <> io.zeroNum
    padding.io.zeroDara <> io.zeroDara
    val featureGenerate = new FeatureGenerate(dataGenerateConfig.featureGenerateConfig)
    featureGenerate.io.mData <> io.mData
    padding >> featureGenerate
    featureGenerate.io.last <> io.last
}

object DataGenerate {
    def main(args: Array[String]): Unit = {
        SpinalConfig(
        ).generateVerilog(new DataGenerate(DataGenerateConfig(8,  12, 8, 10, 9, 11, 1)))
    }
}
