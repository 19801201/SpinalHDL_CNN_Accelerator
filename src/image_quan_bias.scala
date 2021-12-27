import spinal.core._
import spinal.lib._

class image_quan_bias(
                         FEATURE_MAP_SIZE: Int,
                         S_DATA_WIDTH: Int,
                         ROW_COL_DATA_COUNT_WIDTH: Int,
                         CHANNEL_OUT_TIMES: Int,
                         COMPUTE_CHANNEL_OUT_NUM: Int
                     ) extends Component {
    val io = new Bundle {
        val S_DATA = slave Stream Bits(S_DATA_WIDTH bits)
        val rd_en_fifo = in Bool()
        val bias_data_in = in Bits (S_DATA_WIDTH bits)
        val fifo_valid = out Bool()
        val M_Data = out Bits (S_DATA_WIDTH bits)
    }
    noIoPrefix()
    val bias_fifo = new general_fifo_sync(S_DATA_WIDTH, S_DATA_WIDTH,FEATURE_MAP_SIZE * CHANNEL_OUT_TIMES, ROW_COL_DATA_COUNT_WIDTH)
    bias_fifo.io.data_in <> io.S_DATA.payload
    bias_fifo.io.wr_en <> io.S_DATA.valid
    bias_fifo.io.data_in_ready <> io.S_DATA.ready
    bias_fifo.io.rd_en <> io.rd_en_fifo
    bias_fifo.io.data_out_valid <> io.fifo_valid
    //后期改参数传
    bias_fifo.io.m_data_count <> FEATURE_MAP_SIZE * CHANNEL_OUT_TIMES
    bias_fifo.io.s_data_count <> FEATURE_MAP_SIZE * CHANNEL_OUT_TIMES
    val data_out_fifo_delay = Delay(bias_fifo.io.data_out, 2)
    var add_list: List[add_simd] = Nil
    val DATA_WIDTH = S_DATA_WIDTH / COMPUTE_CHANNEL_OUT_NUM
    for (_ <- 0 until COMPUTE_CHANNEL_OUT_NUM) {
        add_list = new add_simd(DATA_WIDTH, DATA_WIDTH, DATA_WIDTH) :: add_list
    }
    add_list = add_list.reverse
    for (i <- 0 until COMPUTE_CHANNEL_OUT_NUM){
        add_list(i).io.A <> data_out_fifo_delay((i+1)*DATA_WIDTH-1 downto i*DATA_WIDTH)
        add_list(i).io.B <> io.bias_data_in((i+1)*DATA_WIDTH-1 downto i*DATA_WIDTH)
        add_list(i).io.P <> io.M_Data((i+1)*DATA_WIDTH-1 downto i*DATA_WIDTH)
    }
}
object image_quan_bias{
    def main(args: Array[String]): Unit = {
        SpinalVerilog(new image_quan_bias(640,256,12,4,8))
    }
}
