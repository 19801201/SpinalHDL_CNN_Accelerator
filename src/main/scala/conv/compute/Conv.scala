package conv.compute

import conv.dataGenerate._
import spinal.core._
import spinal.lib._
import wa._
import xmemory._





class Conv(convConfig: ConvConfig) extends Component {
    val io = new Bundle {
        val sData = Vec(slave Stream UInt(convConfig.FEATURE_S_DATA_WIDTH bits), convConfig.KERNEL_NUM)
        val mData = master Stream UInt(convConfig.FEATURE_M_DATA_WIDTH bits)
        val start = in Bool()


    }
    noIoPrefix()

    val convState = ConvState(convConfig)


}





//object Conv {
//    def main(args: Array[String]): Unit = {
//        SpinalVerilog(ConvState(ConvConfig(8, 16, 8, 12, 2048, 512, 640, 2048, ConvType.conv33)))
//    }
//}
