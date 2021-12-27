package xip

import spinal.core._

class xadd(
              A_WIDTH: Int,
              B_WIDTH: Int,
              S_WIDTH: Int,
              clk: ClockDomain,
              name: String
          ) extends BlackBox {
    val io = new Bundle {
        val A = in Bits (A_WIDTH bits)
        val B = in Bits (B_WIDTH bits)
        val S = out Bits (S_WIDTH bits)
        val CLK = in Bool()
    }
    noIoPrefix()
    mapClockDomain(clk, io.CLK)
    this.setDefinitionName(name)

}
