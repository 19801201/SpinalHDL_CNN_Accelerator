import spinal.core._
import spinal.lib._
import spinal.lib.fsm._

class route(
               S_DATA_WIDTH: Int,
               M_DATA_WIDTH: Int,
               WIDTH_FEATURE_SIZE: Int,
               WIDTH_CHANNEL_NUM_REG: Int,
               CHANNEL_OUT_NUM: Int,
               ROUTE_S_FIFO_DEPTH: Int,
               ROUTE_M_FIFO_DEPTH: Int
           ) extends Component {

    val io = new Bundle {
        val Start = in Bool()
        val S_DATA = slave Stream Bits(S_DATA_WIDTH bits)
        val Row_Num_Out_REG = in Bits (WIDTH_FEATURE_SIZE bits)
        val Channel_Out_Num_REG = in Bits (WIDTH_CHANNEL_NUM_REG bits)
        val M_DATA = master Stream Bits(M_DATA_WIDTH bits)
        val Route_Complete = out Bool() setAsReg()
        val Last_Route = out Bool()
    }
    noIoPrefix()
    val Channel_Times = io.Channel_Out_Num_REG >> log2Up(CHANNEL_OUT_NUM)
    val Channel_Times_Out = Channel_Times >> 1
    val count_mult = new mul(WIDTH_FEATURE_SIZE, WIDTH_FEATURE_SIZE, WIDTH_FEATURE_SIZE, false)
    count_mult.io.A := io.Row_Num_Out_REG
    count_mult.io.B := Channel_Times.resized

    val Route_Read_fifo = new general_fifo_sync(S_DATA_WIDTH, S_DATA_WIDTH, ROUTE_S_FIFO_DEPTH, WIDTH_FEATURE_SIZE, true)
    Route_Read_fifo.io.wr_en <> (io.S_DATA.valid && io.S_DATA.ready)
    Route_Read_fifo.io.data_in <> io.S_DATA.payload
    Route_Read_fifo.io.s_data_count <> count_mult.io.P.asUInt
    Route_Read_fifo.io.m_data_count <> count_mult.io.P.asUInt
    Route_Read_fifo.io.data_in_ready <> io.S_DATA.ready

    val data_count = RegNext(io.Row_Num_Out_REG.asUInt * Channel_Times_Out.asUInt)
    val Route_Write_fifo = new general_fifo_sync(S_DATA_WIDTH, M_DATA_WIDTH, ROUTE_M_FIFO_DEPTH, WIDTH_FEATURE_SIZE, true)
    Route_Write_fifo.io.m_data_count <> data_count.resized
    Route_Write_fifo.io.s_data_count <> data_count.resized
    Route_Write_fifo.io.rd_en <> (io.M_DATA.ready && io.M_DATA.valid)
    Route_Write_fifo.io.data_out <> io.M_DATA.payload
    Route_Write_fifo.io.data_valid <> io.M_DATA.valid
    Route_Write_fifo.io.data_in := RegNext(Route_Read_fifo.io.data_out)

    val fsm = new StateMachine {
        val IDLE = new State() with EntryPoint
        val WAIT = new State()
        val Judge_Fifo = new State()
        val Write_Fifo = new State()
        val Judge_Last_Row = new State()


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


        val Cnt_Cin = UInt(WIDTH_CHANNEL_NUM_REG bits) setAsReg()
        val EN_Last_Cin = Bool()
        when(Cnt_Cin === Channel_Times.asUInt - 1) {
            EN_Last_Cin := True
        } otherwise {
            EN_Last_Cin := False
        }
        when(isActive(Write_Fifo)) {
            when(EN_Last_Cin) {
                Cnt_Cin := 0
            } otherwise {
                Cnt_Cin := Cnt_Cin + 1
            }
        } otherwise {
            Cnt_Cin := 0
        }
        val Cnt_Column = UInt(WIDTH_FEATURE_SIZE bits) setAsReg()
        val En_Col = Bool()
        when(Cnt_Column === io.Row_Num_Out_REG.asUInt - 1) {
            En_Col := True
        } otherwise {
            En_Col := False
        }
        when(isActive(Write_Fifo)) {
            when(EN_Last_Cin) {
                Cnt_Column := Cnt_Column + 1
            } otherwise {
                Cnt_Column := Cnt_Column
            }
        } otherwise {
            Cnt_Column := 0
        }

        val Cnt_Row = UInt(WIDTH_FEATURE_SIZE bits) setAsReg()
        val En_Row = Bool()
        when(Cnt_Row === io.Row_Num_Out_REG.asUInt - 1) {
            En_Row := True
        } otherwise {
            En_Row := False
        }
        when(isActive(Judge_Last_Row)) {
            Cnt_Row := Cnt_Row + 1
        } elsewhen isActive(IDLE) {
            Cnt_Row := 0
        } otherwise {
            Cnt_Row := Cnt_Row
        }


        val rd_en_fifo = Bool() setAsReg()
        when(isActive(Write_Fifo)) {
            rd_en_fifo := True
        } otherwise {
            rd_en_fifo := False
        }
        Route_Read_fifo.io.rd_en <> rd_en_fifo

        val Valid_Out = Bool() setAsReg()
        when(isActive(Write_Fifo)) {
            when(Cnt_Cin >= Channel_Times_Out.asUInt) {
                Valid_Out := True
            } otherwise {
                Valid_Out := False
            }
        } otherwise {
            Valid_Out := False
        }
        Route_Write_fifo.io.wr_en <> Valid_Out


        val M_Cnt_Cout = UInt(WIDTH_CHANNEL_NUM_REG bits) setAsReg() init (0)
        val M_En_Last_Cout = Bool()
        when(M_Cnt_Cout === Channel_Times_Out.asUInt - 1) {
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

        val M_Cnt_Column = UInt(WIDTH_FEATURE_SIZE bits) setAsReg() init (0)
        val M_En_Last_Col = Bool()
        when(M_Cnt_Column === io.Row_Num_Out_REG.asUInt - 1) {
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

        val M_Cnt_Row = UInt(WIDTH_FEATURE_SIZE bits) setAsReg() init (0)
        val M_En_Last_Row = Bool()
        when(M_Cnt_Row === io.Row_Num_Out_REG.asUInt - 1) {
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
            io.Last_Route := True
        } otherwise {
            io.Last_Route := False
        }
        when(io.Last_Route) {
            io.Route_Complete := True
        } otherwise {
            io.Route_Complete := False
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
                    goto(Judge_Fifo)
                } otherwise {
                    goto(WAIT)
                }
            }
        Judge_Fifo
            .whenIsActive {
                when(Route_Read_fifo.io.data_out_valid && Route_Write_fifo.io.empty) {
                    goto(Write_Fifo)
                } otherwise {
                    goto(Judge_Fifo)
                }
            }
        Write_Fifo
            .whenIsActive {
                when(En_Col && EN_Last_Cin) {
                    goto(Judge_Last_Row)
                } otherwise {
                    goto(Write_Fifo)
                }
            }
        Judge_Last_Row
            .whenIsActive {
                when(En_Row) {
                    goto(IDLE)
                } otherwise {
                    goto(Judge_Fifo)
                }
            }
    }


}
