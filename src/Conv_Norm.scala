import spinal.core._
import spinal.lib._
import xmemory._

class Conv_Norm(
                   KERNEL_NUM: Int,
                   PARA_DATA_WIDTH: Int,
                   S_DATA_WIDTH: Int,
                   M_DATA_WIDTH: Int,
                   ROW_COL_DATA_COUNT_WIDTH: Int,
                   CHANNEL_NUM_WIDTH: Int,
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
                   LOAD_BIAS_MEM_WRITE_DEPTH: Int,
                   DATA_WIDTH: Int
               ) extends Component {
    val io = new Bundle {
        val Start_Cu = in Bool()
        val Start_Pa = in Bool()
        val para_data = slave Stream Bits(PARA_DATA_WIDTH bits)
        val Write_Block_Complete = out Bool()
        val Compute_Complete = out Bool()
        val S_DATA = in Bits (S_DATA_WIDTH bits)
        val S_DATA_Valid = in Bits (KERNEL_NUM bits)
        val S_DATA_Ready = out Bool()
        val M_DATA = master Stream Bits(M_DATA_WIDTH bits)

        val Row_Num_Out_REG = in Bits (ROW_COL_DATA_COUNT_WIDTH bits)
        val RowNum_After_Padding = in Bits (ROW_COL_DATA_COUNT_WIDTH bits)
        val Channel_In_Num_REG = in Bits (CHANNEL_NUM_WIDTH bits)
        val Channel_Out_Num_REG = in Bits (CHANNEL_NUM_WIDTH bits)
        val Weight_Single_Num_REG = in Bits (WEIGHT_NUM_WIDTH bits)
        val Bias_Num_REG = in Bits (BIAS_NUM_WIDTH bits)
        val Bias_Addrb = in Bits (BIAS_NUM_WIDTH bits)
        val Data_Out_Bias = out Bits (BIAS_DATA_WIDTH bits)
        val Data_Out_Scale = out Bits (SCALE_DATA_WIDTH bits)
        val Data_Out_Shift = out Bits (SHIFT_DATA_WIDTH bits)
    }
    noIoPrefix()

    val COMPUTE_TIMES_CHANNEL_IN_REG = io.Channel_In_Num_REG >> log2Up(CHANNEL_IN_NUM)
    val COMPUTE_TIMES_CHANNEL_IN_REG_8 = io.Channel_In_Num_REG >> log2Up(8)
    val COMPUTE_TIMES_CHANNEL_OUT_REG = io.Channel_Out_Num_REG >> log2Up(CHANNEL_OUT_NUM)

    val compute_ctrl = new compute_ctrl(KERNEL_NUM, WEIGHT_ADDR_WIDTH, WIDTH_TEMP_RAM_ADDR, ROW_COL_DATA_COUNT_WIDTH, CHANNEL_NUM_WIDTH, CHANNEL_IN_NUM)
    compute_ctrl.io.Start_Cu <> io.Start_Cu
    compute_ctrl.io.M_ready <> io.M_DATA.ready
    compute_ctrl.io.M_Valid <> io.M_DATA.valid
    compute_ctrl.io.COMPUTE_TIMES_CHANNEL_IN_REG <> COMPUTE_TIMES_CHANNEL_IN_REG.resized
    compute_ctrl.io.COMPUTE_TIMES_CHANNEL_IN_REG_8 <> COMPUTE_TIMES_CHANNEL_IN_REG_8.resized
    compute_ctrl.io.COMPUTE_TIMES_CHANNEL_OUT_REG <> COMPUTE_TIMES_CHANNEL_OUT_REG.resized
    compute_ctrl.io.ROW_NUM_CHANNEL_OUT_REG <> io.Row_Num_Out_REG.resized
    compute_ctrl.io.Compute_Complete <> io.Compute_Complete


    val WEIGHT_DATA_WIDTH = CHANNEL_IN_NUM * CHANNEL_OUT_NUM * 8
    val load_weight = new load_weight(KERNEL_NUM, WEIGHT_NUM_WIDTH, WEIGHT_ADDR_WIDTH, BIAS_NUM_WIDTH, PARA_DATA_WIDTH, WEIGHT_DATA_WIDTH, BIAS_DATA_WIDTH, SCALE_DATA_WIDTH, SHIFT_DATA_WIDTH, WEIGHT_MEM_WRITE_DEPTH, LOAD_BIAS_MEM_WRITE_DEPTH)
    load_weight.io.Start_Pa <> io.Start_Pa
    load_weight.io.Weight_Single_Num_REG <> io.Weight_Single_Num_REG
    load_weight.io.Weight_Addrb <> compute_ctrl.io.weight_addrb
    load_weight.io.Bias_Num_REG <> io.Bias_Num_REG
    load_weight.io.Write_Block_Complete <> io.Write_Block_Complete
    load_weight.io.S_Para_Data <> io.para_data
    load_weight.io.Bias_Addrb <> io.Bias_Addrb
    load_weight.io.Data_Out_Bias <> io.Data_Out_Bias
    load_weight.io.Data_Out_Scale <> io.Data_Out_Scale
    load_weight.io.Data_Out_Shift <> io.Data_Out_Shift


    val FIFO_W_DATA_WIDTH = S_DATA_WIDTH / KERNEL_NUM
    val FEATURE_DATA_WIDTH = FIFO_W_DATA_WIDTH * (CHANNEL_IN_NUM / 8)
    val FIFO_DATA_OUT_WIDTH = FEATURE_DATA_WIDTH * KERNEL_NUM

    val data_fifo_out = Bits(FIFO_DATA_OUT_WIDTH bits)

    var fifo_list: List[general_fifo_sync] = Nil
    val is_first = if (KERNEL_NUM == 1) true else false
    for (_ <- 0 until KERNEL_NUM) {
        fifo_list = new general_fifo_sync(FIFO_W_DATA_WIDTH, FEATURE_DATA_WIDTH, FEATURE_FIFO_DEPTH, ROW_COL_DATA_COUNT_WIDTH, is_first) :: fifo_list
    }
    fifo_list = fifo_list.reverse
    for (i <- 0 until KERNEL_NUM) {
        fifo_list(i).io.wr_en <> io.S_DATA_Valid(i)
        fifo_list(i).io.data_in <> io.S_DATA((i + 1) * FIFO_W_DATA_WIDTH - 1 downto (i * FIFO_W_DATA_WIDTH))
        fifo_list(i).io.rd_en <> compute_ctrl.io.rd_en_fifo
        fifo_list(i).io.m_data_count <> compute_ctrl.io.M_Count_Fifo.asUInt
        fifo_list(i).io.s_data_count <> compute_ctrl.io.S_Count_Fifo.asUInt
        //data_fifo_out((i + 1) * FEATURE_DATA_WIDTH - 1 downto (i * FEATURE_DATA_WIDTH)) := reverseData(fifo_list(i).io.data_out, 64)
        data_fifo_out((i + 1) * FEATURE_DATA_WIDTH - 1 downto (i * FEATURE_DATA_WIDTH)) := fifo_list(i).io.data_out
    }
    if (KERNEL_NUM >= 3) {
        (fifo_list(0).io.data_in_ready & fifo_list(1).io.data_in_ready & fifo_list(2).io.data_in_ready) <> io.S_DATA_Ready
        compute_ctrl.io.compute_fifo_ready <> (fifo_list(0).io.data_out_valid & fifo_list(1).io.data_out_valid & fifo_list(2).io.data_out_valid)
    } else {
        fifo_list(0).io.data_in_ready <> io.S_DATA_Ready
        compute_ctrl.io.compute_fifo_ready <> fifo_list(0).io.data_out_valid
    }


    val FEATURE_MEM_DEPTH = scala.math.pow(2, WIDTH_TEMP_RAM_ADDR).toInt
    val Configurable_RAM_Norm = new sdpram(FIFO_DATA_OUT_WIDTH, FEATURE_MEM_DEPTH, FIFO_DATA_OUT_WIDTH, FEATURE_MEM_DEPTH, "distributed", 0, "common_clock", this.clockDomain, this.clockDomain)
    Configurable_RAM_Norm.io.addra <> compute_ctrl.io.ram_temp_write_address
    Configurable_RAM_Norm.io.addrb <> compute_ctrl.io.ram_temp_read_address
    Configurable_RAM_Norm.io.wea <> compute_ctrl.io.rd_en_fifo.asBits
    Configurable_RAM_Norm.io.ena <> True
    Configurable_RAM_Norm.io.enb <> True
    Configurable_RAM_Norm.io.dina <> data_fifo_out

    val ram_temp_output_data = Bits(FIFO_DATA_OUT_WIDTH bits)
    Configurable_RAM_Norm.io.doutb <> ram_temp_output_data
    val ram_temp_output_data_delay = Delay(ram_temp_output_data, 2)
    val compute_data_in = Vec(Bits(DATA_WIDTH * KERNEL_NUM bits), CHANNEL_IN_NUM)
    for (i <- 0 until CHANNEL_IN_NUM; j <- 0 until KERNEL_NUM) {
        compute_data_in(i)((j + 1) * DATA_WIDTH - 1 downto j * DATA_WIDTH) := ram_temp_output_data_delay((j * CHANNEL_IN_NUM + i + 1) * DATA_WIDTH - 1 downto (j * CHANNEL_IN_NUM + i) * DATA_WIDTH)
    }
    val compute_weight_in = Vec(Bits(CHANNEL_IN_NUM * DATA_WIDTH * KERNEL_NUM bits), CHANNEL_OUT_NUM)
    for (i <- 0 until CHANNEL_OUT_NUM; j <- 0 until CHANNEL_IN_NUM; k <- 0 until KERNEL_NUM) {
        compute_weight_in(i)((j * KERNEL_NUM + k + 1) * DATA_WIDTH - 1 downto (j * KERNEL_NUM + k) * DATA_WIDTH) := load_weight.io.Data_Out_Weight(k)((i * CHANNEL_IN_NUM + j + 1) * DATA_WIDTH - 1 downto (i * CHANNEL_IN_NUM + j) * DATA_WIDTH)
    }

    val compute_weight_in_delay = Vec(Bits(CHANNEL_IN_NUM * DATA_WIDTH * KERNEL_NUM bits), CHANNEL_OUT_NUM)
    for (i <- 0 until CHANNEL_OUT_NUM) {
        compute_weight_in_delay(i) := RegNext(compute_weight_in(i))
    }
    //val AFTER_CONV_WIDTH: Int = DATA_WIDTH * 2 + (KERNEL_NUM - 1) / 2
    val AFTER_CONV_WIDTH: Int = 20
    val AFTER_CIN_ACC_WIDTH = 32
    val compute_data_out = Vec(Bits(CHANNEL_IN_NUM * AFTER_CONV_WIDTH bits), CHANNEL_OUT_NUM)
    var mul_add_list: List[mul_add_simd] = Nil
    for (_ <- 0 until CHANNEL_OUT_NUM; __ <- 0 until CHANNEL_IN_NUM) {
        mul_add_list = new mul_add_simd(KERNEL_NUM, KERNEL_NUM * DATA_WIDTH, AFTER_CONV_WIDTH) :: mul_add_list

    }
    mul_add_list = mul_add_list.reverse
    for (i <- 0 until CHANNEL_OUT_NUM; j <- 0 until CHANNEL_IN_NUM) {
        mul_add_list(i * CHANNEL_IN_NUM + j).io.dataIn <> compute_data_in(j)
        mul_add_list(i * CHANNEL_IN_NUM + j).io.weightIn <> compute_weight_in_delay(i)((j + 1) * KERNEL_NUM * DATA_WIDTH - 1 downto (j * KERNEL_NUM * DATA_WIDTH))
        mul_add_list(i * CHANNEL_IN_NUM + j).io.dataOut <> compute_data_out(i)((j + 1) * AFTER_CONV_WIDTH - 1 downto j * AFTER_CONV_WIDTH)
    }
    val data_result_temp = Vec(Bits(AFTER_CIN_ACC_WIDTH bits), CHANNEL_OUT_NUM)
    var c_in_acc: List[channel_in_acc] = Nil
    for (_ <- 0 until CHANNEL_OUT_NUM) {
        c_in_acc = new channel_in_acc(CHANNEL_IN_NUM, CHANNEL_IN_NUM * AFTER_CONV_WIDTH, AFTER_CIN_ACC_WIDTH) :: c_in_acc
    }
    c_in_acc = c_in_acc.reverse
    for (i <- 0 until CHANNEL_OUT_NUM) {
        c_in_acc(i).io.data_in <> compute_data_out(i)
        c_in_acc(i).io.data_out <> data_result_temp(i)
    }

    var c_out_acc: List[channel_out_acc] = Nil
    for (_ <- 0 until CHANNEL_OUT_NUM) {
        c_out_acc = new channel_out_acc(AFTER_CIN_ACC_WIDTH, AFTER_CIN_ACC_WIDTH) :: c_out_acc
    }
    c_out_acc = c_out_acc.reverse
    for (i <- 0 until CHANNEL_OUT_NUM) {
        c_out_acc(i).io.data_in <> c_in_acc(i).io.data_out
        c_out_acc(i).io.First_Compute_Complete <> compute_ctrl.io.First_Compute_Complete
        c_out_acc(i).io.data_out <> io.M_DATA.payload((i + 1) * AFTER_CIN_ACC_WIDTH - 1 downto i * AFTER_CIN_ACC_WIDTH)
    }


    def reverseData(in: Bits, width: Int): Bits = {
        val data_width = in.getWidth
        val out = Bits(data_width bits)
        val temp = in.subdivideIn(width bits).reverse
        for (i <- 0 until data_width / width) {
            out((i + 1) * width - 1 downto i * width) := temp(i)
        }
        out
    }

}

object Conv_Norm {
    def main(args: Array[String]): Unit = {
        SpinalVerilog(new Conv_Norm(1, 64, 64, 256, 12, 10, 15, 15, 8, 256, 256, 256, 32, 8, 12, 2048, 2048, 2048, 8))
    }

}
