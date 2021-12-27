import spinal.core._
import xip.xmul

class concat_scale(
                      S_DATA_WIDTH: Int,
                      CHANNEL_NUM: Int,
                      SCALE_DATA_WIDTH: Int
                  ) extends Component {
    val io = new Bundle {
        val data_in = in Bits (S_DATA_WIDTH bits)
        val scale = in Bits (SCALE_DATA_WIDTH bits)
        val data_out = out Bits (S_DATA_WIDTH bits)
    }
    noIoPrefix()

    val mul_clk = ClockDomain(this.clockDomain.clock)
    val DATA_WIDTH = S_DATA_WIDTH / CHANNEL_NUM
    val data_temp = Vec(Bits((DATA_WIDTH + 1) bits), CHANNEL_NUM)
    var scale_list: List[xmul] = Nil
    for (_ <- 0 until CHANNEL_NUM) {
        scale_list = new xmul(DATA_WIDTH, DATA_WIDTH, DATA_WIDTH + 1, mul_clk).setDefinitionName("xmul_32_32_33") :: scale_list
    }
    scale_list = scale_list.reverse
    for (i <- 0 until CHANNEL_NUM) {
        scale_list(i).io.A <> io.data_in((i + 1) * DATA_WIDTH - 1 downto i * DATA_WIDTH)
        scale_list(i).io.B <> io.scale
        scale_list(i).io.P <> data_temp(i)
    }

    for (i <- 0 until CHANNEL_NUM) {
        when(data_temp(i)(0)) {
            io.data_out((i + 1) * 32 - 1 downto i * 32) := (data_temp(i)(32 downto 1).asUInt + 1).asBits
        } otherwise {
            io.data_out((i + 1) * 32 - 1 downto i * 32) := data_temp(i)(32 downto 1)
        }
    }

}
