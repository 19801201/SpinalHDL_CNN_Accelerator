import spinal.core._
import xip._

class image_quan_zero(
                         S_DATA_WIDTH: Int,
                         ZERO_DATA_WIDTH: Int,
                         M_DATA_WIDTH: Int,
                         COMPUTE_CHANNEL_OUT_NUM: Int
                     ) extends Component {

    val io = new Bundle {
        val data_in = in Bits (S_DATA_WIDTH bits)
        val zero_data_in = in Bits (ZERO_DATA_WIDTH bits)
        val data_out = out Bits (M_DATA_WIDTH bits) setAsReg() init 0
    }
    noIoPrefix()
    val add_clk = ClockDomain(clock = this.clockDomain.clock)
    val ADD_DATA_WIDTH = S_DATA_WIDTH / COMPUTE_CHANNEL_OUT_NUM
    val add_out_temp = Vec(Bits(ADD_DATA_WIDTH bits), COMPUTE_CHANNEL_OUT_NUM)
    var add_list: List[xadd] = Nil
    for (_ <- 0 until COMPUTE_CHANNEL_OUT_NUM) {
        add_list = new xadd(ADD_DATA_WIDTH, ZERO_DATA_WIDTH, ADD_DATA_WIDTH, add_clk,"add_16_u8_16") :: add_list
    }
    add_list = add_list.reverse
    for (i <- 0 until COMPUTE_CHANNEL_OUT_NUM) {
        add_list(i).io.A <> io.data_in((i + 1) * ADD_DATA_WIDTH - 1 downto i * ADD_DATA_WIDTH)
        add_list(i).io.B <> io.zero_data_in
        add_list(i).io.S <> add_out_temp(i)
    }

    for (i <- 0 until COMPUTE_CHANNEL_OUT_NUM) {
        when(add_out_temp(i)(ADD_DATA_WIDTH - 1)) {
            io.data_out((i + 1) * ADD_DATA_WIDTH / 2 - 1 downto i * ADD_DATA_WIDTH / 2).clearAll()
        } elsewhen add_out_temp(i)(ADD_DATA_WIDTH - 2 downto ADD_DATA_WIDTH / 2).orR {
            io.data_out((i + 1) * ADD_DATA_WIDTH / 2 - 1 downto i * ADD_DATA_WIDTH / 2).setAll()
        } otherwise {
            io.data_out((i + 1) * ADD_DATA_WIDTH / 2 - 1 downto i * ADD_DATA_WIDTH / 2) := add_out_temp(i)(ADD_DATA_WIDTH / 2 - 1 downto 0)
        }
    }
}

object image_quan_zero {
    def main(args: Array[String]): Unit = {
        SpinalVerilog(new image_quan_zero(64, 8, 32, 4))
    }
}
