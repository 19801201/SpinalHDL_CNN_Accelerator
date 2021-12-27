import spinal.core._
import util.leaky_relu
//下一步让进来的数据不经过zero模块
class image_leaky_relu(
                          S_DATA_WIDTH: Int,
                          ZERO_POINT_WIDTH: Int,
                          M_DATA_WIDTH: Int,
                          COMPUTE_CHANNEL_OUT_NUM: Int
                      ) extends Component {
    val io = new Bundle {
        val data_in = in Bits (S_DATA_WIDTH bits)
        val zero_data_in = in Bits (ZERO_POINT_WIDTH bits)
        val data_out = out Bits (M_DATA_WIDTH bits)
    }
    noIoPrefix()
    val LEAKY_S_DATA_WIDTH = S_DATA_WIDTH/COMPUTE_CHANNEL_OUT_NUM
    val LEAKY_M_DATA_WIDTH = M_DATA_WIDTH/COMPUTE_CHANNEL_OUT_NUM
    val leaky_clk = ClockDomain(this.clockDomain.clock)
    var leaky_list:List[util.leaky_relu]=Nil
    for (_ <- 0 until COMPUTE_CHANNEL_OUT_NUM) {
        leaky_list = new util.leaky_relu(LEAKY_S_DATA_WIDTH,ZERO_POINT_WIDTH,LEAKY_M_DATA_WIDTH,leaky_clk)::leaky_list
    }
    leaky_list = leaky_list.reverse
    for (i <- 0 until COMPUTE_CHANNEL_OUT_NUM) {
        leaky_list(i).io.data_in <> io.data_in((i+1)*LEAKY_S_DATA_WIDTH -1 downto i*LEAKY_S_DATA_WIDTH)
        leaky_list(i).io.zero_data_in <> io.zero_data_in
        leaky_list(i).io.data_out <> io.data_out((i+1)*LEAKY_S_DATA_WIDTH -1 downto i*LEAKY_S_DATA_WIDTH)
    }
}

object image_leaky_relu{
    def main(args: Array[String]): Unit = {
        SpinalConfig(
            defaultConfigForClockDomains = ClockDomainConfig(clockEdge = RISING, resetKind = SYNC),
            oneFilePerComponent = true,
            headerWithDate = true
//            targetDirectory = "verilog"

        )generateVerilog(new image_leaky_relu(64,8,64,8))
        //SpinalVerilog(new image_leaky_relu(64,8,64,8))
    }
}
