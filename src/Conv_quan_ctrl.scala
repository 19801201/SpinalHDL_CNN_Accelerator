import spinal.core._
import spinal.lib._
import spinal.lib.fsm._

class Conv_quan_ctrl(
                        ROW_COL_DATA_COUNT_WIDTH: Int,
                        BIAS_NUM_WIDTH: Int,
                        CHANNEL_NUM_WIDTH: Int,
                        CHANNEL_OUT_NUM: Int
                    ) extends Component {

    val io = new Bundle {
        val Start = in Bool()
        val bias_addrb = out Bits (BIAS_NUM_WIDTH bits)
        val EN_Rd_Fifo = out Bool()
        val Fifo_Ready = in Bool()
        val M_Ready = in Bool()
        val M_Valid = out Bool()
        val Row_Num_Out_REG = in Bits (ROW_COL_DATA_COUNT_WIDTH bits)
        val Channel_Out_Num_REG = in Bits (CHANNEL_NUM_WIDTH bits)
        val S_Count_Fifo = out Bits (ROW_COL_DATA_COUNT_WIDTH bits)
        val Leaky_REG = in Bool()
    }
    noIoPrefix()
    val Channel_Times = io.Channel_Out_Num_REG >> log2Up(CHANNEL_OUT_NUM)
    val count_mult = new mul(ROW_COL_DATA_COUNT_WIDTH, ROW_COL_DATA_COUNT_WIDTH, ROW_COL_DATA_COUNT_WIDTH, false)
    count_mult.io.A := io.Row_Num_Out_REG
    count_mult.io.B := Channel_Times.resized
    count_mult.io.P <> io.S_Count_Fifo
    val fsm = new StateMachine {
        val IDLE = new State() with EntryPoint
        val WAIT = new State()
        val Judge_Before_FIFO = new State()
        val Judge_After_FIFO = new State()
        val Compute = new State()
        val Judge = new State()

        val wait_cnt = UInt(5 bits) setAsReg()
        val wait_en = Bool()
        when(wait_cnt === 5) {
            wait_en := True
        } otherwise {
            wait_en := False
        }
        when(isActive(WAIT)) {
            wait_cnt := wait_cnt + 1
        } otherwise {
            wait_cnt := 0
        }


        val Cnt_Cout = UInt(CHANNEL_NUM_WIDTH bits) setAsReg()
        val EN_Last_Cout = Bool()
        when(Cnt_Cout === Channel_Times.asUInt - 1) {
            EN_Last_Cout := True
        } otherwise {
            EN_Last_Cout := False
        }
        when(isActive(Compute)) {
            when(EN_Last_Cout) {
                Cnt_Cout := 0
            } otherwise {
                Cnt_Cout := Cnt_Cout + 1
            }
        } otherwise {
            Cnt_Cout := 0
        }

        io.bias_addrb := Cnt_Cout.asBits.resized
        val fifo_rd_en_temp = Bool()
        when(isActive(Compute)) {
            fifo_rd_en_temp := True
        } otherwise {
            fifo_rd_en_temp := False
        }
        io.EN_Rd_Fifo := RegNext(fifo_rd_en_temp)
        val M_Valid_temp = Bool()
        when(isActive(Compute)) {
            M_Valid_temp := True
        } otherwise {
            M_Valid_temp := False
        }
        when(!io.Leaky_REG){
            io.M_Valid := Delay(M_Valid_temp, 20) //数据从 ram 进来 : 1个时钟周期  bias : 两个时钟周期     scale : 三个时钟周期  shift : 一个时钟周期   zero_point : 三个时钟周期    leaky_relu : 十个时钟周期
        } otherwise{
            io.M_Valid := Delay(M_Valid_temp, 10)
        }

        val Cnt_Column = UInt(ROW_COL_DATA_COUNT_WIDTH bits) setAsReg()
        val En_Col = Bool()
        when(EN_Last_Cout && (Cnt_Column === io.Row_Num_Out_REG.asUInt - 1)) {
            En_Col := True
        } otherwise {
            En_Col := False
        }
        when(isActive(Compute)) {
            when(EN_Last_Cout) {
                Cnt_Column := Cnt_Column + 1
            } otherwise {
                Cnt_Column := Cnt_Column
            }
        } otherwise {
            Cnt_Column := 0
        }
        val Cnt_Row = UInt(ROW_COL_DATA_COUNT_WIDTH bits) setAsReg()
        val En_Row = Bool()
        when(Cnt_Row === io.Row_Num_Out_REG.asUInt) {
            En_Row := True
        } otherwise {
            En_Row := False
        }
        when(isEntering(Judge)) {
            Cnt_Row := Cnt_Row + 1
        } elsewhen (isActive(IDLE)) {
            Cnt_Row := 0
        } otherwise {
            Cnt_Row := Cnt_Row
        }

        IDLE
            .whenIsActive {
                when(io.Start) {
                    goto(WAIT)
                } otherwise {
                    goto(IDLE)
                }
            }
        WAIT
            .whenIsActive {
                when(wait_en) {
                    goto(Judge_Before_FIFO)
                } otherwise {
                    goto(WAIT)
                }
            }
        Judge_Before_FIFO
            .whenIsActive {
                when(io.Fifo_Ready) {
                    goto(Judge_After_FIFO)
                } otherwise {
                    goto(Judge_Before_FIFO)
                }
            }
        Judge_After_FIFO
            .whenIsActive {
                when(io.M_Ready) {
                    goto(Compute)
                } otherwise {
                    goto(Judge_After_FIFO)
                }
            }
        Compute
            .whenIsActive {
                when(En_Col) {
                    goto(Judge)
                } otherwise {
                    goto(Compute)
                }
            }
        Judge
            .whenIsActive {
                when(En_Row) {
                    goto(IDLE)
                } otherwise {
                    goto(Judge_Before_FIFO)
                }
            }
    }
}
