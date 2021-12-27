import spinal.core._

class shift (
            S_DATA_WIDTH:Int,
            M_DATA_WIDTH:Int
            )extends Component {
    val io = new Bundle{
        val shift_data_in = in Bits(S_DATA_WIDTH bits)
        val data_in = in Bits(S_DATA_WIDTH bits)
        val data_out = out Bits(M_DATA_WIDTH bits) setAsReg()
    }
    noIoPrefix()
    val data_out_temp = SInt()
    data_out_temp := io.data_in.asSInt >> io.shift_data_in.asUInt
    when(data_out_temp(0).asBits === 1){
        io.data_out:=((data_out_temp(31)##data_out_temp(15 downto 1)).asUInt+1).asBits
    } otherwise{
        io.data_out:=data_out_temp(31)##data_out_temp(15 downto 1)
    }
}
