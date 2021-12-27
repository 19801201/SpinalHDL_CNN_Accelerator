import spinal.core._
import spinal.lib._
import xip._
import scala.math.pow

class leaky_relu(
                    S_DATA_WIDTH: Int,
                    ZERO_POINT_WIDTH: Int,
                    M_DATA_WIDTH: Int
                ) extends Component {

    val io = new Bundle {
        val data_in = in Bits (S_DATA_WIDTH bits)
        val zero_data_in = in Bits (ZERO_POINT_WIDTH bits)
        val data_out = out Bits (M_DATA_WIDTH bits) setAsReg()
    }
    noIoPrefix()
    val DATA_WIDTH_TEMP = 16
    val data_after1 = RegNext(io.data_in.resize(DATA_WIDTH_TEMP bits))
    val sub_zero = new xsub(DATA_WIDTH_TEMP, ZERO_POINT_WIDTH, DATA_WIDTH_TEMP, this.clockDomain,"sub_16_u8")
    sub_zero.io.A <> data_after1
    sub_zero.io.B <> io.zero_data_in
    val MUL_LEAKY_POW = 17
    val MUL_LEAKY_DATA = B((0.1 * pow(2, MUL_LEAKY_POW)).toInt)
    val mul_leaky = new xmul(DATA_WIDTH_TEMP, MUL_LEAKY_DATA.getWidth, DATA_WIDTH_TEMP + MUL_LEAKY_DATA.getWidth, this.clockDomain).setDefinitionName("mult_leaky")
    mul_leaky.io.A <> sub_zero.io.S
    mul_leaky.io.B <> MUL_LEAKY_DATA

    val data_after_zero = Delay(sub_zero.io.S, 4)
    val data_after_mul = Bits(DATA_WIDTH_TEMP bits) setAsReg()
    val temp_data = Bits(DATA_WIDTH_TEMP - (DATA_WIDTH_TEMP + MUL_LEAKY_DATA.getWidth - MUL_LEAKY_POW) bits).setAll()
    val odd_temp = ((temp_data ## mul_leaky.io.P(DATA_WIDTH_TEMP + MUL_LEAKY_DATA.getWidth - 1 downto MUL_LEAKY_POW)).asUInt + 1).asBits
    val even_temp = temp_data ## mul_leaky.io.P(DATA_WIDTH_TEMP + MUL_LEAKY_DATA.getWidth - 1 downto MUL_LEAKY_POW)
    when(mul_leaky.io.P(MUL_LEAKY_POW - 1 downto 0).asUInt <= U"b01111101011100001") {
        data_after_mul := even_temp
    } elsewhen (mul_leaky.io.P(MUL_LEAKY_POW - 1 downto 0).asUInt >= U"b10000010100011110") {
        data_after_mul := odd_temp
    } otherwise {
        when(mul_leaky.io.P(MUL_LEAKY_POW)) {
            data_after_mul := odd_temp
        } otherwise {
            data_after_mul := even_temp
        }
    }
    val data_negative = Bits(DATA_WIDTH_TEMP bits)
    when(data_after_zero(DATA_WIDTH_TEMP - 1)) {
        data_negative := data_after_mul
    } otherwise {
        data_negative := data_after_zero
    }
    val add_zero = new xadd(DATA_WIDTH_TEMP, ZERO_POINT_WIDTH, DATA_WIDTH_TEMP, this.clockDomain,"add_16_u8_16")
    add_zero.io.A <> data_negative
    add_zero.io.B <> io.zero_data_in
    when(add_zero.io.S(DATA_WIDTH_TEMP-1)){
        io.data_out.clearAll()
    } elsewhen(add_zero.io.S(DATA_WIDTH_TEMP - 2 downto DATA_WIDTH_TEMP / 2).orR){
        io.data_out.setAll()
    } otherwise{
        io.data_out<>add_zero.io.S(DATA_WIDTH_TEMP / 2 - 1 downto 0)
    }


}

object leaky_relu {
    def main(args: Array[String]): Unit = {
        SpinalVerilog(new leaky_relu(8, 8, 8))
    }
}