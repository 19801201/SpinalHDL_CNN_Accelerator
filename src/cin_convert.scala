import spinal.core._
import spinal.lib._

class cin_convert(
                     Channel_Out_Num: Int,
                     S_DATA_WIDTH: Int,
                     M_DATA_WIDTH: Int,
                     DATA_WIDTH: Int
                 ) extends Component {
    val io = new Bundle {
        val S_DATA = slave Stream Bits(S_DATA_WIDTH bits)
        val M_DATA = master Stream Bits(M_DATA_WIDTH bits)
        val EN_Cin_Select_REG = in Bool()
    }
    noIoPrefix()
    val Half_Channel_Out_Num = Channel_Out_Num / 2
    val M_Feature_Temp = Bits(Half_Channel_Out_Num * DATA_WIDTH bits)
    val S_Feature_Delay = RegNext(io.S_DATA.payload)
    val M_Ready_Delay = RegNext(io.M_DATA.ready)
    val S_Valid_Delay = RegNext(io.S_DATA.valid)
    val cnt = UInt(1 bits) setAsReg()
    when(io.M_DATA.ready) {
        when(!M_Ready_Delay && io.M_DATA.ready) {
            cnt := 1
        } otherwise {
            cnt := cnt + 1
        }
    } otherwise {
        cnt := 0
    }
    val S_Ready_temp = cnt.asBool;
    val M_Valid_temp = Bool()
    when(io.S_DATA.valid) {
        M_Valid_temp := io.S_DATA.valid
    } otherwise {
        M_Valid_temp := S_Valid_Delay
    }
    when(io.S_DATA.valid) {
        M_Feature_Temp := io.S_DATA.payload(Half_Channel_Out_Num * DATA_WIDTH - 1 downto 0)
    } otherwise {
        M_Feature_Temp := S_Feature_Delay(Half_Channel_Out_Num * DATA_WIDTH * 2 - 1 downto Half_Channel_Out_Num * DATA_WIDTH)
    }

    when(io.EN_Cin_Select_REG){
        io.S_DATA.ready:= S_Ready_temp
        io.M_DATA.valid:=M_Valid_temp
        io.M_DATA.payload := M_Feature_Temp.resized
    }otherwise{
        io.S_DATA <> io.M_DATA
    }


}
object cin_convert{
    def main(args: Array[String]): Unit = {
        SpinalVerilog(new cin_convert(8,64,64,8))
    }
}
