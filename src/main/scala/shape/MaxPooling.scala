package shape

import conv.dataGenerate.{Padding, PaddingConfig}
import spinal.core._
import spinal.lib._
import wa.WaCounter
/*  添加pading之后MaxPooling应该可以实现任意的 k，s，p。
    为了简单实现，首先将一些应该配置的参数放在内部配置，应该放到外部实现。
    一些可配置的参数位宽应该根据不同的输入来配置数据输入的位宽，但是考虑到编译器更改指令生成比较麻烦，因此先采用固定位宽的形式。
 */


case class MaxPoolingConfig(DATA_WIDTH: Int, COMPUTE_CHANNEL_NUM: Int, FEATURE: Int, CHANNEL_WIDTH: Int, ROW_MEM_DEPTH: Int) {
    val ZERO_NUM = 3 //需要扩展
    val STREAM_DATA_WIDTH = DATA_WIDTH * COMPUTE_CHANNEL_NUM
    val FEATURE_WIDTH = log2Up(FEATURE)
    val channelMemDepth = 512 / COMPUTE_CHANNEL_NUM //最多支持512通道
    val maxPoolingFixConfig = MaxPoolingFixConfig(DATA_WIDTH , COMPUTE_CHANNEL_NUM , FEATURE, CHANNEL_WIDTH)
    val paddingConfig = PaddingConfig(DATA_WIDTH, CHANNEL_WIDTH, COMPUTE_CHANNEL_NUM, FEATURE_WIDTH, ZERO_NUM)
}

class MaxPooling(maxPoolingConfig: MaxPoolingConfig) extends Component {
    val io = ShapePort(maxPoolingConfig.STREAM_DATA_WIDTH, maxPoolingConfig.FEATURE_WIDTH, maxPoolingConfig.CHANNEL_WIDTH)
    noIoPrefix()
    val enPadding = in Bool()
    val zeroDara = in Bits (maxPoolingConfig.DATA_WIDTH bits)
    val zeroNum = in UInt (maxPoolingConfig.ZERO_NUM bits)
    val kernelNum = in UInt (3 bits)
    val strideNum = if(maxPoolingConfig.maxPoolingFixConfig.enStride) in UInt (3 bits) else null

    //需要一定的时间初始化。直接延迟一段时间再开始。
    val padding = new Padding(maxPoolingConfig.paddingConfig)
    io.sData <> padding.io.sData //连接数据线
    enPadding <> padding.io.enPadding
    io.channelIn <> padding.io.channelIn
    io.start <> padding.io.start
    io.rowNumIn <> padding.io.rowNumIn
    io.colNumIn <> padding.io.colNumIn
    zeroDara <> padding.io.zeroDara
    zeroNum <> padding.io.zeroNum

    //maxPooling模块
    val maxPooling = new MaxPoolingFix(maxPoolingConfig.maxPoolingFixConfig)
    padding.io.mData <> maxPooling.io.sData
    maxPooling.io.mData <> io.mData
    maxPooling.io.start <> Delay(io.start,3)
    io.channelIn <> maxPooling.io.channelIn
    padding.io.rowNumOut <> maxPooling.io.rowNumIn
    padding.io.colNumOut <> maxPooling.io.colNumIn
    maxPooling.io.kernelNum <> kernelNum
    if(maxPoolingConfig.maxPoolingFixConfig.enStride){
        maxPooling.io.strideNum <> strideNum
    }
}

object MaxPooling extends App {
    SpinalVerilog(new MaxPooling(MaxPoolingConfig(8, 8, 100, 10, 1024)))
}
