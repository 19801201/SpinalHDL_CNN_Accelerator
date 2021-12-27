import spinal.core._

class channel_in_acc(
                        CHANNEL_IN_NUM: Int,
                        S_DATA_WIDTH: Int,
                        M_DATA_WIDTH: Int
                    ) extends Component {

    val io = new Bundle {
        val data_in = in Bits (S_DATA_WIDTH bits)
        val data_out = out Bits (M_DATA_WIDTH bits)
    }
    noIoPrefix()
    CHANNEL_IN_NUM match {
        case 1 =>
            val temp = new channel_in_one_times_acc(S_DATA_WIDTH, M_DATA_WIDTH)
            temp.io.data_in <> io.data_in
            temp.io.data_out <> io.data_out
        case 2 =>
            val temp = new channel_in_two_times_acc(CHANNEL_IN_NUM, S_DATA_WIDTH, M_DATA_WIDTH)
            temp.io.data_in <> io.data_in
            temp.io.data_out <> io.data_out
        case 4 =>
            val temp = new channel_in_four_times_acc(CHANNEL_IN_NUM, S_DATA_WIDTH, M_DATA_WIDTH)
            temp.io.data_in <> io.data_in
            temp.io.data_out <> io.data_out
        case 8 =>
            val temp = new channel_in_eight_times_acc(CHANNEL_IN_NUM, S_DATA_WIDTH, M_DATA_WIDTH)
            temp.io.data_in <> io.data_in
            temp.io.data_out <> io.data_out
        case 16 =>
            val temp = new channel_in_sixteen_times_acc(CHANNEL_IN_NUM, S_DATA_WIDTH, M_DATA_WIDTH)
            temp.io.data_in <> io.data_in
            temp.io.data_out <> io.data_out
        case 32 =>
            val temp = new channel_in_thirty_two_times_acc(CHANNEL_IN_NUM, S_DATA_WIDTH, M_DATA_WIDTH)
            temp.io.data_in <> io.data_in
            temp.io.data_out <> io.data_out
        case _ =>
            assert(false, "暂不支持1，2，4，7，16，32外的其他模式")
    }
}

object channel_in_acc {
    def main(args: Array[String]): Unit = {
        SpinalVerilog(new channel_in_acc(16, 20*16, 32))
    }
}
