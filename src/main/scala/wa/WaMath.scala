package wa

import spinal.core._
import spinal.lib._

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

object xMul {
    def apply(A_WIDTH: Int, B_WIDTH: Int, P_WIDTH: Int, clk: ClockDomain) = new xMulB(A_WIDTH, B_WIDTH, P_WIDTH, clk)

    def apply(A_WIDTH: Int, B_WIDTH: Int, P_WIDTH: Int) = new xMulC(A_WIDTH, B_WIDTH, P_WIDTH)
}


class xMulB(
               A_WIDTH: Int,
               B_WIDTH: Int,
               P_WIDTH: Int,
               clk: ClockDomain
           ) extends BlackBox {
    val io = new Bundle {
        val A = in UInt (A_WIDTH bits)
        val B = in UInt (B_WIDTH bits)
        val P = out UInt (P_WIDTH bits)
        val CLK = in Bool()
    }
    noIoPrefix()
    mapClockDomain(clk, io.CLK)
}

class xMulC(
               A_WIDTH: Int,
               B_WIDTH: Int,
               P_WIDTH: Int
           ) extends Component {
    val io = new Bundle {
        val A = in UInt (A_WIDTH bits)
        val B = in UInt (B_WIDTH bits)
        val P = out UInt (P_WIDTH bits)
    }
    noIoPrefix()
    val tempOut = UInt(P_WIDTH bits)
    val mul = new xMulB(A_WIDTH = A_WIDTH, B_WIDTH = B_WIDTH, P_WIDTH = P_WIDTH, clk = this.clockDomain)
    mul.io.A <> io.A
    mul.io.B <> io.B
    mul.io.P <> tempOut
    val a = Reg(UInt(16 bits))
    val b = Reg(UInt(16 bits))
    val c = Reg(UInt(16 bits))
    when(io.A(7)) {
        a := U"8'hFF" * io.B
        b := (a << 8).resized
        c := b
    } otherwise {
        a := 0
        b := a
        c := b
    }
    io.P := tempOut + c


}

class xAdd(
              A_WIDTH: Int,
              B_WIDTH: Int,
              S_WIDTH: Int,
              clk: ClockDomain
          ) extends BlackBox {
    val io = new Bundle {
        val A = in Bits (A_WIDTH bits)
        val B = in Bits (B_WIDTH bits)
        val S = out Bits (S_WIDTH bits)
        val CLK = in Bool()
    }
    noIoPrefix()
    mapClockDomain(clk, io.CLK)
}

object xAdd {
    def apply(A_WIDTH: Int, S_WIDTH: Int, ADD_NUM: Int) = new xAddTimes(A_WIDTH, S_WIDTH, ADD_NUM)
    def apply(A_WIDTH: Int, S_WIDTH: Int) = new xAddChannelTimes(A_WIDTH, S_WIDTH)
}

class xAddTimes(
                   A_WIDTH: Int,
                   S_WIDTH: Int,
                   ADD_NUM: Int
               ) extends Component {
    val io = new Bundle {
        val A = in Vec(SInt(A_WIDTH bits), ADD_NUM)
        val S = out SInt (S_WIDTH bits)
    }
    noIoPrefix()
    val a1Temp = Vec(SInt(A_WIDTH / 2 bits), ADD_NUM)
    val a2Temp = Vec(SInt(A_WIDTH / 2 bits), ADD_NUM)
    (0 until ADD_NUM).foreach(i => {
        a1Temp(i) := io.A(i)((A_WIDTH / 2 - 1) downto 0)
        a2Temp(i) := io.A(i)(A_WIDTH - 1 downto A_WIDTH / 2)
    })
    io.S := a2Temp.reduceBalancedTree(_ +^ _, (s, l) => RegNext(s)) @@ a1Temp.reduceBalancedTree(_ +^ _, (s, l) => RegNext(s))
}


class xAddChannelTimes(
                          A_WIDTH: Int,
                          S_WIDTH: Int
                      ) extends Component {
    val io = new Bundle {
        val A = in SInt (A_WIDTH bits)
        val S = out(Reg(SInt(S_WIDTH bits))) init 0
        val init = in Bool()
    }
    noIoPrefix()
    when(io.init) {
        io.S := io.A.resized
    } otherwise {
        io.S := (io.A + io.S).resized
    }
}


//class xAddChannelIn(
//                       A_WIDTH: Int,
//                       S_WIDTH: Int,
//                       CHANNEL_IN_NUM: Int
//                   ) extends Component {
//    val io = new Bundle {
//        val A = in Vec(SInt(A_WIDTH bits), CHANNEL_IN_NUM)
//        val S = out SInt (S_WIDTH bits)
//    }
//    noIoPrefix()
//    io.S := io.A.reduceBalancedTree(_ +^ _, (s, l) => RegNext(s))
//}


object ttt extends App {
    //    val clk = ClockDomainConfig(resetKind = BOOT)
    //    SpinalConfig(defaultConfigForClockDomains = clk).generateVerilog(xMul(24, 8, 32))
    val i = 32
//    SpinalVerilog(xAdd(40, 40 + 2 * (if (i == 1) 0 else log2Up(i)), i))
    SpinalVerilog(xAdd(20,32))
}
