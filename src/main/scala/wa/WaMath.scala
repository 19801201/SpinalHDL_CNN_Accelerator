package wa

import spinal.core._

case class WaMul(A_WIDTH: Int, B_WIDTH: Int, P_WIDTH: Int) extends Component {
    val io = new Bundle {
        val a = in SInt (A_WIDTH bits)
        val b = in SInt (B_WIDTH bits)
        val p = out SInt (P_WIDTH bits)
    }
    noIoPrefix()
    val clk = ClockDomain(clock = this.clockDomain.clock) {
        val a_temp = RegNext(io.a).addAttribute("use_dsp", "yes")
        val b_temp = RegNext(io.b).addAttribute("use_dsp", "yes")
        val p_temp = RegNext(RegNext(a_temp * b_temp).addAttribute("use_dsp", "yes")).addAttribute("use_dsp", "yes")
        io.p := p_temp
    }

}

class xMul(
              A_WIDTH: Int,
              B_WIDTH: Int,
              P_WIDTH: Int,
              clk: ClockDomain
          ) extends BlackBox {
    val io = new Bundle {
        val A = in UInt  (A_WIDTH bits)
        val B = in UInt (B_WIDTH bits)
        val P = out UInt (P_WIDTH bits)
        val CLK = in Bool()
    }
    noIoPrefix()
    mapClockDomain(clk, io.CLK)
}

object ttt extends App {
    val clk = ClockDomainConfig(resetKind = BOOT)
    SpinalConfig(defaultConfigForClockDomains = clk).generateVerilog(WaMul(10, 10, 20))
    //SpinalVerilog(WaMul(10, 10, 20))
}
