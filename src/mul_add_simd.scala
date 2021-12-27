import spinal.core._
import spinal.lib._

class mul_add_simd(
                      KERNEL_NUM: Int,
                      S_DATA_WIDTH: Int,
                      M_DATA_WIDTH: Int
                  ) extends Component {

    val io = new Bundle {
        val dataIn = in Bits (S_DATA_WIDTH bits)
        val weightIn = in Bits (S_DATA_WIDTH bits)
        val dataOut = out Bits (M_DATA_WIDTH bits)
    }
    noIoPrefix()
    val mul_data_out = Vec(Bits(M_DATA_WIDTH bits), KERNEL_NUM)
    val mul_clk = ClockDomain(this.clockDomain.clock)
    var mul_list: List[mul_simd] = Nil
    for (_ <- 0 until KERNEL_NUM) {
        mul_list = mul_clk(new mul_simd(S_DATA_WIDTH / KERNEL_NUM, M_DATA_WIDTH)) :: mul_list
    }
    mul_list = mul_list.reverse
    for (i <- 0 until KERNEL_NUM) {
        mul_list(i).io.data_in <> io.dataIn(((i + 1) * (S_DATA_WIDTH / KERNEL_NUM) - 1) downto (i * (S_DATA_WIDTH / KERNEL_NUM)))
        mul_list(i).io.weight_in <> io.weightIn(((i + 1) * (S_DATA_WIDTH / KERNEL_NUM) - 1) downto (i * (S_DATA_WIDTH / KERNEL_NUM)))
        mul_data_out(i) := mul_list(i).io.data_out
    }
    if (KERNEL_NUM == 9) {
        val mul_data_out_delay2 = Vec(Bits(M_DATA_WIDTH bits), KERNEL_NUM - 1)
        for (i <- 1 until (KERNEL_NUM - 1)) {
            mul_data_out_delay2(i) := Delay(mul_data_out(i + 1), 2)
        }
        var add_list: List[add_simd] = Nil

        for (_ <- 0 until (KERNEL_NUM - 1)) {
            add_list = new add_simd(M_DATA_WIDTH, M_DATA_WIDTH, M_DATA_WIDTH) :: add_list
        }
        add_list = add_list.reverse
        add_list(0).io.A := mul_data_out(0)
        add_list(0).io.B := mul_data_out(1)
        add_list(0).io.P <> mul_data_out_delay2(0)
        val mul_data_out_delay3 = Vec(Bits(M_DATA_WIDTH bits), (KERNEL_NUM - 1) / 2)
        for (i <- 0 until 4) {
            add_list(i + 1).io.A := mul_data_out_delay2(i * 2)
            add_list(i + 1).io.B := mul_data_out_delay2(i * 2 + 1)
            add_list(i + 1).io.P <> mul_data_out_delay3(i)
        }
        val mul_data_out_delay4 = Vec(Bits(M_DATA_WIDTH bits), (KERNEL_NUM - 1) / 4)
        add_list(5).io.A := mul_data_out_delay3(0)
        add_list(5).io.B := mul_data_out_delay3(1)
        add_list(5).io.P <> mul_data_out_delay4(0)
        add_list(6).io.A := mul_data_out_delay3(2)
        add_list(6).io.B := mul_data_out_delay3(3)
        add_list(6).io.P <> mul_data_out_delay4(1)
        add_list(7).io.A := mul_data_out_delay4(0)
        add_list(7).io.B := mul_data_out_delay4(1)
        add_list(7).io.P <> io.dataOut
    } else if (KERNEL_NUM == 1) {
        //io.dataOut := Delay(mul_data_out(0),8)
        io.dataOut := mul_data_out(0)
    } else {
        assert(false,"暂只支持3x3和1x1卷积")
    }

}

object mul_add_simd {
    def main(args: Array[String]): Unit = {
        SpinalVerilog(new mul_add_simd(9, 72, 20))
    }
}