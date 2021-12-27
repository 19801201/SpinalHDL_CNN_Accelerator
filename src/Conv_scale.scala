import spinal.core._
import xip._

class Conv_scale(
                    S_DATA_WIDTH: Int,
                    SCALE_DATA_WIDTH: Int,
                    CHANNEL_OUT_NUM: Int
                ) extends Component {
    val io = new Bundle {
        val S_Data = in Bits (S_DATA_WIDTH bits)
        val Scale_Data_In = in Bits (SCALE_DATA_WIDTH bits)
        val M_Data = out Bits (S_DATA_WIDTH bits)
    }
    noIoPrefix()
    val mul_clk = ClockDomain(this.clockDomain.clock)
    val DATA_WIDTH = S_DATA_WIDTH / CHANNEL_OUT_NUM
    var scale_list: List[xmul] = Nil
    for (_ <- 0 until CHANNEL_OUT_NUM) {
        scale_list = new xmul(DATA_WIDTH, DATA_WIDTH, DATA_WIDTH, mul_clk).setDefinitionName("xmul_32_32") :: scale_list
    }
    scale_list = scale_list.reverse
    for (i <- 0 until CHANNEL_OUT_NUM) {
        scale_list(i).io.A <> io.S_Data((i + 1) * DATA_WIDTH - 1 downto i * DATA_WIDTH)
        scale_list(i).io.B <> io.Scale_Data_In((i + 1) * DATA_WIDTH - 1 downto i * DATA_WIDTH)
        scale_list(i).io.P <> io.M_Data((i + 1) * DATA_WIDTH - 1 downto i * DATA_WIDTH)
    }

}
