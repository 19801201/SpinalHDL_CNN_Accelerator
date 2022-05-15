package TbCfg

import conv.compute.CONV_STATE

object SimType {
    val CONV = 0
    val SHAPE = 1
}

case class SimConfig(
                        rowNumIn: Int,
                        colNumIn: Int,
                        channelIn: Int,
                        channelOut: Int,
                        enPadding: Boolean,
                        enActivation: Boolean,
                        zeroDara: Int,
                        zeroNum: Int,
                        quanZeroData: Int,
                        convType: Int = CONV_STATE.CONV33,
                        weightMemDepth: Int,
                        featureMemDepth: Int,
                        enStride: Boolean,
                        simType: Int = SimType.CONV,
                        weightMemFileName: String = "",
                        featureMemFileName: String = "",
                        featureMemFileName1: String = ""
                    ) {

}
