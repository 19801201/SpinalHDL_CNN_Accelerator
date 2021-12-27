import spinal.core.Component.pop
import spinal.core._
import spinal.lib._

class data_generate(
                       S_DATA_WIDTH: Int,
                       M_DATA_WIDTH: Int,
                       ROW_COL_DATA_COUNT_WIDTH: Int,
                       CHANNEL_NUM_WIDTH: Int,
                       DATA_WIDTH: Int,
                       ZERO_NUM_WIDTH: Int,
                       MEMORY_DEPTH: Int
                   ) extends Component {

    val io = new Bundle {
        val Start = in Bool()
        val S_DATA = slave Stream Bits(S_DATA_WIDTH bits)
        val M_DATA = out Bits (M_DATA_WIDTH bits)
        val M_DATA_Valid = out Bits (9 bits)
        val M_DATA_Ready = in Bool()
        val Row_Num_In_REG = in Bits (ROW_COL_DATA_COUNT_WIDTH bits)
        val Padding_REG = in Bool()
        val Zero_Point_REG = in Bits (DATA_WIDTH bits)
        val Zero_Num_REG = in Bits (ZERO_NUM_WIDTH bits)
        val Channel_In_Num_REG = in Bits (CHANNEL_NUM_WIDTH bits)
        val EN_Cin_Select_REG = in Bool()
        val RowNum_After_Padding = out Bits (ROW_COL_DATA_COUNT_WIDTH bits)
    }
    noIoPrefix()
    val Channel_Out_Num = 8
    val PADDING_S_DATA_WIDTH = S_DATA_WIDTH
    val cin_convert = new cin_convert(Channel_Out_Num, S_DATA_WIDTH, PADDING_S_DATA_WIDTH, DATA_WIDTH)
    cin_convert.io.EN_Cin_Select_REG <> io.EN_Cin_Select_REG
    cin_convert.io.S_DATA <> io.S_DATA

    val F2T_S_DATA_WIDTH = PADDING_S_DATA_WIDTH
    val padding = new padding(PADDING_S_DATA_WIDTH, F2T_S_DATA_WIDTH, ROW_COL_DATA_COUNT_WIDTH, CHANNEL_NUM_WIDTH, DATA_WIDTH, ZERO_NUM_WIDTH, MEMORY_DEPTH)
    padding.io.S_DATA <> cin_convert.io.M_DATA
    padding.io.Start <> io.Start
    padding.io.Row_Num_In_REG <> io.Row_Num_In_REG
    padding.io.Channel_In_Num_REG <> io.Channel_In_Num_REG
    padding.io.Padding_REG <> io.Padding_REG
    padding.io.Zero_Point_REG <> io.Zero_Point_REG
    padding.io.Zero_Num_REG <> io.Zero_Num_REG
    padding.io.RowNum_After_Padding <> io.RowNum_After_Padding
    val T2N_S_DATA_WIDTH = F2T_S_DATA_WIDTH * 3
    val f2t = new four2three(F2T_S_DATA_WIDTH, T2N_S_DATA_WIDTH, CHANNEL_NUM_WIDTH, ROW_COL_DATA_COUNT_WIDTH, MEMORY_DEPTH)
    f2t.io.S_DATA <> padding.io.M_DATA
    f2t.io.Start <> io.Start
    f2t.io.Row_Num_After_Padding <> padding.io.RowNum_After_Padding.asUInt
    f2t.io.Channel_In_Num_REG <> io.Channel_In_Num_REG

    val t2n = new three2nine(T2N_S_DATA_WIDTH, M_DATA_WIDTH, CHANNEL_NUM_WIDTH, ROW_COL_DATA_COUNT_WIDTH)
    t2n.io.Start <> io.Start
    t2n.io.S_DATA <> f2t.io.M_DATA
    t2n.io.S_DATA_Ready <> f2t.io.M_rd_en
    t2n.io.S_DATA_Valid <> f2t.io.M_Valid
    t2n.io.S_DATA_Addr <> f2t.io.M_Addr
    t2n.io.S_Ready <> f2t.io.M_Ready
    t2n.io.Row_Compute_Sign <> f2t.io.StartRow
    t2n.io.M_Ready <> io.M_DATA_Ready
    t2n.io.M_Valid <> io.M_DATA_Valid
    t2n.io.M_Data <> io.M_DATA
    t2n.io.Row_Num_After_Padding <> padding.io.RowNum_After_Padding.asUInt
    t2n.io.Channel_In_Num_REG <> io.Channel_In_Num_REG


}

object data_generate {
    def main(args: Array[String]): Unit = {
        SpinalVerilog(new data_generate(64, 576, 12, 10, 8, 8, 2048))
    }
}
