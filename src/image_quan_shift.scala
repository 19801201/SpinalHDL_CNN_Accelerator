import spinal.core._

//第一版，如果有问题改回原思路
//截断，可以选择不在这里截断，在zero里面进行
class image_quan_shift(
                     S_DATA_WIDTH: Int,
                     M_DATA_WIDTH: Int
                 ) extends Component {
    val io = new Bundle {
        val shift_data_in = in Bits(S_DATA_WIDTH bits)
        val data_in = in Bits(S_DATA_WIDTH bits)
        val shift_data_out = out Bits(M_DATA_WIDTH bits) setAsReg() init 0
    }
    noIoPrefix()
    val data_out_temp = SInt()
    data_out_temp := io.data_in.asSInt >> io.shift_data_in.asUInt
    when(data_out_temp(0).asBits === 1){
        io.shift_data_out:=((data_out_temp(31)##data_out_temp(15 downto 1)).asUInt+1).asBits
    } otherwise{
        io.shift_data_out:=data_out_temp(31)##data_out_temp(15 downto 1)
    }
}
object image_quan_shift{
    def main(args: Array[String]): Unit = {
        SpinalVerilog(new image_quan_shift(32,16))
    }
}