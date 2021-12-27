import spinal.core._

class max_pooling_compute(
                             S_DATA_WIDTH: Int,
                             CHANNEL_OUT_NUM: Int
                         ) extends Component {

    val io = new Bundle {
        val data_in = in Vec(Bits(S_DATA_WIDTH bits), 4)
        val data_out = out Bits (S_DATA_WIDTH bits) setAsReg()
    }
    noIoPrefix()

    val DATA_WIDTH = S_DATA_WIDTH / CHANNEL_OUT_NUM

    def compare_maxpooling(in1: Bits, in2: Bits, in3: Bits, in4: Bits): Bits = {
        val out = Bits(DATA_WIDTH bits)
        val temp = Vec(UInt(DATA_WIDTH bits) setAsReg(), 2)

        def compare(comp1: UInt, comp2: UInt): UInt = {
            val temp = UInt(DATA_WIDTH bits)
            when(comp1 >= comp2) {
                temp := comp1
            } otherwise {
                temp := comp2
            }
            temp
        }

        temp(0) := compare(in1.asUInt, in2.asUInt)
        temp(1) := compare(in3.asUInt, in4.asUInt)
        out := compare(temp(0), temp(1)).asBits
        out
    }

    for (i <- 0 until CHANNEL_OUT_NUM) {
        io.data_out((i + 1) * DATA_WIDTH - 1 downto i * DATA_WIDTH) := compare_maxpooling(io.data_in(0)((i + 1) * DATA_WIDTH - 1 downto i * DATA_WIDTH), io.data_in(1)((i + 1) * DATA_WIDTH - 1 downto i * DATA_WIDTH), io.data_in(2)((i + 1) * DATA_WIDTH - 1 downto i * DATA_WIDTH), io.data_in(3)((i + 1) * DATA_WIDTH - 1 downto i * DATA_WIDTH))
    }
}

object max_pooling_compute {
    def main(args: Array[String]): Unit = {
        SpinalVerilog(new max_pooling_compute(64, 8))
    }
}
