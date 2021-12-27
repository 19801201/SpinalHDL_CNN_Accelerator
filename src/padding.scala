import spinal.core._
import spinal.lib._
import spinal.lib.fsm._
import xip._

class padding(
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
        val M_DATA = master Stream Bits(M_DATA_WIDTH bits)
        val Row_Num_In_REG = in Bits (ROW_COL_DATA_COUNT_WIDTH bits)
        val Channel_In_Num_REG = in Bits (CHANNEL_NUM_WIDTH bits)
        val Padding_REG = in Bool()
        val Zero_Point_REG = in Bits (DATA_WIDTH bits)
        val Zero_Num_REG = in Bits (ZERO_NUM_WIDTH bits)
        val RowNum_After_Padding = out Bits (ROW_COL_DATA_COUNT_WIDTH bits)

    }
    noIoPrefix()
    val Channel_Times = io.Channel_In_Num_REG.asUInt >> 3
    val Zero_Point = Bits(M_DATA_WIDTH bits)
    for (i <- 0 until M_DATA_WIDTH / DATA_WIDTH) {
        Zero_Point((i + 1) * DATA_WIDTH - 1 downto i * DATA_WIDTH) := io.Zero_Point_REG
    }


    val count_mult = new mul(ROW_COL_DATA_COUNT_WIDTH, Channel_Times.getWidth, ROW_COL_DATA_COUNT_WIDTH,false)
    count_mult.io.A := io.Row_Num_In_REG
    count_mult.io.B := Channel_Times.asBits

    //    val S_Count_Fifo = UInt(ROW_COL_DATA_COUNT_WIDTH bits)
    val fifo = new padding_fifo(S_DATA_WIDTH, S_DATA_WIDTH, MEMORY_DEPTH, ROW_COL_DATA_COUNT_WIDTH)
    fifo.io.wr_en <> io.S_DATA.valid
    fifo.io.data_in <> io.S_DATA.payload
    fifo.io.data_in_ready <> io.S_DATA.ready
    fifo.io.m_data_count <> count_mult.io.P.asUInt
    val EN_Row0 = Bool()
    val EN_Row1 = Bool()
    val EN_Col0 = Bool()
    val EN_Col1 = Bool()
    when(io.Padding_REG) {
        EN_Row0 := True
        EN_Row1 := True
        EN_Col0 := True
        EN_Col1 := True
    } otherwise {
        EN_Row0 := False
        EN_Row1 := False
        EN_Col0 := False
        EN_Col1 := False
    }
    val In_Size = RegNext(io.Row_Num_In_REG).asUInt
    val Out_Size = UInt(ROW_COL_DATA_COUNT_WIDTH bits)
    when(io.Padding_REG) {
        Out_Size := io.Row_Num_In_REG.asUInt +  2*io.Zero_Num_REG.asUInt
    } otherwise {
        Out_Size := io.Row_Num_In_REG.asUInt
    }
    io.RowNum_After_Padding := Out_Size.asBits

    val padding_fsm = new StateMachine {
        val IDLE = new State() with EntryPoint
        val INIT = new State()
        val M_Row_Wait = new State()
        val S_Row_Wait = new State()
        val M_Row_Read = new State()
        val Judge_Row = new State()
        val S_Left_Padding = new State()
        val M_Up_Down_Padding = new State()
        val M_Right_Padding = new State()


        val wait_cnt = UInt(6 bits) setAsReg()
        when(isActive(INIT)) {
            wait_cnt := wait_cnt + 1
        } otherwise {
            wait_cnt := 0
        }
        val init_en = Bool()
        when(wait_cnt === 5) {
            init_en := True
        } otherwise {
            init_en := False
        }

        val Cnt_Row = UInt(ROW_COL_DATA_COUNT_WIDTH bits) setAsReg()
        when(isActive(Judge_Row)) {
            Cnt_Row := Cnt_Row + 1
        } elsewhen isActive(IDLE) {
            Cnt_Row := 0
        } otherwise {
            Cnt_Row := Cnt_Row
        }
        val EN_Left_Padding = Bool()
        when((EN_Row0 && Cnt_Row < io.Zero_Num_REG.asUInt) || (EN_Row1 & (Cnt_Row > Out_Size - io.Zero_Num_REG.asUInt - 1))) {
            EN_Left_Padding := True
        } otherwise {
            EN_Left_Padding := False
        }

        val Cnt_Cin = UInt(CHANNEL_NUM_WIDTH bits) setAsReg()
        val EN_Last_Cin = Bool()
        when(Cnt_Cin === Channel_Times - 1) {
            EN_Last_Cin := True
        } otherwise {
            EN_Last_Cin := False
        }
        when(isActive(M_Row_Read) || isActive(M_Up_Down_Padding) || isActive(S_Left_Padding) || isActive(M_Right_Padding)) {
            when(EN_Last_Cin) {
                Cnt_Cin := 0
            } otherwise {
                Cnt_Cin := Cnt_Cin + 1
            }
        } otherwise {
            Cnt_Cin := 0
        }


        val Cnt_Column = UInt(ROW_COL_DATA_COUNT_WIDTH bits) setAsReg()
        val EN_Row_Read = Bool()
        when(Cnt_Column === In_Size - 1 && EN_Last_Cin) {
            EN_Row_Read := True
        } otherwise {
            EN_Row_Read := False
        }
        when(isActive(M_Row_Read) || isActive(M_Up_Down_Padding)) {
            when(EN_Last_Cin) {
                Cnt_Column := Cnt_Column + 1
            } otherwise {
                Cnt_Column := Cnt_Column
            }
        } otherwise {
            Cnt_Column := 0
        }

        val EN_Judge_Row = Bool()
        when(Cnt_Row === Out_Size - 1) {
            EN_Judge_Row := True
        } otherwise {
            EN_Judge_Row := False
        }

        when(isActive(M_Row_Read)) {
            fifo.io.rd_en := True
        } otherwise {
            fifo.io.rd_en := False
        }

        when(isActive(S_Left_Padding) || isActive(M_Up_Down_Padding) || isActive(M_Right_Padding) || isActive(M_Row_Read)) {
            io.M_DATA.valid := True
        } otherwise {
            io.M_DATA.valid := False
        }

        when(isActive(S_Left_Padding) || isActive(M_Up_Down_Padding) || isActive(M_Right_Padding)) {
            io.M_DATA.payload := Zero_Point
        } elsewhen isActive(M_Row_Read) {
            io.M_DATA.payload := fifo.io.data_out
        } otherwise {
            io.M_DATA.payload := 0
        }

        IDLE
            .whenIsActive {
                when(io.Start) {
                    goto(INIT)
                } otherwise goto(IDLE)
            }
        INIT
            .whenIsActive {
                when(init_en) {
                    goto(M_Row_Wait)
                } otherwise goto(INIT)
            }
        M_Row_Wait
            .whenIsActive {
                when(io.M_DATA.ready) {
                    when(EN_Row0) {
                        goto(S_Left_Padding)
                    } otherwise {
                        goto(S_Row_Wait)
                    }
                } otherwise {
                    goto(M_Row_Wait)
                }
            }
        S_Row_Wait
            .whenIsActive {
                when(fifo.io.data_out_valid) {
                    goto(M_Row_Read)
                } otherwise {
                    goto(S_Row_Wait)
                }
            }
        M_Row_Read
            .whenIsActive {
                when(EN_Row_Read) {
                    when(!EN_Col1) {
                        goto(Judge_Row)
                    } otherwise goto(M_Right_Padding)

                } otherwise goto(M_Row_Read)
            }
        Judge_Row
            .whenIsActive {
                when(EN_Judge_Row) {
                    goto(IDLE)
                } otherwise {
                    goto(M_Row_Wait)
                }
            }
        S_Left_Padding
            .whenIsActive {
                when(EN_Left_Padding) {
                    when(EN_Last_Cin) {
                        goto(M_Up_Down_Padding)
                    } otherwise goto(S_Left_Padding)

                } otherwise {
                    when(EN_Last_Cin) {
                        goto(S_Row_Wait)
                    } otherwise goto(S_Left_Padding)
                }
            }
        M_Up_Down_Padding
            .whenIsActive {
                when(EN_Row_Read) {
                    when(!EN_Col1) {
                        goto(Judge_Row)
                    } otherwise {
                        goto(M_Right_Padding)
                    }
                } otherwise goto(M_Up_Down_Padding)
            }
        M_Right_Padding
            .whenIsActive {
                when(EN_Last_Cin) {
                    goto(Judge_Row)
                } otherwise goto(M_Right_Padding)
            }

    }
}
object padding{
    def main(args: Array[String]): Unit = {
        SpinalVerilog(new padding(64,64,12,4,8,3,2048))
    }
}
