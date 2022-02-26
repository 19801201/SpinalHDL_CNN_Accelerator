package shape

import spinal.core._
import spinal.lib._

case class ShapePort(streamDataWidth: Int, featureWidth: Int, channelWidth: Int) extends Bundle {
    val start = in Bool()
    val fifoReady = in Bool()
    val sData = slave Stream UInt(streamDataWidth bits)
    val mData = master Stream UInt(streamDataWidth bits)
    val rowNumIn = in UInt (featureWidth bits)
    val colNumIn = in UInt (featureWidth bits)
    val channelIn = in UInt (channelWidth bits)
}
