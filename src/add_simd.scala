import spinal.core._

class add_simd(A_WIDTH: Int,
               B_WIDTH: Int,
               P_WIDTH: Int) extends Component {
    val io = new Bundle {
        val A = in Bits (A_WIDTH bits)
        val B = in Bits (B_WIDTH bits)
        val P = out Bits (P_WIDTH bits)

    }
    noIoPrefix()
    val add = new add(A_WIDTH, B_WIDTH, P_WIDTH)
    add.io.A <> io.A
    add.io.B <> io.B
    add.io.P <> io.P
}
