import spinal.core._
import xip._

class channel_in_four_times_acc(
                                   CHANNEL_IN_NUM: Int,
                                   S_DATA_WIDTH: Int,
                                   M_DATA_WIDTH: Int
                               ) extends Component {
    val io = new Bundle {
        val data_in = in Bits (S_DATA_WIDTH bits)
        val data_out = out Bits (M_DATA_WIDTH bits)
    }
    noIoPrefix()
    var add_list: List[xadd] = Nil
    for (_ <- 0 until 3) {
        add_list = new xadd(M_DATA_WIDTH, M_DATA_WIDTH, M_DATA_WIDTH, this.clockDomain, "add_32_32") :: add_list
    }
    add_list = add_list.reverse
    val temp_t = io.data_in.subdivideIn(CHANNEL_IN_NUM slices)
    val temp = Vec(Bits(M_DATA_WIDTH bits),CHANNEL_IN_NUM)
    for (i <- 0 until CHANNEL_IN_NUM){
        temp(i) := temp_t(i).asSInt.resize(M_DATA_WIDTH bits).asBits
    }
    for (i <- 0 until 2) {
        add_list(i).io.A <> temp(i * 2)
        add_list(i).io.B <> temp(i * 2 + 1)
    }
    add_list(2).io.A := add_list(0).io.S
    add_list(2).io.B := add_list(1).io.S
    add_list(2).io.S <> io.data_out
}

object channel_in_four_times_acc {
    def main(args: Array[String]): Unit = {
        SpinalVerilog(new channel_in_four_times_acc(4, 32, 8))
    }
}
