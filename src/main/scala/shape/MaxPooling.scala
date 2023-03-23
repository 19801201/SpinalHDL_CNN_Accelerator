package shape

import conv.dataGenerate.{Padding, PaddingConfig}
import spinal.core._
import spinal.lib._
import wa.WaCounter
/*  添加pading之后MaxPooling应该可以实现任意的 k，s，p。
    为了简单实现，首先将一些应该配置的参数放在内部配置，应该放到外部实现。
    一些可配置的参数位宽应该根据不同的输入来配置数据输入的位宽，但是考虑到编译器更改指令生成比较麻烦，因此先采用固定位宽的形式。
 */

/**
 *
 * @param DATA_WIDTH
 * @param COMPUTE_CHANNEL_NUM
 * @param FEATURE
 * @param CHANNEL_WIDTH
 * @param ROW_MEM_DEPTH
 *
 *
 * 仿真测试通过K2P0S1,K2P0S2,K5P0S1,K5P1S1,K5P2S1,K5P2S2
 */


case class MaxPoolingConfig(DATA_WIDTH: Int, COMPUTE_CHANNEL_NUM: Int, FEATURE: Int, CHANNEL_WIDTH: Int, ROW_MEM_DEPTH: Int) {
    //选择的最大窗口大小，选择后只能支持2 ~ kernelSize窗口的MaxPooling运算
    val kernelSize = 5  //配置K的大小。当前最大为5最小为2，修改kernelNum的数量以支持更大的k。选择窗口的数量
    //可配置的数据位宽，用于配置补零数量，窗口大小，步长数量的位宽。
    val enStride = true //如果为真，则出现Stride信号线。
    val CONFIG_DATA_WIDTH = 3
    //数据流入的大小
    val STREAM_DATA_WIDTH = DATA_WIDTH * COMPUTE_CHANNEL_NUM
    //这个模块中一共使用kernelSize - 1个MEM储存一个点的所有通道
    val MAX_COL_NUM = 24
    val MAX_CHANNEL_NUM = 1024//最大支持的通道数量,最小的通道数量不能小于COMPUTE_CHANNEL_NUM * 2，否则地址计数可能会出错
    val channelMemDepth = MAX_CHANNEL_NUM / COMPUTE_CHANNEL_NUM //MEM的深度
    //这个模块中一共使用kernelSize - 1个MEM储存一行的所有点的所有通道
    val rowMemDepth = MAX_CHANNEL_NUM / COMPUTE_CHANNEL_NUM * MAX_COL_NUM//列数 * 通道数 / 一次进入的通道数

    val FEATURE_WIDTH = log2Up(FEATURE)

    val maxPoolingFixConfig = MaxPoolingFixConfig(DATA_WIDTH , COMPUTE_CHANNEL_NUM , FEATURE, CHANNEL_WIDTH)
    val channelMemWidth = FEATURE_WIDTH


    val paddingConfig = PaddingConfig(DATA_WIDTH, CHANNEL_WIDTH, COMPUTE_CHANNEL_NUM, FEATURE_WIDTH, 1 << (CONFIG_DATA_WIDTH - 1))
}

/**
 *
 * @param io
 * start 开始信号
 * sData 数据输入信号，数据输入顺序，通道优先，列优先，行优先
 * mData 数据输出信号，数据输出顺序，通道优先，列优先，行优先
 * rowNumIn 列数输入信号，指明输入的数据共有多少列
 * colNumIn 行数输入信号，指明输入的数据共有多少行
 * channelIn 通道数输入信号，指明输入的数据共有多少通道
 * enPadding Padding使能信号线，使能后才会启用padding对数据补零
 * zeroDara 零点值的输入数据，对0量化后的值，真正的补零数据
 * zeroNum 补零输入信号，指明补零的个数 1代表补1个0
 * kernelNum 计算窗口的大小kernelNum 为 i 时，求最大池化得到的数据为(i + 2) * (i + 2)大小的窗口的最大值
 * strideNum 本模块的步长为strideNum + 1
 */

class MaxPooling(maxPoolingConfig: MaxPoolingConfig) extends Component {
    val io = new Bundle{
        val start = in Bool()
        val sData = slave Stream UInt(maxPoolingConfig.STREAM_DATA_WIDTH bits)
        val mData = master Stream UInt(maxPoolingConfig.STREAM_DATA_WIDTH bits)
        val rowNumIn = in UInt (maxPoolingConfig.FEATURE_WIDTH bits)
        val colNumIn = in UInt (maxPoolingConfig.FEATURE_WIDTH bits)
        val channelIn = in UInt (maxPoolingConfig.CHANNEL_WIDTH bits)
        val enPadding = in Bool()
        val zeroDara = in Bits (maxPoolingConfig.DATA_WIDTH bits)
        val zeroNum = in UInt (maxPoolingConfig.CONFIG_DATA_WIDTH bits)
        val kernelNum = in UInt (maxPoolingConfig.CONFIG_DATA_WIDTH bits)
        val last = out Bool()
        val strideNum = if(maxPoolingConfig.enStride) in UInt (maxPoolingConfig.CONFIG_DATA_WIDTH bits) else null
    }
    //需要一定的时间初始化。直接延迟一段时间再开始。
    val padding = new Padding(maxPoolingConfig.paddingConfig)
    io.sData <> padding.io.sData //连接数据线
    io.enPadding <> padding.io.enPadding
    io.channelIn <> padding.io.channelIn
    io.start <> padding.io.start
    io.rowNumIn <> padding.io.rowNumIn
    io.colNumIn <> padding.io.colNumIn
    io.zeroDara <> padding.io.zeroDara
    io.zeroNum <> padding.io.zeroNum

    //maxPooling模块
    val maxPooling = new MaxPoolingFix(maxPoolingConfig)
    padding.io.mData <> maxPooling.io.sData
    maxPooling.io.mData <> io.mData
    maxPooling.io.start <> Delay(io.start,3)
    io.channelIn <> maxPooling.io.channelIn
    padding.io.rowNumOut <> maxPooling.io.rowNumIn
    padding.io.colNumOut <> maxPooling.io.colNumIn
    maxPooling.io.kernelNum <> io.kernelNum
    io.last <> maxPooling.io.last
    if(maxPoolingConfig.enStride){
        maxPooling.io.strideNum <> io.strideNum
    }
}

object MaxPooling extends App {
    SpinalVerilog(new MaxPooling(MaxPoolingConfig(8, 8, 100, 10, 1024)))
}
