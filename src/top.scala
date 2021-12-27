import spinal.core._
import spinal.lib.{master, slave}
class top  extends Component {
    val io = new Bundle {
        val image_Start = in Bool()
        val image_S_DATA = slave Stream Bits(8 bits)
//        val image_M_DATA = master Stream Bits(8 bits)
//        val image_Row_Num_After_Padding = out UInt (12 bits)
//        val image_Last = out (Reg(Bool())) init(False)
//        val M_DATA = out Bits(256 bits)
//        val M_Valid = out Bool()
//       val M_Valid = out Bits (9 bits)
//        val M_Ready = in Bool()
//        val M_rd_en = in Bool()
//        val M_Addr = in UInt (12 bits)
//        val StartRow = out Bool()
//        val Conv_Complete = out Bool()
        val M_DATA = master Stream(Bits(64 bits))
        val Stride_Complete = out Bool()
        val Img_Last = out Bool()
    }
    noIoPrefix()
    val image_padding = new image_padding(8,12,640).setDefinitionName("image_padding")
//    image_padding.padding_fifo.setDefinitionName("image_padding_fifo")
//    image_padding.padding_fifo.fifo.setDefinitionName("image_padding_fifo_sync")
    io.image_Start <> image_padding.io.Start
    io.image_S_DATA <> image_padding.io.S_DATA
//    io.image_M_DATA <> image_padding.io.M_DATA
//    io.image_Row_Num_After_Padding <> image_padding.io.Row_Num_After_Padding
//    io.image_Last <> image_padding.io.Last
    val image_four2three = new image_four2three(8,12,642).setDefinitionName("image_four2three")
//    image_four2three.four2three_fifo.setDefinitionName("image_four2three_fifo")
//    image_four2three.ram1.setDefinitionName("image_four2three_ram1")
//    image_four2three.ram2.setDefinitionName("image_four2three_ram2")
//    image_four2three.ram3.setDefinitionName("image_four2three_ram3")
//    image_four2three.ram4.setDefinitionName("image_four2three_ram4")
    image_four2three.io.S_DATA<>image_padding.io.M_DATA
    image_four2three.io.Start <> io.image_Start
    image_four2three.io.Row_Num_After_Padding <> image_padding.io.Row_Num_After_Padding
//    image_four2three.io.M_DATA <> io.M_DATA
//    image_four2three.io.M_Valid <> io.M_Valid
//    image_four2three.io.M_Ready <> io.M_Ready
//    image_four2three.io.M_Addr <> io.M_Addr
//    image_four2three.io.StartRow <> io.StartRow
//    image_four2three.io.M_rd_en <> io.M_rd_en

    val image_three2nine = new image_three2nine(24,12)
    image_three2nine.io.Start <> io.image_Start
    image_three2nine.io.Row_Num_After_Padding <> image_padding.io.Row_Num_After_Padding
    image_three2nine.io.S_DATA <> image_four2three.io.M_DATA
    image_three2nine.io.S_DATA_Addr <> image_four2three.io.M_Addr
    image_three2nine.io.S_Ready <> image_four2three.io.M_Ready
    image_three2nine.io.S_DATA_Ready <> image_four2three.io.M_rd_en
    image_three2nine.io.S_DATA_Valid <> image_four2three.io.M_Valid
    image_three2nine.io.Row_Compute_Sign <> image_four2three.io.StartRow
//    image_three2nine.io.M_Valid <> io.M_Valid
//    image_three2nine.io.M_Data <> io.M_DATA
//    image_three2nine.io.M_Ready <> io.M_Ready

    val image_conv = new image_conv(72,256,12,9,1,8,32,642)
    image_conv.io.Start <> io.image_Start
    image_conv.io.S_DATA <> image_three2nine.io.M_Data
    image_conv.io.S_Valid <> image_three2nine.io.M_Valid
    image_conv.io.S_Ready <> image_three2nine.io.M_Ready
//    image_conv.io.M_Valid <> io.M_Valid
//    image_conv.io.M_DATA <> io.M_DATA
//    image_conv.io.M_Ready <> io.M_Ready
//    image_conv.io.Conv_Complete <> io.Conv_Complete
    val image_quan = new image_quan(256,64,640,12,4,8)
    image_quan.io.S_DATA.payload <> image_conv.io.M_DATA
    image_quan.io.S_DATA.ready <> image_conv.io.M_Ready
    image_quan.io.S_DATA.valid <> image_conv.io.M_Valid
//    image_quan.io.M_DATA <> io.M_DATA

    val image_stride = new image_stride(64,64,2048,640,12,4)
    image_stride.io.S_DATA <> image_quan.io.M_DATA
    image_stride.io.M_DATA <> io.M_DATA
    image_stride.io.Start <> io.image_Start
    image_stride.io.Stride_Complete <> io.Stride_Complete
    image_stride.io.Img_Last <> io.Img_Last

}
object top{
    def main(args: Array[String]): Unit = {
        SpinalConfig(
            defaultConfigForClockDomains = ClockDomainConfig(clockEdge = RISING, resetKind = SYNC),
            oneFilePerComponent = true,
            headerWithDate = true,
            targetDirectory = "verilog"

        )generateVerilog(new top)
        SpinalConfig(
            defaultConfigForClockDomains = ClockDomainConfig(clockEdge = RISING, resetKind = SYNC),
            headerWithDate = true,
            targetDirectory = "verilog"

        )generateVerilog(new leaky_relu(8,8,8))
    }

}
