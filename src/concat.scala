import spinal.core._
import spinal.lib._

class concat(
                RE_WIDTH_FEATURE_SIZE: Int,
                RE_WIDTH_CHANNEL_NUM_REG: Int,
                RE_WIDTH_CONNECT_TIMES: Int,
                REG_WIDTH: Int,
                ZERO_DATA_WIDTH: Int,
                SCALE_DATA_WIDTH: Int,
                S_DATA_WIDTH: Int,
                M_DATA_WIDTH: Int,
                RE_CHANNEL_IN_NUM: Int,
                CONNECT_S_FIFO1_DEPTH: Int,
                CONNECT_S_FIFO2_DEPTH: Int,
                CONNECT_M_FIFO_DEPTH: Int
            ) extends Component {
    val io = new Bundle {
        val Start = in Bool()
        val Reg_4 = in Bits (REG_WIDTH bits)
        val Reg_5 = in Bits (REG_WIDTH bits)
        val Reg_6 = in Bits (REG_WIDTH bits)
        val Reg_7 = in Bits (REG_WIDTH bits)
        val Reg_8 = in Bits (REG_WIDTH bits)
        val Reg_9 = in Bits (REG_WIDTH bits)

        val S_DATA_1 = slave Stream Bits(S_DATA_WIDTH bits)
        val S_DATA_2 = slave Stream Bits(S_DATA_WIDTH bits)
        val M_DATA = master Stream Bits(M_DATA_WIDTH bits)

        val Last_Concat = out Bool()
    }
    noIoPrefix()
    val reshape_instruction = new reshape_instruction(RE_WIDTH_FEATURE_SIZE, RE_WIDTH_CHANNEL_NUM_REG, REG_WIDTH, ZERO_DATA_WIDTH, SCALE_DATA_WIDTH)
    reshape_instruction.io.Start <> io.Start
    reshape_instruction.io.Reg_4 <> io.Reg_4
    reshape_instruction.io.Reg_5 <> io.Reg_5
    reshape_instruction.io.Reg_6 <> io.Reg_6
    reshape_instruction.io.Reg_7 <> io.Reg_7
    reshape_instruction.io.Reg_8 <> io.Reg_8
    reshape_instruction.io.Reg_9 <> io.Reg_9

    val concat_final = new concat_final(RE_CHANNEL_IN_NUM, RE_WIDTH_FEATURE_SIZE, RE_WIDTH_CHANNEL_NUM_REG, RE_WIDTH_CONNECT_TIMES, S_DATA_WIDTH, M_DATA_WIDTH, ZERO_DATA_WIDTH, SCALE_DATA_WIDTH, CONNECT_S_FIFO1_DEPTH, CONNECT_S_FIFO2_DEPTH, CONNECT_M_FIFO_DEPTH)
    concat_final.io.Start <> io.Start
    concat_final.io.Row_Num_Out_REG <> reshape_instruction.io.Row_Num_Out_REG
    concat_final.io.Channel_Ram_Part <> reshape_instruction.io.Channel_RAM_Num_REG
    concat_final.io.Channel_Direct_Part <> reshape_instruction.io.Channel_In_Num_REG
    concat_final.io.Row_Num_In_REG <> reshape_instruction.io.Row_Num_In_REG
    concat_final.io.S_DATA_1 <> io.S_DATA_1
    concat_final.io.S_DATA_2 <> io.S_DATA_2
    concat_final.io.M_DATA <> io.M_DATA
    concat_final.io.Concat2_ZeroPoint <> reshape_instruction.io.Concat2_ZeroPoint
    concat_final.io.Concat1_ZeroPoint <> reshape_instruction.io.Concat1_ZeroPoint
    concat_final.io.Concat1_Scale <> reshape_instruction.io.Concat1_Scale
    concat_final.io.Concat2_Scale <> reshape_instruction.io.Concat2_Scale
    concat_final.io.Last_Concat <> io.Last_Concat
}
object concat{
    def main(args: Array[String]): Unit = {
        SpinalConfig(
            defaultConfigForClockDomains =  ClockDomainConfig(clockEdge = RISING, resetKind = SYNC),
            targetDirectory = "verilog",
            oneFilePerComponent = true
        ).generateVerilog(new concat(11,10,15,32,32,32,64,64,8,2048,2048,1024))
    }
}

