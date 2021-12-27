import spinal.core._

class concat_zero(
                      S_DATA_WIDTH: Int,
                      CHANNEL_NUM: Int,
                      ZERO_DATA_WIDTH: Int
                  ) extends Component {
    val io = new Bundle {
        val data_in = in Bits (S_DATA_WIDTH bits)
        val zero = in Bits (ZERO_DATA_WIDTH bits)
        val data_out = out Bits (S_DATA_WIDTH bits)
    }
    noIoPrefix()
    val DATA_WIDTH = S_DATA_WIDTH / CHANNEL_NUM
    var bias_add: List[add_simd] = Nil
    for (_ <- 0 until CHANNEL_NUM) {
        bias_add = new add_simd(DATA_WIDTH, DATA_WIDTH, DATA_WIDTH) :: bias_add
    }
    bias_add = bias_add.reverse
    for (i <- 0 until CHANNEL_NUM) {
        bias_add(i).io.A <> io.data_in((i + 1) * DATA_WIDTH - 1 downto i * DATA_WIDTH)
        bias_add(i).io.B <> io.zero
        bias_add(i).io.P <> io.data_out((i + 1) * DATA_WIDTH - 1 downto i * DATA_WIDTH)
    }
}
