import spinal.core._
import spinal.lib._

class Conv_quan(
                   S_DATA_WIDTH: Int,
                   M_DATA_WIDTH: Int,
                   BIAS_NUM_WIDTH: Int,
                   BIAS_DATA_WIDTH: Int,
                   SCALE_DATA_WIDTH: Int,
                   SHIFT_DATA_WIDTH: Int,
                   ZERO_DATA_WIDTH: Int,
                   ROW_COL_DATA_COUNT_WIDTH: Int,
                   CHANNEL_OUT_NUM: Int,
                   CHANNEL_NUM_WIDTH: Int,
                   BIAS_FIFO_DEPTH: Int
               ) extends Component {
    val io = new Bundle {
        val Strat = in Bool()
        val S_DATA = slave Stream Bits(S_DATA_WIDTH bits)
        val bias_data_in = in Bits (BIAS_DATA_WIDTH bits)
        val scale_data_in = in Bits (SCALE_DATA_WIDTH bits)
        val shift_data_in = in Bits (SHIFT_DATA_WIDTH bits)
        val Zero_Point_REG3 = in Bits (ZERO_DATA_WIDTH bits)
        val bias_addrb = out Bits (BIAS_NUM_WIDTH bits)
        val M_DATA = master Stream Bits(M_DATA_WIDTH bits)
        val Row_Num_Out_REG = in Bits (ROW_COL_DATA_COUNT_WIDTH bits)
        val Channel_Out_Num_REG = in Bits (CHANNEL_NUM_WIDTH bits)
        val Leaky_REG = in Bool()

    }
    noIoPrefix()

    val quan_ctrl = new Conv_quan_ctrl(ROW_COL_DATA_COUNT_WIDTH, BIAS_NUM_WIDTH, CHANNEL_NUM_WIDTH, CHANNEL_OUT_NUM)
    quan_ctrl.io.Start <> io.Strat
    quan_ctrl.io.bias_addrb <> io.bias_addrb
    quan_ctrl.io.M_Ready <> io.M_DATA.ready
    quan_ctrl.io.M_Valid <> io.M_DATA.valid
    quan_ctrl.io.Row_Num_Out_REG <> io.Row_Num_Out_REG
    quan_ctrl.io.Channel_Out_Num_REG <> io.Channel_Out_Num_REG
    quan_ctrl.io.Leaky_REG <> io.Leaky_REG

    val bias = new Conv_Bias(S_DATA_WIDTH, S_DATA_WIDTH, ROW_COL_DATA_COUNT_WIDTH, BIAS_DATA_WIDTH, CHANNEL_NUM_WIDTH, CHANNEL_OUT_NUM, BIAS_FIFO_DEPTH)
    bias.io.S_DATA <> io.S_DATA
    bias.io.fifo_ready <> quan_ctrl.io.Fifo_Ready
    bias.io.rd_en_fifo <> quan_ctrl.io.EN_Rd_Fifo
    bias.io.Channel_Out_Num_REG <> io.Channel_Out_Num_REG
    bias.io.S_Count_Fifo := quan_ctrl.io.S_Count_Fifo
    bias.io.bias_data_in <> io.bias_data_in

    val scale = new Conv_scale(S_DATA_WIDTH, SCALE_DATA_WIDTH, CHANNEL_OUT_NUM)
    scale.io.S_Data <> bias.io.M_Data
    scale.io.Scale_Data_In := Delay(io.scale_data_in, 2)

    val AFTER_SHIFT_WIDTH = S_DATA_WIDTH / 2
    val shift = new Conv_shift(S_DATA_WIDTH, AFTER_SHIFT_WIDTH, SHIFT_DATA_WIDTH, CHANNEL_OUT_NUM)
    shift.io.data_in <> scale.io.M_Data
    shift.io.shift_data_in <> Delay(io.shift_data_in, 5)


    val ZERO_M_DATA_WIDTH = ZERO_DATA_WIDTH * CHANNEL_OUT_NUM
    val zero = new Conv_zero(AFTER_SHIFT_WIDTH, ZERO_M_DATA_WIDTH, ZERO_DATA_WIDTH, CHANNEL_OUT_NUM)
    zero.io.data_in <> shift.io.data_out
    zero.io.zero_data_in <> io.Zero_Point_REG3

    val leaky = new Conv_leaky_relu(ZERO_M_DATA_WIDTH, M_DATA_WIDTH, ZERO_DATA_WIDTH, CHANNEL_OUT_NUM)
    leaky.io.data_in <> zero.io.data_out
    leaky.io.zero_point <> io.Zero_Point_REG3

    when(!io.Leaky_REG) {
        leaky.io.data_out <> io.M_DATA.payload
    } otherwise {
        zero.io.data_out <> io.M_DATA.payload
    }

}

object Conv_quan {
    def main(args: Array[String]): Unit = {
        SpinalConfig(
            defaultConfigForClockDomains = ClockDomainConfig(clockEdge = RISING, resetKind = SYNC),
            oneFilePerComponent = true,
            headerWithDate = true,
            targetDirectory = "verilog"

        ) generateVerilog (new Conv_quan(256, 64, 8, 256, 256, 256, 8, 11, 8, 10, 4096))
        SpinalConfig(
            defaultConfigForClockDomains = ClockDomainConfig(clockEdge = RISING, resetKind = SYNC),
            headerWithDate = true,
            targetDirectory = "verilog"

        ) generateVerilog (new leaky_relu(8, 8, 8))
    }
}
