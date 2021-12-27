import spinal.core._
import spinal.lib._
import spinal.lib.fsm._

class Conv_Stride(
                     S_DATA_WIDTH: Int,
                     ROW_COL_DATA_COUNT_WIDTH: Int,
                     CHANNEL_NUM_WIDTH: Int,
                     CHANNEL_OUT_NUM: Int,
                     STRIDE_MEM_DEPTH: Int
                 ) extends Component {

    val io = new Bundle {
        val Start = in Bool()
        val EN_Stride_REG = in Bool()
        val S_DATA = slave Stream Bits(S_DATA_WIDTH bits)
        val M_DATA = master Stream Bits(S_DATA_WIDTH bits)
        val Row_Num_Out_REG = in Bits (ROW_COL_DATA_COUNT_WIDTH bits)
        val Channel_Out_Num_REG = in Bits (CHANNEL_NUM_WIDTH bits)
        val Last = out Bool()
        val Stride_Complete = out Bool()
    }
    noIoPrefix()

    //    val EN_Stride = Bool()
    //    val Start_reg = Delay(io.Start, 2)
    //    when(Start_reg && io.EN_Stride_REG) {
    //        EN_Stride := True
    //    } otherwise {
    //        EN_Stride := False
    //    }

    val row_num_out = Bits(ROW_COL_DATA_COUNT_WIDTH bits) setAsReg()
    when(io.EN_Stride_REG) {
        row_num_out := (io.Row_Num_Out_REG >> 1).resized
    } otherwise {
        row_num_out := io.Row_Num_Out_REG.resized
    }
    val data_count = Bits(ROW_COL_DATA_COUNT_WIDTH bits) setAsReg()
    val Channel_Times = io.Channel_Out_Num_REG >> log2Up(CHANNEL_OUT_NUM)
    val count_mult = new mul(ROW_COL_DATA_COUNT_WIDTH, ROW_COL_DATA_COUNT_WIDTH, ROW_COL_DATA_COUNT_WIDTH, false)
    count_mult.io.A := row_num_out
    count_mult.io.B := Channel_Times.resized
    count_mult.io.P <> data_count


    val fifo = new general_fifo_sync(S_DATA_WIDTH, S_DATA_WIDTH, STRIDE_MEM_DEPTH, ROW_COL_DATA_COUNT_WIDTH)
    fifo.io.s_data_count <> data_count.asUInt
    fifo.io.m_data_count <> data_count.asUInt
    fifo.io.data_in := RegNext(io.S_DATA.payload)
    fifo.io.data_in_ready <> io.S_DATA.ready
    fifo.io.data_valid <> io.M_DATA.valid
    fifo.io.rd_en := (io.M_DATA.valid && io.M_DATA.ready)
    fifo.io.data_out <> io.M_DATA.payload

    val fsm = new StateMachine {
        val IDLE = new State() with EntryPoint
        val WAIT = new State()
        val Stride = new State()
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

        val Cnt_Cin = UInt(CHANNEL_NUM_WIDTH bits) setAsReg()
        val En_Cin = Bool()
        when(Cnt_Cin === Channel_Times.asUInt - 1) {
            En_Cin := True
        } otherwise {
            En_Cin := False
        }
        when(isActive(Stride)) {
            when(io.S_DATA.valid) {
                when(En_Cin) {
                    Cnt_Cin := 0
                } otherwise {
                    Cnt_Cin := Cnt_Cin + 1
                }
            } otherwise {
                Cnt_Cin := Cnt_Cin
            }
        } otherwise {
            Cnt_Cin := 0
        }

        val Cnt_Col = UInt(ROW_COL_DATA_COUNT_WIDTH bits) setAsReg()
        val En_Col = Bool()
        when(Cnt_Col === io.Row_Num_Out_REG.asUInt - 1) {
            En_Col := True
        } otherwise {
            En_Col := False
        }
        when(isActive(Stride)) {
            when(io.S_DATA.valid) {
                when(En_Col && En_Cin) {
                    Cnt_Col := 0
                } elsewhen En_Cin {
                    Cnt_Col := Cnt_Col + 1
                } otherwise {
                    Cnt_Col := Cnt_Col
                }
            } otherwise {
                Cnt_Col := Cnt_Col
            }
        } otherwise {
            Cnt_Col := 0
        }

        val Cnt_Row = UInt(ROW_COL_DATA_COUNT_WIDTH bits) setAsReg()
        val En_Row = Bool()
        when(Cnt_Row === io.Row_Num_Out_REG.asUInt - 1) {
            En_Row := True
        } otherwise {
            En_Row := False
        }
        when(isActive(Stride)) {
            when(En_Col && En_Cin) {
                Cnt_Row := Cnt_Row + 1
            } otherwise {
                Cnt_Row := Cnt_Row
            }
        } otherwise {
            Cnt_Row := 0
        }


        val Valid_Out = Bool() setAsReg()
        when(isActive(Stride)) {
            when(io.EN_Stride_REG){
                when(!Cnt_Col.asBits(0) && (!Cnt_Row.asBits(0)) && io.S_DATA.valid) {
                    Valid_Out := True
                } otherwise {
                    Valid_Out := False
                }
            } otherwise{
                when(io.S_DATA.valid) {
                    Valid_Out := True
                } otherwise {
                    Valid_Out := False
                }
            }

        } otherwise {
            Valid_Out := False
        }
        fifo.io.wr_en := Valid_Out


        val M_Cnt_Cout = UInt(CHANNEL_NUM_WIDTH bits) setAsReg() init (0)
        val M_En_Last_Cout = Bool()
        when(M_Cnt_Cout === io.Channel_Out_Num_REG.asUInt - 1) {
            M_En_Last_Cout := True
        } otherwise {
            M_En_Last_Cout := False
        }
        when(io.M_DATA.valid && io.M_DATA.ready) {
            when(M_En_Last_Cout) {
                M_Cnt_Cout := 0
            } otherwise {
                M_Cnt_Cout := M_Cnt_Cout + 1
            }
        } otherwise {
            M_Cnt_Cout := M_Cnt_Cout
        }

        val M_Cnt_Column = UInt(ROW_COL_DATA_COUNT_WIDTH bits) setAsReg() init (0)
        val M_En_Last_Col = Bool()
        when(M_Cnt_Column === row_num_out.asUInt - 1) {
            M_En_Last_Col := True
        } otherwise {
            M_En_Last_Col := False
        }
        when(io.M_DATA.valid && io.M_DATA.ready && M_En_Last_Cout) {
            when(M_En_Last_Col) {
                M_Cnt_Column := 0
            } otherwise {
                M_Cnt_Column := M_Cnt_Column + 1
            }
        } otherwise {
            M_Cnt_Column := M_Cnt_Column
        }

        val M_Cnt_Row = UInt(ROW_COL_DATA_COUNT_WIDTH bits) setAsReg() init (0)
        val M_En_Last_Row = Bool()
        when(M_Cnt_Row === row_num_out.asUInt - 1) {
            M_En_Last_Row := True
        } otherwise {
            M_En_Last_Row := False
        }
        when(io.M_DATA.valid && io.M_DATA.ready) {
            when(M_En_Last_Row) {
                M_Cnt_Row := 0
            } elsewhen (M_En_Last_Col && M_En_Last_Cout) {
                M_Cnt_Row := M_Cnt_Row + 1
            } otherwise {
                M_Cnt_Row := M_Cnt_Row
            }
        } otherwise {
            M_Cnt_Row := M_Cnt_Row
        }

        when(M_En_Last_Row && M_En_Last_Col && M_En_Last_Cout) {
            io.Last := True
        } otherwise {
            io.Last := False
        }

        when(isActive(Stride) && isEntering(IDLE)) {
            io.Stride_Complete := True
        } otherwise {
            io.Stride_Complete := False
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
                    goto(Stride)
                } otherwise {
                    goto(WAIT)
                }
            }
        Stride
            .whenIsActive {
                when(En_Row && En_Col && En_Cin) {
                    goto(IDLE)
                } otherwise {
                    goto(Stride)
                }
            }
    }

}

object Conv_Stride{
    def main(args: Array[String]): Unit = {
        SpinalVerilog(new Conv_Stride(64,12,10,8,2048))
    }
}
