import spinal.core._
import xip._

class Conv_zero(
                   S_DATA_WIDTH: Int,
                   M_DATA_WIDTH: Int,
                   ZERO_DATA_WIDTH: Int,
                   CHANNEL_OUT_NUM: Int
               ) extends Component {
    val io = new Bundle {
        val data_in = in Bits (S_DATA_WIDTH bits)
        val zero_data_in = in Bits (ZERO_DATA_WIDTH bits)
        val data_out = out Bits (M_DATA_WIDTH bits) setAsReg()
    }
    noIoPrefix()

    val DATA_IN = S_DATA_WIDTH / CHANNEL_OUT_NUM
    val DATA_OUT = M_DATA_WIDTH / CHANNEL_OUT_NUM
    val add_out_temp = Vec(Bits(DATA_IN bits), CHANNEL_OUT_NUM)
    val add_clk = ClockDomain(clock = this.clockDomain.clock)
    var zero_list: List[xadd] = Nil
    for (_ <- 0 until CHANNEL_OUT_NUM) {
        zero_list = new xadd(DATA_IN, ZERO_DATA_WIDTH, DATA_IN, add_clk, "add_16_u8_16") :: zero_list
    }
    zero_list = zero_list.reverse
    for (i <- 0 until CHANNEL_OUT_NUM) {
        zero_list(i).io.A <> io.data_in((i + 1) * DATA_IN - 1 downto i * DATA_IN)
        zero_list(i).io.B <> io.zero_data_in
        zero_list(i).io.S <> add_out_temp(i)
    }
    for (i <- 0 until CHANNEL_OUT_NUM) {
        when(add_out_temp(i)(DATA_IN - 1)) {
            io.data_out((i + 1) * DATA_OUT - 1 downto i * DATA_OUT).clearAll()
        } elsewhen add_out_temp(i)(DATA_IN - 2 downto DATA_IN / 2).orR {
            io.data_out((i + 1) * DATA_OUT - 1 downto i * DATA_OUT).setAll()
        } otherwise {
            io.data_out((i + 1) * DATA_OUT - 1 downto i * DATA_OUT) <> add_out_temp(i)(DATA_OUT - 1 downto 0)
        }
    }

}
