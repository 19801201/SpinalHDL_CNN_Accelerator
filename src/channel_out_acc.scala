import spinal.core._

class channel_out_acc(
                         S_DATA_WIDTH: Int,
                         M_DATA_WIDTH: Int
                     ) extends Component {

    val io = new Bundle {
        val data_in = in Bits (S_DATA_WIDTH bits)
        val data_out = out Bits (M_DATA_WIDTH bits) setAsReg() init (0)
        val First_Compute_Complete = in Bool()
    }
    noIoPrefix()
    when(io.First_Compute_Complete) {
        io.data_out := io.data_in
    } otherwise {
        io.data_out := (io.data_out.asUInt + io.data_in.asUInt).asBits
    }
}

object channel_out_acc {
    def main(args: Array[String]): Unit = {
        SpinalVerilog(new channel_out_acc(32, 32))
    }
}
