package conv.dataGenerate

import spinal.core._
import spinal.lib._
import conv._
import conv.dataGenerate._
import conv.compute._
import config.Config._

class ChannelIncr(convConfig: ConvConfig) extends Component {

    val sDataWidth = if (useFocus) {
        4 * convConfig.DATA_WIDTH * (if (imageType.dataType == imageType.rgb) 3 else if (imageType.dataType == imageType.gray) 1 else {
            assert(false, "imageType不正确");
            0
        })
    } else {
        if (imageType.dataType == imageType.rgb) {
            4 * convConfig.DATA_WIDTH
        } else if (imageType.dataType == imageType.gray) {
            1 * convConfig.DATA_WIDTH
        } else {
            assert(false, "imageType不正确");
            0
        }
    }

    val io = new Bundle {
        val sData = slave Stream (UInt(sDataWidth bits))
        val mData = master Stream (UInt(convConfig.FEATURE_S_DATA_WIDTH bits))
    }
    noIoPrefix()
//    StreamWidthAdapter(io.sData,io.mData,padding=true)
    io.mData.ready <> io.sData.ready
    io.mData.valid <> io.sData.valid
    io.mData.payload := io.sData.payload.resized
}

object ChannelIncr extends App {
    SpinalVerilog(new ChannelIncr(ConvConfig(8, 8, 8, 12, 8192, 512, 416, 2048, 1)))
}
