package conv.compute

import conv.dataGenerate.DataGenerateConfig
import spinal.core.log2Up

object ConvType {
    val conv33 = "conv33"
    val conv11 = "conv11"
}


/**
 *
 * @param DATA_WIDTH              数据位宽，8bit
 * @param COMPUTE_CHANNEL_IN_NUM  一次可计算的一个卷积核的通道数
 * @param COMPUTE_CHANNEL_OUT_NUM 一次可计算的卷积核数量
 * @param MAX_CHANNEL_IN          支持的最大的卷积核通道数
 * @param MAX_CHANNEL_OUT         支持的最大的卷积核数量
 *
 */
case class ConvConfig(DATA_WIDTH: Int, COMPUTE_CHANNEL_IN_NUM: Int, COMPUTE_CHANNEL_OUT_NUM: Int, CHANNEL_WIDTH: Int, WEIGHT_DEPTH: Int, QUAN_DEPTH: Int, FEATURE: Int, FEATURE_RAM_DEPTH: Int, ZERO_NUM: Int) {
    //conv_typy由io控制，这里按conv33生成配置，conv11复用conv33资源
    val CONV_TYPE: String = ConvType.conv33
    require(CONV_TYPE == ConvType.conv33 || CONV_TYPE == ConvType.conv11, "CONV_TYPE只支持conv33和conv11类型")
    val KERNEL_NUM = CONV_TYPE match {
        case ConvType.conv33 => 9
        case ConvType.conv11 => 1
        case _ => -1
    }
    val FEATURE_WIDTH = log2Up(FEATURE)
    val PICTURE_NUM = 1
    val FEATURE_S_DATA_WIDTH = DATA_WIDTH * COMPUTE_CHANNEL_IN_NUM * PICTURE_NUM
    //    val FEATURE_NINE_DEPTH =
    val FEATURE_M_DATA_WIDTH = DATA_WIDTH * COMPUTE_CHANNEL_OUT_NUM * PICTURE_NUM
    val WEIGHT_S_DATA_WIDTH = DATA_WIDTH * COMPUTE_CHANNEL_IN_NUM * PICTURE_NUM
    val WEIGHT_S_DATA_DEPTH = WEIGHT_DEPTH
    val WEIGHT_M_DATA_WIDTH = DATA_WIDTH * COMPUTE_CHANNEL_IN_NUM * COMPUTE_CHANNEL_OUT_NUM
    val WEIGHT_M_DATA_DEPTH = WEIGHT_S_DATA_WIDTH * WEIGHT_S_DATA_DEPTH / WEIGHT_M_DATA_WIDTH
    val QUAN_S_DATA_WIDTH = DATA_WIDTH * COMPUTE_CHANNEL_IN_NUM * PICTURE_NUM
    val QUAN_S_DATA_DEPTH = QUAN_DEPTH
    val QUAN_M_DATA_WIDTH = 32 * COMPUTE_CHANNEL_OUT_NUM
    val QUAN_M_DATA_DEPTH = QUAN_S_DATA_WIDTH * QUAN_S_DATA_DEPTH / QUAN_M_DATA_WIDTH

    val FEATURE_MEM_DEPTH = 512 / COMPUTE_CHANNEL_IN_NUM //最大支持到图片为512通道

    val mulWeightWidth = 32
    val addKernelWidth = CONV_TYPE match {
        case ConvType.conv33 => 40
        case ConvType.conv11 => 32
        case _ => -1
    }
    val addChannelInWidth = addKernelWidth + 2 * (if (COMPUTE_CHANNEL_IN_NUM == 1) 0 else log2Up(COMPUTE_CHANNEL_IN_NUM))
    val addChannelTimesWidth = 32

    val leakyRatio = 0.1

    val dataGenerateConfig = DataGenerateConfig(DATA_WIDTH, CHANNEL_WIDTH, COMPUTE_CHANNEL_IN_NUM, FEATURE_WIDTH, KERNEL_NUM, FEATURE_RAM_DEPTH, ZERO_NUM)

}
