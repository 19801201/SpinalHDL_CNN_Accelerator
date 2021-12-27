import spinal.core._
import spinal.lib._

class Conv_Bias(
                   S_DATA_WIDTH: Int,
                   M_DATA_WIDTH: Int,
                   ROW_COL_DATA_COUNT_WIDTH: Int,
                   BIAS_DATA_WIDTH: Int,
                   CHANNEL_NUM_WIDTH: Int,
                   CHANNEL_OUT_NUM: Int,
                   BIAS_FIFO_DEPTH: Int
               ) extends Component {
    val io = new Bundle {
        val S_DATA = slave Stream Bits(S_DATA_WIDTH bits)
        val fifo_ready = out Bool()
        val rd_en_fifo = in Bool()
        val bias_data_in = in Bits (BIAS_DATA_WIDTH bits)
        val M_Data = out Bits (M_DATA_WIDTH bits)
        val Channel_Out_Num_REG = in Bits (CHANNEL_NUM_WIDTH bits)
        val S_Count_Fifo = in Bits (ROW_COL_DATA_COUNT_WIDTH bits)
    }
    noIoPrefix()
    val Channel_Times = io.Channel_Out_Num_REG >> log2Up(CHANNEL_OUT_NUM)
    val data_fifo_out = Bits(S_DATA_WIDTH bits)
    val fifo = new general_fifo_sync(S_DATA_WIDTH, S_DATA_WIDTH, BIAS_FIFO_DEPTH, ROW_COL_DATA_COUNT_WIDTH)
    fifo.io.data_in <> io.S_DATA.payload
    fifo.io.wr_en <> io.S_DATA.valid
    fifo.io.rd_en <> io.rd_en_fifo
    fifo.io.data_out <> data_fifo_out
    fifo.io.m_data_count <> io.S_Count_Fifo.asUInt.resized
    fifo.io.s_data_count <> io.S_Count_Fifo.asUInt.resized
    fifo.io.data_in_ready <> io.S_DATA.ready
    fifo.io.data_out_valid <> io.fifo_ready

    val DATA_WIDTH = S_DATA_WIDTH / CHANNEL_OUT_NUM
    var bias_add: List[add_simd] = Nil
    for (_ <- 0 until CHANNEL_OUT_NUM) {
        bias_add = new add_simd(DATA_WIDTH, DATA_WIDTH, DATA_WIDTH) :: bias_add
    }
    bias_add = bias_add.reverse
    for (i <- 0 until CHANNEL_OUT_NUM) {
        bias_add(i).io.A <> data_fifo_out((i + 1) * DATA_WIDTH - 1 downto i * DATA_WIDTH)
        bias_add(i).io.B <> io.bias_data_in((i + 1) * DATA_WIDTH - 1 downto i * DATA_WIDTH)
        bias_add(i).io.P <> io.M_Data((i + 1) * DATA_WIDTH - 1 downto i * DATA_WIDTH)
    }


}
