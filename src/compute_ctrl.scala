import spinal.core._
import spinal.lib._
import spinal.lib.fsm._
import xip._

class compute_ctrl(
                      KERNEL_NUM: Int,
                      WEIGHT_ADDR_WIDTH: Int,
                      WIDTH_TEMP_ADDR_SIZE: Int,
                      ROW_COL_DATA_COUNT_WIDTH: Int,
                      CHANNEL_NUM_WIDTH: Int,
                      CHANNEL_IN_NUM: Int
                  ) extends Component {

    val io = new Bundle {
        val Start_Cu = in Bool()
        val Compute_Complete = out Bool() setAsReg()
        val First_Compute_Complete = out Bool()
        val compute_fifo_ready = in Bool()
        val rd_en_fifo = out Bool() setAsReg()
        val M_ready = in Bool()
        val M_Valid = out Bool()
        val weight_addrb = out Bits (WEIGHT_ADDR_WIDTH bits)
        val ram_temp_read_address = out Bits (WIDTH_TEMP_ADDR_SIZE bits)
        val ram_temp_write_address = out Bits (WIDTH_TEMP_ADDR_SIZE bits) setAsReg()
        val COMPUTE_TIMES_CHANNEL_IN_REG = in Bits (ROW_COL_DATA_COUNT_WIDTH bits)
        val COMPUTE_TIMES_CHANNEL_IN_REG_8 = in Bits (ROW_COL_DATA_COUNT_WIDTH bits)
        val COMPUTE_TIMES_CHANNEL_OUT_REG = in Bits (ROW_COL_DATA_COUNT_WIDTH bits)
        val ROW_NUM_CHANNEL_OUT_REG = in Bits (ROW_COL_DATA_COUNT_WIDTH bits)
        val S_Count_Fifo = out Bits (ROW_COL_DATA_COUNT_WIDTH bits)
        val M_Count_Fifo = out Bits (ROW_COL_DATA_COUNT_WIDTH bits)

    }
    noIoPrefix()

    val count_mult = new mul(ROW_COL_DATA_COUNT_WIDTH, ROW_COL_DATA_COUNT_WIDTH, ROW_COL_DATA_COUNT_WIDTH, false)
    count_mult.io.A := io.ROW_NUM_CHANNEL_OUT_REG
    count_mult.io.B := io.COMPUTE_TIMES_CHANNEL_IN_REG_8
    count_mult.io.P.resized <> io.S_Count_Fifo
    io.M_Count_Fifo := (count_mult.io.P >> log2Up(CHANNEL_IN_NUM / 8)).resized


    val fsm = new StateMachine {
        val IDLE = new State() with EntryPoint
        val Wait = new State()
        val Judge_Before_Fifo = new State()
        val Judge_After_Fifo = new State()
        val Compute = new State()
        val Judge_Row = new State()


        val wait_cnt = UInt(5 bits) setAsReg()
        val wait_en = Bool()
        when(wait_cnt === 5) {
            wait_en := True
        } otherwise {
            wait_en := False
        }
        when(isActive(Wait)) {
            wait_cnt := wait_cnt + 1
        } otherwise {
            wait_cnt := 0
        }

        val Cnt_Channel_In_Num = UInt(CHANNEL_NUM_WIDTH bits) setAsReg()
        val Cnt_Channel_Out_Num = UInt(CHANNEL_NUM_WIDTH bits) setAsReg()
        when(isActive(Compute)) {
            when(Cnt_Channel_In_Num === io.COMPUTE_TIMES_CHANNEL_IN_REG.asUInt - 1) {
                Cnt_Channel_In_Num := 0
            } otherwise {
                Cnt_Channel_In_Num := Cnt_Channel_In_Num + 1
            }
        } otherwise {
            Cnt_Channel_In_Num := 0
        }
        when(isActive(Compute)) {
            when(Cnt_Channel_In_Num === io.COMPUTE_TIMES_CHANNEL_IN_REG.asUInt - 1) {
                when(Cnt_Channel_Out_Num === io.COMPUTE_TIMES_CHANNEL_OUT_REG.asUInt - 1) {
                    Cnt_Channel_Out_Num := 0
                } otherwise {
                    Cnt_Channel_Out_Num := Cnt_Channel_Out_Num + 1
                }
            } otherwise {
                Cnt_Channel_Out_Num := Cnt_Channel_Out_Num
            }
        } otherwise {
            Cnt_Channel_Out_Num := 0
        }

        val Cnt_Column = UInt(ROW_COL_DATA_COUNT_WIDTH bits) setAsReg()
        when(isActive(Compute)) {
            when(Cnt_Channel_In_Num === io.COMPUTE_TIMES_CHANNEL_IN_REG.asUInt - 1 && Cnt_Channel_Out_Num === io.COMPUTE_TIMES_CHANNEL_OUT_REG.asUInt - 1) {
                Cnt_Column := Cnt_Column + 1
            } otherwise {
                Cnt_Column := Cnt_Column
            }
        } otherwise {
            Cnt_Column := 0
        }
        val Cnt_Row = UInt(ROW_COL_DATA_COUNT_WIDTH bits) setAsReg()
        when(isActive(Judge_Row)) {
            Cnt_Row := Cnt_Row + 1
        } elsewhen isActive(IDLE) {
            Cnt_Row := 0
        } otherwise {
            Cnt_Row := Cnt_Row
        }
        val En_Compute_Column = Bool()
        when(Cnt_Column === io.ROW_NUM_CHANNEL_OUT_REG.asUInt - 1 && Cnt_Channel_In_Num === io.COMPUTE_TIMES_CHANNEL_IN_REG.asUInt - 1 && Cnt_Channel_Out_Num === io.COMPUTE_TIMES_CHANNEL_OUT_REG.asUInt - 1) {
            En_Compute_Column := True
        } otherwise {
            En_Compute_Column := False
        }
        val En_Compute_Row = Bool()
        when(Cnt_Row === io.ROW_NUM_CHANNEL_OUT_REG.asUInt - 1) {
            En_Compute_Row := True
        } otherwise {
            En_Compute_Row := False
        }

        when(isActive(Judge_Row) && isEntering(IDLE)) {
            io.Compute_Complete := True
        } otherwise {
            io.Compute_Complete := False
        }

        when(isActive(Compute)) {
            when(Cnt_Channel_Out_Num === 0) {
                io.rd_en_fifo := True
            } otherwise {
                io.rd_en_fifo := False
            }
        } otherwise {
            io.rd_en_fifo := False
        }
        when(Cnt_Channel_Out_Num === 0 && Cnt_Channel_In_Num === 0) {
            io.ram_temp_write_address := 0
        } elsewhen io.rd_en_fifo {
            io.ram_temp_write_address := (io.ram_temp_write_address.asUInt + 1).asBits
        }

        val ram_temp_read_address_temp = UInt(ROW_COL_DATA_COUNT_WIDTH bits) setAsReg()
        when(isActive(Compute)) {
            when(Cnt_Channel_In_Num === io.COMPUTE_TIMES_CHANNEL_IN_REG.asUInt - 1) {
                ram_temp_read_address_temp := 0
            } otherwise {
                ram_temp_read_address_temp := ram_temp_read_address_temp + 1
            }
        } otherwise {
            ram_temp_read_address_temp := 0
        }
        io.ram_temp_read_address := Delay(ram_temp_read_address_temp.asBits, 2)

        val weight_addrb_temp = UInt(WEIGHT_ADDR_WIDTH bits) setAsReg()
        when(isActive(Compute)) {
            when(Cnt_Channel_Out_Num === io.COMPUTE_TIMES_CHANNEL_OUT_REG.asUInt - 1 && Cnt_Channel_In_Num === io.COMPUTE_TIMES_CHANNEL_IN_REG.asUInt - 1) {
                weight_addrb_temp := 0
            } otherwise {
                weight_addrb_temp := weight_addrb_temp + 1
            }
        } otherwise {
            weight_addrb_temp := 0
        }
        io.weight_addrb := Delay(weight_addrb_temp.asBits, 2)

        val M_Fifo_Valid = Bool() setAsReg()
        when(isActive(Compute)) {
            when(Cnt_Channel_In_Num === io.COMPUTE_TIMES_CHANNEL_IN_REG.asUInt - 1) {
                M_Fifo_Valid := True
            } otherwise {
                M_Fifo_Valid := False
            }
        } otherwise {
            M_Fifo_Valid := False
        }

        //卷积的乘法器要设置3个延迟，加法器2个延迟
        //addr 2个，数据2个，乘法3个，加法取决与KERNEL_NUM，取决与CHANNEL_IN_NUM，累加一个
        var DELAY_CYCLE = 2 + 2 + 3 + (if (KERNEL_NUM == 9) 8 else 0) + 2 * (scala.math.log(CHANNEL_IN_NUM) / scala.math.log(2)).toInt + 1
        //先测试计算，测试没问题后增加适配
        // io.M_Valid := Delay(M_Fifo_Valid, 24)
        //io.M_Valid := Delay(M_Fifo_Valid, 26)
        io.M_Valid := Delay(M_Fifo_Valid, DELAY_CYCLE)
        val First_Complete = Bool() setAsReg()
        when(isActive(Compute)) {
            when(Cnt_Channel_In_Num === 0) {
                First_Complete := True
            } otherwise {
                First_Complete := False
            }
        } otherwise {
            First_Complete := False
        }
        //io.First_Compute_Complete := Delay(First_Complete, 23)
        //io.First_Compute_Complete := Delay(First_Complete, 25)
        io.First_Compute_Complete := Delay(First_Complete, DELAY_CYCLE - 1)
        IDLE
            .whenIsActive {
                when(io.Start_Cu) {
                    goto(Wait)
                } otherwise goto(IDLE)
            }
        Wait
            .whenIsActive {
                when(wait_en) {
                    goto(Judge_Before_Fifo)
                } otherwise goto(Wait)
            }
        Judge_Before_Fifo
            .whenIsActive {
                when(io.compute_fifo_ready) {
                    goto(Judge_After_Fifo)
                } otherwise goto(Judge_Before_Fifo)
            }
        Judge_After_Fifo
            .whenIsActive {
                when(io.M_ready) {
                    goto(Compute)
                } otherwise goto(Judge_After_Fifo)
            }
        Compute
            .whenIsActive {
                when(En_Compute_Column) {
                    goto(Judge_Row)
                } otherwise goto(Compute)
            }

        Judge_Row
            .whenIsActive {
                when(En_Compute_Row) {
                    goto(IDLE)
                } otherwise {
                    goto(Judge_Before_Fifo)
                }
            }
    }
}
