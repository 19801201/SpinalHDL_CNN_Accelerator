package shape.post_pocessing

import spinal.core._
import spinal.lib._
import config.Config._
import java.io.File


case class PocessingConfig(DATA_WIDTH: Int, COMPUTE_CHANNEL_NUM: Int) {

    val STREAM_DATA_WIDTH = DATA_WIDTH * COMPUTE_CHANNEL_NUM
    val FLOW_DATA_WIDTH = DATA_WIDTH * 6
    val FLOAT_DATA_WIDTH = 32

    val CHANNEL_IN = 48
    val CHANNEL_IN_TIMES = CHANNEL_IN / COMPUTE_CHANNEL_NUM


    val CHANNEL_WIDTH = 6

    val HEAD_WIDTH = 2
    val FEATURE_WIDTH = 7
    val P3_ROW_COL_NUM = 80
    val P4_ROW_COL_NUM = 40
    val P5_ROW_COL_NUM = 20

    val MEM_DEPTH = 16

}

