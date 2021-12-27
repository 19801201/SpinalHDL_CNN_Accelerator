import spinal.core._

class channel_in_one_times_acc(
                                  S_DATA_WIDTH: Int,
                                  M_DATA_WIDTH: Int

                              ) extends Component {

    val io = new Bundle {
        val data_in = in Bits (S_DATA_WIDTH bits)
        val data_out = out Bits (M_DATA_WIDTH bits)
    }
    noIoPrefix()
    io.data_out := io.data_in.asSInt.resize(M_DATA_WIDTH bits).asBits

}
