import spinal.core._

class Conv_leaky_relu(
                         S_DATA_WIDTH: Int,
                         M_DATA_WIDTH: Int,
                         ZERO_DATA_WIDTH: Int,
                         CHANNEL_OUT_NUM: Int
                     ) extends Component {

    val io = new Bundle {
        val data_in = in Bits (S_DATA_WIDTH bits)
        val zero_point = in Bits (ZERO_DATA_WIDTH bits)
        val data_out = out Bits (M_DATA_WIDTH bits)
    }
    noIoPrefix()
    val DATA_WIDTH_IN = S_DATA_WIDTH / CHANNEL_OUT_NUM
    val DATA_WIDTH_OUT = M_DATA_WIDTH / CHANNEL_OUT_NUM
    val leaky_clk = ClockDomain(this.clockDomain.clock)
    var leaky_list: List[util.leaky_relu] = Nil
    for (_ <- 0 until CHANNEL_OUT_NUM) {
        leaky_list = new util.leaky_relu(DATA_WIDTH_IN, ZERO_DATA_WIDTH, DATA_WIDTH_OUT, leaky_clk) :: leaky_list
    }
    leaky_list = leaky_list.reverse

    for (i <- 0 until CHANNEL_OUT_NUM) {
        leaky_list(i).io.data_in <> io.data_in((i + 1) * DATA_WIDTH_IN - 1 downto i * DATA_WIDTH_IN)
        leaky_list(i).io.zero_data_in <> io.zero_point
        leaky_list(i).io.data_out <> io.data_out((i + 1) * DATA_WIDTH_OUT - 1 downto i * DATA_WIDTH_OUT)
    }

}
