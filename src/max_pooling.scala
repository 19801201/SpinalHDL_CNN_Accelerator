import spinal.core._
import spinal.lib._
import spinal.lib.fsm._
import xfifo.fifo_sync

class max_pooling(
                     S_DATA_WIDTH: Int,
                     M_DATA_WIDTH: Int,
                     WIDTH_FEATURE_SIZE: Int,
                     WIDTH_CHANNEL_NUM_REG: Int,
                     CHANNEL_OUT_NUM: Int,
                     MAXPOOL_S_FIFO_DEPTH: Int,
                     MAXPOOL_M_FIFO_DEPTH: Int
                 ) extends Component {
    val io = new Bundle {
        val Start = in Bool()
        val S_DATA = slave Stream Bits(S_DATA_WIDTH bits)
        val M_DATA = master Stream Bits(M_DATA_WIDTH bits)
        val Row_Num_Out_REG = in Bits (WIDTH_FEATURE_SIZE bits)
        val Channel_Out_Num_REG = in Bits (WIDTH_CHANNEL_NUM_REG bits)
        val MaxPool_Complete = out Bool() setAsReg()
        val Last_Maxpool = out Bool()
    }
    noIoPrefix()

    val Channel_Times = io.Channel_Out_Num_REG >> log2Up(CHANNEL_OUT_NUM)
    val count_mult = new mul(WIDTH_FEATURE_SIZE, WIDTH_FEATURE_SIZE, WIDTH_FEATURE_SIZE, false)
    count_mult.io.A := io.Row_Num_Out_REG
    count_mult.io.B := Channel_Times.resized

    val rd_en_fifo = Bool() setAsReg()
    val Max_polling_Read_FIFO = new general_fifo_sync(S_DATA_WIDTH, S_DATA_WIDTH, MAXPOOL_S_FIFO_DEPTH, WIDTH_FEATURE_SIZE + 1, true)
    Max_polling_Read_FIFO.io.wr_en <> (io.S_DATA.valid && io.S_DATA.ready)
    Max_polling_Read_FIFO.io.data_in <> io.S_DATA.payload
    Max_polling_Read_FIFO.io.m_data_count <> (count_mult.io.P.asUInt << 1)
    Max_polling_Read_FIFO.io.s_data_count <> (count_mult.io.P.asUInt << 1)
    Max_polling_Read_FIFO.io.data_in_ready <> io.S_DATA.ready
    Max_polling_Read_FIFO.io.rd_en <> rd_en_fifo


    val max_pooling_compute = new max_pooling_compute(S_DATA_WIDTH, CHANNEL_OUT_NUM)
    val rd_en = Vec(Bool(), 4)
    val wr_en = Vec(Bool().setAsReg(), 4)
    var fifo: List[fifo_sync] = Nil
    for (_ <- 0 until 4) {
        fifo = new fifo_sync(S_DATA_WIDTH, MAXPOOL_S_FIFO_DEPTH / 2, S_DATA_WIDTH, 0, "block", "fwft") :: fifo
    }
    fifo = fifo.reverse
    for (i <- 0 until 4) {
        fifo(i).io.wr_en := wr_en(i)
        fifo(i).io.din := Max_polling_Read_FIFO.io.data_out
        fifo(i).io.rd_en := rd_en(i)
        max_pooling_compute.io.data_in(i) := fifo(i).io.dout
    }


    val EN = Bool() setAsReg()
    val Maxpooling_Write_FIFO = new fifo_sync(S_DATA_WIDTH, MAXPOOL_M_FIFO_DEPTH, S_DATA_WIDTH, 0, "block", "fwft")
    Maxpooling_Write_FIFO.io.din <> max_pooling_compute.io.data_out
    Maxpooling_Write_FIFO.io.wr_en <> RegNext(RegNext(EN))
    Maxpooling_Write_FIFO.io.dout <> io.M_DATA.payload
    Maxpooling_Write_FIFO.io.rd_en <> (io.M_DATA.ready && io.M_DATA.valid)
    Maxpooling_Write_FIFO.io.data_valid <> io.M_DATA.valid

    val fsm = new StateMachine {
        val IDLE = new State() with EntryPoint
        val WAIT = new State()
        val Judge_Fifo = new State()
        val Write_Fifo_1 = new State()
        val Write_Fifo_2 = new State()
        val Judge_M_Fifo = new State()
        val Compute = new State()
        val Judge_LastRow = new State()

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
        when(isActive(Write_Fifo_1) || isActive(Write_Fifo_2)) {
            when(EN_Last_Cin) {
                Cnt_Cin := 0
            } otherwise {
                Cnt_Cin := Cnt_Cin + 1
            }
        } otherwise {
            Cnt_Cin := 0
        }

        val CNT_COL_WIDTH = io.Row_Num_Out_REG.getWidth + 2
        val Cnt_Column = UInt(CNT_COL_WIDTH bits) setAsReg()
        val EN_Row_Read_1 = Bool()
        val EN_Row_Read_2 = Bool()
        when((Cnt_Column === io.Row_Num_Out_REG.asUInt - 1) && EN_Last_Cin) {
            EN_Row_Read_1 := True
        } otherwise {
            EN_Row_Read_1 := False
        }
        when((Cnt_Column === io.Row_Num_Out_REG.asUInt << 1 - 1) && EN_Last_Cin) {
            EN_Row_Read_2 := True
        } otherwise {
            EN_Row_Read_2 := False
        }
        when(isActive(Write_Fifo_1) || isActive(Write_Fifo_2)) {
            when(EN_Last_Cin) {
                Cnt_Column := Cnt_Column + 1
            } otherwise {
                Cnt_Column := Cnt_Column
            }
        } otherwise {
            Cnt_Column := 0
        }

        val Cnt_Row = UInt(CNT_COL_WIDTH bits) setAsReg()
        val EN_Judge_Row = Bool()
        when(Cnt_Row === (io.Row_Num_Out_REG >> 1).asUInt - 1) {
            EN_Judge_Row := True
        } otherwise {
            EN_Judge_Row := False
        }
        when(isActive(Judge_LastRow)) {
            Cnt_Row := Cnt_Row + 1
        } elsewhen isActive(IDLE) {
            Cnt_Row := 0
        } otherwise {
            Cnt_Row := Cnt_Row
        }


        when(isActive(Write_Fifo_1) || isActive(Write_Fifo_2)) {
            rd_en_fifo := True
        } otherwise {
            rd_en_fifo := False
        }
        when(isActive(Write_Fifo_1)) {
            wr_en(0) := True
            wr_en(1) := True
            wr_en(2) := False
            wr_en(3) := False
        } elsewhen isActive(Write_Fifo_2) {
            wr_en(0) := False
            wr_en(1) := False
            wr_en(2) := True
            wr_en(3) := True
        } otherwise {
            wr_en.map(_ := False)
        }


        val Cnt_Cin_2 = UInt(WIDTH_CHANNEL_NUM_REG bits) setAsReg()
        val EN_Last_Cin_2 = Bool()
        when(Cnt_Cin_2 === Channel_Times.asUInt - 1) {
            EN_Last_Cin_2 := True
        } otherwise {
            EN_Last_Cin_2 := False
        }
        when(isActive(Compute)) {
            when(EN_Last_Cin_2) {
                Cnt_Cin_2 := 0
            } otherwise {
                Cnt_Cin_2 := Cnt_Cin_2 + 1
            }
        } otherwise {
            Cnt_Cin_2 := 0
        }
        val Cnt_Column_2 = UInt(CNT_COL_WIDTH bits) setAsReg()
        when(isActive(Compute)) {
            when(EN_Last_Cin_2) {
                Cnt_Column_2 := Cnt_Column_2 + 1
            } otherwise {
                Cnt_Column_2 := Cnt_Column_2
            }
        } otherwise {
            Cnt_Column_2 := 0
        }
        val compute_complete = Bool()
        when(Cnt_Column_2 === io.Row_Num_Out_REG.asUInt && EN_Last_Cin_2) {
            compute_complete := True
        } otherwise {
            compute_complete := False
        }
        val compute_complete_qq = RegNext(RegNext(compute_complete))

        when(isActive(Compute)) {
            when(Cnt_Column_2 <= io.Row_Num_Out_REG.asUInt - 1) {
                rd_en(0) := True
                rd_en(2) := True
            } otherwise {
                rd_en(0) := False
                rd_en(2) := False
            }
            when(Cnt_Column_2 >= 1) {
                rd_en(1) := True
                rd_en(3) := True
            } otherwise {
                rd_en(1) := False
                rd_en(3) := False
            }
        } otherwise {
            rd_en.map(_ := False)
        }


        when(isActive(Compute)) {
            when(EN_Last_Cin_2 && !compute_complete) {
                EN := ~EN
            } otherwise {
                EN := EN
            }
        } otherwise {
            EN := False
        }


        val M_Cnt_Cout = UInt(WIDTH_CHANNEL_NUM_REG bits) setAsReg() init (0)
        val M_En_Last_Cout = Bool()
        when(M_Cnt_Cout === Channel_Times.asUInt - 1) {
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

        val data_count1 = RegNext(io.Row_Num_Out_REG >> 1)

        val M_Cnt_Column = UInt(WIDTH_FEATURE_SIZE bits) setAsReg() init (0)
        val M_En_Last_Col = Bool()
        when(M_Cnt_Column === data_count1.asUInt - 1) {
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
        when(M_Cnt_Row === data_count1.asUInt - 1) {
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
            io.Last_Maxpool := True
        } otherwise {
            io.Last_Maxpool := False
        }
        when(io.Last_Maxpool) {
            io.MaxPool_Complete := True
        } otherwise {
            io.MaxPool_Complete := False
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
                when(Max_polling_Read_FIFO.io.data_out_valid) {
                    goto(Write_Fifo_1)
                } otherwise {
                    goto(Judge_Fifo)
                }
            }
        Write_Fifo_1
            .whenIsActive {
                when(EN_Row_Read_1) {
                    goto(Write_Fifo_2)
                } otherwise {
                    goto(Write_Fifo_1)
                }
            }
        Write_Fifo_2
            .whenIsActive {
                when(EN_Row_Read_2) {
                    goto(Judge_M_Fifo)
                } otherwise {
                    goto(Write_Fifo_2)
                }
            }
        Judge_M_Fifo
            .whenIsActive {
                when(Maxpooling_Write_FIFO.io.empty) {
                    goto(Compute)
                } otherwise {
                    goto(Judge_M_Fifo)
                }
            }
        Compute
            .whenIsActive {
                when(compute_complete_qq) {
                    goto(Judge_LastRow)
                } otherwise {
                    goto(Compute)
                }
            }
        Judge_LastRow
            .whenIsActive {
                when(EN_Judge_Row) {
                    goto(IDLE)
                } otherwise {
                    goto(Judge_Fifo)
                }
            }
    }
}

object max_pooling {
    def main(args: Array[String]): Unit = {
        SpinalVerilog(new max_pooling(64, 64, 11, 10, 8, 8192, 2048))
    }
}
