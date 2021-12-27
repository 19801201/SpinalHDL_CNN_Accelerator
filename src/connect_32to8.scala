import spinal.core._

class connect_32to8(
                       S_DATA_WIDTH: Int,
                       CHANNEL_NUM: Int,
                       M_DATA_WIDTH: Int
                   ) extends Component {

    val io = new Bundle {
        val data_in = in Bits (S_DATA_WIDTH bits)
        val data_out = out Bits (M_DATA_WIDTH bits)
    }
    noIoPrefix()

    def to8(in: Bits): Bits = {
        val out = Bits(8 bits) setAsReg()
        when(in(31)) {
            out.clearAll()
        } elsewhen (in(30 downto 8).orR) {
            out.setAll()
        } otherwise {
            out := in(7 downto 0)
        }
        out
    }

    for (i <- 0 until CHANNEL_NUM) {
        io.data_out((i + 1) * 8 - 1 downto i * 8) := to8(io.data_in((i + 1) * 32 - 1 downto i * 32))
    }
}

object connect_32to8 {
    def main(args: Array[String]): Unit = {
        SpinalVerilog(new connect_32to8(32 * 8, 8, 8 * 8))
    }
}
