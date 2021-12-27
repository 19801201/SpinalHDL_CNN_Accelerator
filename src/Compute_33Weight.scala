import spinal.core._
import spinal.lib._
import xmemory._

class Compute_33Weight(
                          WEIGHT_DATA_WIDTH: Int,
                          WEIGHT_ADDR_WIDTH: Int,
                          KERNEL_NUM: Int,
                          PARA_DATA_WIDTH: Int,
//                          COMPUTE_CHANNEL_IN_NUM: Int,
//                          COMPUTE_CHANNEL_OUT_NUM: Int,
//                          DATA_WIDTH: Int,
                          MEM_WRITE_DEPTH: Int
                      ) extends Component {

    val io = new Bundle {
        val weight_data_One = in Bits (PARA_DATA_WIDTH bits)
//        val weight_data_Two = in Bits (PARA_DATA_WIDTH bits)
//        val weight_data_Three = in Bits (PARA_DATA_WIDTH bits)
        val weight_wr = in Bits (KERNEL_NUM bits)
        val weight_addra = in Bits (WEIGHT_ADDR_WIDTH bits)
        val weight_addrb = in Bits (WEIGHT_ADDR_WIDTH bits)
        val weight_ram_data_out = out Vec(Bits (WEIGHT_DATA_WIDTH bits),KERNEL_NUM)
    }

//    val WEIGHT_DATA_WIDTH_9 = WEIGHT_DATA_WIDTH / KERNEL_NUM
    val MEM_READ_DEPTH = MEM_WRITE_DEPTH * PARA_DATA_WIDTH / WEIGHT_DATA_WIDTH

    var ram1_list: List[sdpram] = Nil
    for (_ <- 0 until  KERNEL_NUM) {
        ram1_list = new sdpram(PARA_DATA_WIDTH, MEM_WRITE_DEPTH, WEIGHT_DATA_WIDTH, MEM_READ_DEPTH, "block", 1, "common_clock", this.clockDomain, this.clockDomain) :: ram1_list
    }
    ram1_list = ram1_list.reverse
    for (i <- 0 until  KERNEL_NUM) {
        ram1_list(i).io.ena <> True
        ram1_list(i).io.enb <> True
        ram1_list(i).io.wea <> io.weight_wr(i).asBits
        ram1_list(i).io.addra <> io.weight_addra.resized
        ram1_list(i).io.addrb <> io.weight_addrb.resized
        ram1_list(i).io.dina <> io.weight_data_One
        ram1_list(i).io.doutb <> io.weight_ram_data_out(i)
    }
}

object Compute_33Weight{
    def main(args: Array[String]): Unit = {
        SpinalVerilog(new Compute_33Weight(1024,13,9,64,8192))
    }
}
