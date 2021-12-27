import spinal.core._

class add(
             A_WIDTH: Int,
             B_WIDTH: Int,
             P_WIDTH: Int
         ) extends Component {
    val io = new Bundle {
        val A = in Bits(A_WIDTH bits)
        val B = in Bits(B_WIDTH bits)
        val P = out Bits(P_WIDTH bits)

    }
    noIoPrefix()
    val A_q = io.A.asSInt
    A_q.addAttribute("use_dsp", "yes")
    val B_q = io.B.asSInt
    B_q.addAttribute("use_dsp", "yes")
    val A_qq = RegNext(A_q)
    A_qq.addAttribute("use_dsp", "yes")
    val B_qq = RegNext(B_q)
    B_qq.addAttribute("use_dsp", "yes")
    val P_q = RegNext(A_qq + B_qq)
    P_q.addAttribute("use_dsp", "yes")
//    val P_qq = RegNext(P_q)
//    P_qq.addAttribute("use_dsp", "yes")
//    io.P <> P_qq.asBits
    io.P <> P_q.asBits
}
object add{
    def main(args: Array[String]): Unit = {
        SpinalVerilog(new add(20,20,20))
    }
}
