import spinal.core._

import scala.::

class image_conv(
                    S_DATA_WIDTH: Int,
                    M_DATA_WIDTH: Int,
                    ROW_COL_DATA_COUNT_WIDTH: Int,
                    KERNEL_NUM: Int,
                    COMPUTE_CHANNEL_IN_NUM: Int,
                    COMPUTE_CHANNEL_OUT_NUM: Int,
//                    CHANNEL_OUT_NUM: Int,
                    DATA_WIDTH: Int,
                    FEATURE_MAP_SIZE: Int
                ) extends Component {

    val io = new Bundle {
        val Start = in Bool()
        val S_Valid = in Bits (KERNEL_NUM bits)
        val S_DATA = in Bits (S_DATA_WIDTH bits)
        val S_Ready = out Bool()
        val M_Valid = out Bool()
        val M_DATA = out Bits (M_DATA_WIDTH bits)
        val M_Ready = in Bool()
        val Conv_Complete = out Bool()
    }
    noIoPrefix()
    val Width_After_Conv:Int = (S_DATA_WIDTH / KERNEL_NUM)*2 + (KERNEL_NUM - 1) / 2
    val weight = new Area {
        val weight_0 = B"72'h3ae95581a1cbd4be01"
        val weight_1 = B"72'h0a767fdbccae81ce8d"
        val weight_2 = B"72'h027f20f2561301f3b3"
        val weight_3 = B"72'h0ad4ce7ff2c56e4a2d"
        val weight_4 = B"72'h94e5eff34a7fd9016e"
        val weight_5 = B"72'hc41b9a30908141b9d7"
        val weight_6 = B"72'h0819c67880b45ad6d7"
        val weight_7 = B"72'he53cea2b7fd13019e1"
        val weight_8 = B"72'h7f3fdafe262cf8af91"
        val weight_9 = B"72'h38442ce45d7fa4e01d"
        val weight_10 = B"72'hd481be1763fc586edf"
        val weight_11 = B"72'hd8fd22800016e42c72"
        val weight_12 = B"72'h02c48018d8934043d8"
        val weight_13 = B"72'h80d05bf6d238d6623f"
        val weight_14 = B"72'h0480179589e816ea1e"
        val weight_15 = B"72'h437f25daf6f2c617ba"
        val weight_16 = B"72'h4c7f78e48c0b979b11"
        val weight_17 = B"72'hcdf6804647fe15dbd4"
        val weight_18 = B"72'h81bf1801ebdd2b5d16"
        val weight_19 = B"72'hf4b4813fcdf824684a"
        val weight_20 = B"72'h10a607d480d80fe712"
        val weight_21 = B"72'h10d1357fc5f62ce59e"
        val weight_22 = B"72'h9e99db80b10b03fe14"
        val weight_23 = B"72'h8ccde61bc225566e7f"
        val weight_24 = B"72'h80ad2c110b41214175"
        val weight_25 = B"72'h49c5eb0f537fb9c1a2"
        val weight_26 = B"72'ha8f71d80f3e90d0840"
        val weight_27 = B"72'h49533f37f07fc5ddcf"
        val weight_28 = B"72'hb21514fce17fb40c18"
        val weight_29 = B"72'h7f01825f67945729dc"
        val weight_30 = B"72'hcd6cff26c8b2aef47f"
        val weight_31 = B"72'h12ea553b31fb80adc0"
    }

    val weight_select = Bits(3 bits)
    val weight_define = Vec(Reg(Bits(KERNEL_NUM * 8 bits)) init (0), COMPUTE_CHANNEL_OUT_NUM)
    switch(weight_select) {
        is(1) {
            weight_define(0) := weight.weight_0
            weight_define(1) := weight.weight_1
            weight_define(2) := weight.weight_2
            weight_define(3) := weight.weight_3
            weight_define(4) := weight.weight_4
            weight_define(5) := weight.weight_5
            weight_define(6) := weight.weight_6
            weight_define(7) := weight.weight_7
        }
        is(2) {
            weight_define(0) := weight.weight_8
            weight_define(1) := weight.weight_9
            weight_define(2) := weight.weight_10
            weight_define(3) := weight.weight_11
            weight_define(4) := weight.weight_12
            weight_define(5) := weight.weight_13
            weight_define(6) := weight.weight_14
            weight_define(7) := weight.weight_15
        }
        is(3) {
            weight_define(0) := weight.weight_16
            weight_define(1) := weight.weight_17
            weight_define(2) := weight.weight_18
            weight_define(3) := weight.weight_19
            weight_define(4) := weight.weight_20
            weight_define(5) := weight.weight_21
            weight_define(6) := weight.weight_22
            weight_define(7) := weight.weight_23
        }
        is(4) {
            weight_define(0) := weight.weight_24
            weight_define(1) := weight.weight_25
            weight_define(2) := weight.weight_26
            weight_define(3) := weight.weight_27
            weight_define(4) := weight.weight_28
            weight_define(5) := weight.weight_29
            weight_define(6) := weight.weight_30
            weight_define(7) := weight.weight_31
        }
        default {
            weight_define(0) := 0
            weight_define(1) := 0
            weight_define(2) := 0
            weight_define(3) := 0
            weight_define(4) := 0
            weight_define(5) := 0
            weight_define(6) := 0
            weight_define(7) := 0
        }
    }

    val image_comp_ctrl = new image_compute_ctrl(ROW_COL_DATA_COUNT_WIDTH,FEATURE_MAP_SIZE)
    image_comp_ctrl.io.Start <> io.Start
    image_comp_ctrl.io.M_Ready <> io.M_Ready
    image_comp_ctrl.io.M_Valid <> io.M_Valid
    image_comp_ctrl.io.Conv_Complete <> io.Conv_Complete
    image_comp_ctrl.io.weight_select <> weight_select

    val fifo_out_data = Bits(S_DATA_WIDTH bits)
    var fifo_list: List[general_fifo_sync] = Nil
    for (_ <- 0 until 9)
        fifo_list = new general_fifo_sync(8, 8,FEATURE_MAP_SIZE, ROW_COL_DATA_COUNT_WIDTH) :: fifo_list
    fifo_list = fifo_list.reverse
    for (i <- 0 until 9) {
        fifo_list(i).io.data_in <> io.S_DATA(((i + 1) * 8 - 1) downto (i * 8))
        fifo_list(i).io.m_data_count <> FEATURE_MAP_SIZE -2
        fifo_list(i).io.s_data_count <> FEATURE_MAP_SIZE-2
        fifo_list(i).io.wr_en <> io.S_Valid(i)
        fifo_list(i).io.rd_en <> image_comp_ctrl.io.rd_en_fifo
        fifo_list(i).io.data_out <> fifo_out_data(((i + 1) * 8 - 1) downto (i * 8))
    }
    (fifo_list(0).io.data_in_ready & fifo_list(1).io.data_in_ready & fifo_list(2).io.data_in_ready) <> io.S_Ready

    image_comp_ctrl.io.compute_fifo_ready <> (fifo_list(0).io.data_out_valid & fifo_list(1).io.data_out_valid & fifo_list(2).io.data_out_valid)

   // val fifo_out_data_delay_0 = RegNextWhen(fifo_out_data,image_comp_ctrl.io.rd_en_fifo)
    val fifo_out_data_delay_0 = RegNext(fifo_out_data)
    val after_conv_data = Vec(Bits(Width_After_Conv bits),COMPUTE_CHANNEL_OUT_NUM)
    var mul_add_list:List[mul_add_simd] = Nil
    for (_ <- 0 until COMPUTE_CHANNEL_OUT_NUM){
        mul_add_list = new mul_add_simd(KERNEL_NUM,S_DATA_WIDTH,Width_After_Conv)::mul_add_list
    }
    mul_add_list = mul_add_list.reverse
    for (i <- 0 until COMPUTE_CHANNEL_OUT_NUM){
        mul_add_list(i).io.dataIn <> fifo_out_data_delay_0
        mul_add_list(i).io.weightIn <> weight_define(i)
        mul_add_list(i).io.dataOut <> after_conv_data(i)
    }

    for (i <- 0 until COMPUTE_CHANNEL_OUT_NUM){
        io.M_DATA((i+1)*DATA_WIDTH-1 downto i*DATA_WIDTH)<> after_conv_data(i).asSInt.resize(DATA_WIDTH).asBits
    }
}

object image_conv {
    def main(args: Array[String]): Unit = {
        SpinalVerilog(new image_conv(72, 256, 12, 9, 1, 8, 32,  642))
    }
}
