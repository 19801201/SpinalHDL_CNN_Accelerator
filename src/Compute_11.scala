import spinal.core._
import spinal.lib._

class Compute_11(
                    KERNEL_NUM: Int,
                    REG_WIDTH: Int,
                    S_DATA_WIDTH: Int,
                    PARA_DATA_WIDTH: Int,
                    M_DATA_WIDTH: Int,
                    DATA_WIDTH: Int,
                    ROW_COL_DATA_COUNT_WIDTH: Int,
                    CHANNEL_NUM_WIDTH: Int,
                    ZERO_NUM_WIDTH: Int,
                    ZERO_POINT_DATA_WIDTH: Int,
                    WEIGHT_ADDR_WIDTH: Int,
                    WEIGHT_NUM_WIDTH: Int,
                    BIAS_NUM_WIDTH: Int,
                    BIAS_DATA_WIDTH: Int,
                    SCALE_DATA_WIDTH: Int,
                    SHIFT_DATA_WIDTH: Int,
                    CHANNEL_IN_NUM: Int,
                    CHANNEL_OUT_NUM: Int,
                    WIDTH_TEMP_RAM_ADDR: Int,
                    FEATURE_FIFO_DEPTH: Int,
                    WEIGHT_MEM_WRITE_DEPTH: Int,
                    QUAN_DATA_GENERATE_MEM_WRITE_DEPTH: Int,
                    QUAN_BIAS_FIFO_DEPTH: Int,
                    STRIDE_MEM_DEPTH: Int
                ) extends Component {

    val io = new Bundle {
        val Conv_Complete = out Bool()
        val Stride_Complete = out Bool()
        val Write_Block_Complete = out Bool()
        val Sign = in Bits (3 bits)
        val Reg_4 = in Bits (REG_WIDTH bits)
        val Reg_5 = in Bits (REG_WIDTH bits)
        val Reg_6 = in Bits (REG_WIDTH bits)
        val Reg_7 = in Bits (REG_WIDTH bits)
        val S_DATA = slave Stream Bits(S_DATA_WIDTH bits)
        val para_data = slave Stream Bits(PARA_DATA_WIDTH bits)
        val M_DATA = master Stream Bits(M_DATA_WIDTH bits)
        val Start_Pa = in Bool()
        val Start_Cu = in Bool()
        val Last_11 = out Bool()
    }
    noIoPrefix()

    val Cu_Instruction_reg = Bits(REG_WIDTH * 4 bits) setAsReg()
    val Cu_Instruction = Bits(REG_WIDTH * 4 bits) setAsReg()
    Cu_Instruction_reg := RegNext(io.Reg_7 ## io.Reg_6 ## io.Reg_5 ## io.Reg_4)
    val Para_Instruction_reg = Bits(REG_WIDTH * 2 bits) setAsReg()
    val Para_Instruction = Bits(REG_WIDTH * 2 bits) setAsReg()
    Para_Instruction_reg := RegNext(io.Reg_4 ## io.Reg_5)
    switch(io.Sign) {
        is(1) {
            Cu_Instruction := Cu_Instruction_reg
        }
        is(2) {
            Para_Instruction := Para_Instruction_reg
        }
        default {
            Cu_Instruction := Cu_Instruction
            Para_Instruction := Para_Instruction
        }
    }

    val Zero_Point_REG1 = Cu_Instruction(127 downto 120)
    val Zero_Point_REG3 = Cu_Instruction(119 downto 112)


    val EN_Cin_Select_REG = Cu_Instruction(63)
    val Padding_REG = Cu_Instruction(62)
    val Stride_REG = Cu_Instruction(61)
    val Zero_Num_REG = Cu_Instruction(60 downto 58)
    val Leaky_REG = Cu_Instruction(57)      //True为不做Leaky
    val Row_Num_In_REG = Cu_Instruction(42 downto 32)
    val Channel_In_Num_REG = Cu_Instruction(31 downto 22)
    val Row_Num_Out_REG = Cu_Instruction(21 downto 11)
    val Channel_Out_Num_REG = Cu_Instruction(9 downto 0)

    val Weight_Num_REG = Para_Instruction(63 downto 48)
    val Bias_Num_REG = Para_Instruction(39)##Para_Instruction(47 downto 40)

    val AFTER_CONV_NORM_WIDTH = 32 * CHANNEL_OUT_NUM
    val conv_norm = new Conv_Norm(KERNEL_NUM, PARA_DATA_WIDTH, S_DATA_WIDTH, AFTER_CONV_NORM_WIDTH, ROW_COL_DATA_COUNT_WIDTH, CHANNEL_NUM_WIDTH, WEIGHT_ADDR_WIDTH, WEIGHT_NUM_WIDTH, BIAS_NUM_WIDTH, BIAS_DATA_WIDTH, SCALE_DATA_WIDTH, SHIFT_DATA_WIDTH, CHANNEL_IN_NUM, CHANNEL_OUT_NUM, WIDTH_TEMP_RAM_ADDR, FEATURE_FIFO_DEPTH, WEIGHT_MEM_WRITE_DEPTH, QUAN_DATA_GENERATE_MEM_WRITE_DEPTH, DATA_WIDTH)
    conv_norm.io.Start_Cu <> io.Start_Cu
    conv_norm.io.Start_Pa <> io.Start_Pa
    conv_norm.io.para_data <> io.para_data
    conv_norm.io.S_DATA <> io.S_DATA.payload
    conv_norm.io.S_DATA_Valid <> io.S_DATA.valid.asBits
    conv_norm.io.S_DATA_Ready <> io.S_DATA.ready
    conv_norm.io.Write_Block_Complete <> io.Write_Block_Complete
    conv_norm.io.Compute_Complete <> io.Conv_Complete
    conv_norm.io.Row_Num_Out_REG <> Row_Num_Out_REG.resized
    conv_norm.io.Channel_In_Num_REG <> Channel_In_Num_REG
    conv_norm.io.Channel_Out_Num_REG <> Channel_Out_Num_REG
    conv_norm.io.Weight_Single_Num_REG <> Weight_Num_REG
    conv_norm.io.Bias_Num_REG <> Bias_Num_REG.resized

    val conv_quan = new Conv_quan(AFTER_CONV_NORM_WIDTH, M_DATA_WIDTH, BIAS_NUM_WIDTH, BIAS_DATA_WIDTH, SCALE_DATA_WIDTH, SHIFT_DATA_WIDTH, ZERO_POINT_DATA_WIDTH, ROW_COL_DATA_COUNT_WIDTH, CHANNEL_OUT_NUM, CHANNEL_NUM_WIDTH, QUAN_BIAS_FIFO_DEPTH)
    conv_quan.io.S_DATA <> conv_norm.io.M_DATA
    conv_quan.io.Strat <> io.Start_Cu
    conv_quan.io.bias_data_in <> conv_norm.io.Data_Out_Bias
    conv_quan.io.scale_data_in <> conv_norm.io.Data_Out_Scale
    conv_quan.io.shift_data_in <> conv_norm.io.Data_Out_Shift
    conv_quan.io.Zero_Point_REG3 <> Zero_Point_REG3
    conv_quan.io.bias_addrb <> conv_norm.io.Bias_Addrb
    conv_quan.io.Row_Num_Out_REG <> Row_Num_Out_REG.resized
    conv_quan.io.Channel_Out_Num_REG <> Channel_Out_Num_REG
    conv_quan.io.Leaky_REG <> Leaky_REG

    val conv_stride = new Conv_Stride(M_DATA_WIDTH, M_DATA_WIDTH, CHANNEL_NUM_WIDTH, CHANNEL_OUT_NUM, STRIDE_MEM_DEPTH)
    conv_stride.io.Start <> io.Start_Cu
    conv_stride.io.S_DATA <> conv_quan.io.M_DATA
    conv_stride.io.EN_Stride_REG <> Stride_REG
    conv_stride.io.M_DATA <> io.M_DATA
    conv_stride.io.Row_Num_Out_REG <> Row_Num_Out_REG.resized
    conv_stride.io.Channel_Out_Num_REG <> Channel_Out_Num_REG
    conv_stride.io.Last <> io.Last_11
    conv_stride.io.Stride_Complete <> io.Stride_Complete
}

object Compute_11{
    def main(args: Array[String]): Unit = {
        SpinalConfig(
            defaultConfigForClockDomains = ClockDomainConfig(clockEdge = RISING, resetKind = SYNC),
            oneFilePerComponent = true,

            //            headerWithDate = true,
            targetDirectory = "verilog"

        ) generateVerilog (new Compute_11(1, 32, 64, 64, 64, 8, 12, 10, 3, 8, 15, 16, 9, 256, 256, 256, 32, 8, 12, 4096, 32768, 256, 4096, 4096))
        SpinalConfig(
            defaultConfigForClockDomains = ClockDomainConfig(clockEdge = RISING, resetKind = SYNC),
            headerWithDate = true,
            targetDirectory = "verilog"

        ) generateVerilog (new leaky_relu(8, 8, 8))
    }
}
