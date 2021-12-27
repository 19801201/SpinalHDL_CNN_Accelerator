import spinal.core._
import xip._
class mul_simd (
               S_DATA_WIDTH:Int,
               M_DATA_WIDTH:Int
               )extends Component {
    val io = new Bundle {
        val data_in = in Bits(S_DATA_WIDTH bits)
        val weight_in = in Bits(S_DATA_WIDTH bits)
        val data_out = out Bits(M_DATA_WIDTH bits)
    }

    val mult_8_8_16 = new xmul(S_DATA_WIDTH,S_DATA_WIDTH,S_DATA_WIDTH+S_DATA_WIDTH,this.clockDomain).setDefinitionName("mult_8_8_16")
    mult_8_8_16.io.A <> io.data_in
    mult_8_8_16.io.B <> io.weight_in
    val data_out_q = RegNext(mult_8_8_16.io.P.asSInt.resize(M_DATA_WIDTH))
    io.data_out <> data_out_q.asBits
    noIoPrefix()
}
object mul_simd{
    def main(args: Array[String]): Unit = {
        SpinalVerilog(new mul_simd(8,20))
    }
}