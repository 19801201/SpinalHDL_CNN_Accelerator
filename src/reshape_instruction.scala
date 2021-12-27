import spinal.core._

class reshape_instruction(
                             RE_WIDTH_FEATURE_SIZE: Int,
                             RE_WIDTH_CHANNEL_NUM_REG: Int,
                             REG_WIDTH: Int,
                             ZERO_DATA_WIDTH: Int,
                             SCALE_DATA_WIDTH: Int
                         ) extends Component {
    val io = new Bundle {
        val Start = in Bool()
        val Reg_4 = in Bits (REG_WIDTH bits)
        val Reg_5 = in Bits (REG_WIDTH bits)
        val Reg_6 = in Bits (REG_WIDTH bits)
        val Reg_7 = in Bits (REG_WIDTH bits)
        val Reg_8 = in Bits (REG_WIDTH bits)
        val Reg_9 = in Bits (REG_WIDTH bits)

        val Row_Num_In_REG = out Bits (RE_WIDTH_FEATURE_SIZE bits)
        val Channel_RAM_Num_REG = out Bits (RE_WIDTH_CHANNEL_NUM_REG bits)
        val Row_Num_Out_REG = out Bits (RE_WIDTH_FEATURE_SIZE bits)
        val Channel_In_Num_REG = out Bits (RE_WIDTH_CHANNEL_NUM_REG bits)

        val Concat1_ZeroPoint = out Bits (ZERO_DATA_WIDTH bits)
        val Concat2_ZeroPoint = out Bits (ZERO_DATA_WIDTH bits)
        val Concat1_Scale = out Bits (SCALE_DATA_WIDTH bits)
        val Concat2_Scale = out Bits (SCALE_DATA_WIDTH bits)
    }
    noIoPrefix()

    val Re_Instruction = Bits(REG_WIDTH * 6 bits) setAsReg()
    when(io.Start) {
        Re_Instruction := io.Reg_9 ## io.Reg_8 ## io.Reg_7 ## io.Reg_6 ## io.Reg_5 ## io.Reg_4
    } otherwise {
        Re_Instruction := Re_Instruction
    }

    io.Channel_In_Num_REG := Re_Instruction(31 downto 22)
    io.Row_Num_In_REG := Re_Instruction(63 downto 53)
    io.Channel_RAM_Num_REG := Re_Instruction(52 downto 43)
    io.Row_Num_Out_REG := Re_Instruction(42 downto 32)

    io.Concat1_Scale := Re_Instruction(95 downto 64)
    io.Concat2_Scale := Re_Instruction(127 downto 96)
    io.Concat1_ZeroPoint := Re_Instruction(159 downto 128)
    io.Concat2_ZeroPoint := Re_Instruction(191 downto 160)

}
 object reshape_instruction{
     def main(args: Array[String]): Unit = {
         SpinalVerilog(new reshape_instruction(11,10,32,32,32))
     }
 }