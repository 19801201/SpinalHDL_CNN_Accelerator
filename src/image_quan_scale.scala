import spinal.core._
import xip._
class image_quan_scale(
                     S_DATA_WIDTH: Int,
                     ROW_COL_DATA_COUNT_WIDTH: Int,
                     CHANNEL_OUT_TIMES: Int,
                     COMPUTE_CHANNEL_OUT_NUM: Int
                 ) extends Component {
    val io = new Bundle {
        val S_DATA = in Bits (S_DATA_WIDTH bits)
        val scale_data_in = in Bits (S_DATA_WIDTH bits)
        val M_DATA = out Bits (S_DATA_WIDTH bits)
    }
    noIoPrefix()
    val DATA_WIDTH = S_DATA_WIDTH / COMPUTE_CHANNEL_OUT_NUM
    val mul_clk = ClockDomain(this.clockDomain.clock)
    var mul_list: List[xmul] = Nil
    for (_ <- 0 until COMPUTE_CHANNEL_OUT_NUM) {
        mul_list = new xmul(DATA_WIDTH, DATA_WIDTH,DATA_WIDTH,mul_clk).setDefinitionName("xmul_32_32") :: mul_list
    }
    mul_list = mul_list.reverse
    for (i <- 0 until COMPUTE_CHANNEL_OUT_NUM) {
        mul_list(i).io.A <> io.S_DATA((i+1)*DATA_WIDTH-1 downto i*DATA_WIDTH)
        mul_list(i).io.B <> io.scale_data_in((i+1)*DATA_WIDTH-1 downto i*DATA_WIDTH)
        mul_list(i).io.P <> io.M_DATA((i+1)*DATA_WIDTH-1 downto i*DATA_WIDTH)
    }
}
object image_quan_scale{
    def main(args: Array[String]): Unit = {
        SpinalVerilog(new image_quan_scale(256,12,4,8))
    }
}
