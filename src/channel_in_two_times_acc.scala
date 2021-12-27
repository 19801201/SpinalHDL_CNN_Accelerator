import spinal.core._
import xip._

class channel_in_two_times_acc(
                                  CHANNEL_IN_NUM: Int,
                                  S_DATA_WIDTH: Int,
                                  M_DATA_WIDTH: Int
                              ) extends Component {
    val io = new Bundle {
        val data_in = in Bits (S_DATA_WIDTH bits)
        val data_out = out Bits (M_DATA_WIDTH bits)
    }
    noIoPrefix()
    val add_32_32 = new xadd(M_DATA_WIDTH, M_DATA_WIDTH, M_DATA_WIDTH, this.clockDomain, "add_32_32")
    val temp_t = io.data_in.subdivideIn(CHANNEL_IN_NUM slices)
    val temp = Vec(Bits(M_DATA_WIDTH bits),CHANNEL_IN_NUM)
    for (i <- 0 until CHANNEL_IN_NUM){
        temp(i) := temp_t(i).asSInt.resize(M_DATA_WIDTH bits).asBits
    }
    add_32_32.io.A <> temp(1)
    add_32_32.io.B <> temp(0)
    add_32_32.io.S <> io.data_out

}

object channel_in_two_times_acc {
    def main(args: Array[String]): Unit = {
        SpinalVerilog(new channel_in_two_times_acc(2, 128, 64))
    }
}
