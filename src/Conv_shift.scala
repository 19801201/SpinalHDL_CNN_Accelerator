import spinal.core._

class Conv_shift(
                    S_DATA_WIDTH: Int,
                    M_DATA_WIDTH: Int,
                    SHIFT_DATA_WIDTH: Int,
                    CHANNEL_OUT_NUM: Int
                ) extends Component {
    val io = new Bundle {
        val shift_data_in = in Bits (SHIFT_DATA_WIDTH bits)
        val data_in = in Bits (S_DATA_WIDTH bits)
        val data_out = out Bits (M_DATA_WIDTH bits)
    }
    noIoPrefix()
    val DATA_WIDTH_IN = S_DATA_WIDTH / CHANNEL_OUT_NUM
    val DATA_WIDTH_OUT = M_DATA_WIDTH / CHANNEL_OUT_NUM
    val SHIFT_DATA_IN = SHIFT_DATA_WIDTH / CHANNEL_OUT_NUM
    var shift_list: List[shift] = Nil
    for (_ <- 0 until CHANNEL_OUT_NUM) {
        shift_list = new shift(DATA_WIDTH_IN, DATA_WIDTH_OUT) :: shift_list
    }
    shift_list = shift_list.reverse
    for (i <- 0 until CHANNEL_OUT_NUM) {
        shift_list(i).io.data_in <> io.data_in((i + 1) * DATA_WIDTH_IN - 1 downto i * DATA_WIDTH_IN)
        shift_list(i).io.shift_data_in <> io.shift_data_in((i + 1) * SHIFT_DATA_IN - 1 downto i * SHIFT_DATA_IN)
        shift_list(i).io.data_out <> io.data_out((i + 1) * DATA_WIDTH_OUT - 1 downto i * DATA_WIDTH_OUT)
    }

}
