import spinal.core._
import spinal.lib._
import spinal.lib.fsm._
import xfifo._

class upsampling(
                    S_DATA_WIDTH: Int,
                    M_DATA_WIDTH: Int,
                    WIDTH_FEATURE_SIZE: Int,
                    WIDTH_CHANNEL_NUM_REG: Int,
                    CHANNEL_OUT_NUM: Int,
                    UPSAMPLING_S_FIFO_DEPTH: Int,
                    UPSAMPLING_M_FIFO_DEPTH: Int
                ) extends Component {
    val io = new Bundle {
        val Start = in Bool()
        val S_DATA = slave Stream Bits(S_DATA_WIDTH bits)
        val M_DATA = master Stream Bits(M_DATA_WIDTH bits)
        val Row_Num_Out_REG = in Bits (WIDTH_FEATURE_SIZE bits)
        val Channel_Out_Num_REG = in Bits (WIDTH_CHANNEL_NUM_REG bits)
        val Upsample_Complete = out Bool() setAsReg()
        val Last_Upsample = out Bool()
    }
    noIoPrefix()

    val Channel_Times = io.Channel_Out_Num_REG >> log2Up(CHANNEL_OUT_NUM)
    val count_mult = new mul(WIDTH_FEATURE_SIZE, WIDTH_FEATURE_SIZE, WIDTH_FEATURE_SIZE, false)
    count_mult.io.A := io.Row_Num_Out_REG
    count_mult.io.B := Channel_Times.resized


    //    val Col1_DATA_WIDTH = io.Row_Num_Out_REG.getWidth + 2;
    val Col2_DATA_WIDTH = io.Row_Num_Out_REG.getWidth + 3;
    val Col1 = Bits(Col2_DATA_WIDTH bits)
    val count_mult1 = new mul(WIDTH_FEATURE_SIZE, 2, Col2_DATA_WIDTH, false)
    count_mult1.io.A := io.Row_Num_Out_REG
    count_mult1.io.B := B"2'd2"
    count_mult1.io.P <> Col1

    val Col2 = Bits(Col2_DATA_WIDTH bits)
    val count_mult2 = new mul(WIDTH_FEATURE_SIZE, 3, Col2_DATA_WIDTH, false)
    count_mult2.io.A := io.Row_Num_Out_REG
    count_mult2.io.B := B"3'd4"
    count_mult2.io.P <> Col2


    val Upsampling_Read_FIFO = new general_fifo_sync(S_DATA_WIDTH, S_DATA_WIDTH, UPSAMPLING_S_FIFO_DEPTH, WIDTH_FEATURE_SIZE, true)
    Upsampling_Read_FIFO.io.wr_en <> (io.S_DATA.valid && io.S_DATA.ready)
    Upsampling_Read_FIFO.io.data_in <> io.S_DATA.payload
    Upsampling_Read_FIFO.io.data_in_ready <> io.S_DATA.ready
    Upsampling_Read_FIFO.io.m_data_count <> count_mult.io.P.asUInt
    Upsampling_Read_FIFO.io.s_data_count <> count_mult.io.P.asUInt

    val rd_en = Vec(Bool(), 4)
    var fifo: List[fifo_sync] = Nil
    for (_ <- 0 until 4) {
        fifo = new fifo_sync(S_DATA_WIDTH, UPSAMPLING_S_FIFO_DEPTH, S_DATA_WIDTH, 0, "block", "fwft") :: fifo
    }
    fifo = fifo.reverse
    for (i <- 0 until 4) {
        fifo(i).io.wr_en := Upsampling_Read_FIFO.io.rd_en
        fifo(i).io.din := Upsampling_Read_FIFO.io.data_out
        fifo(i).io.rd_en := rd_en(i)
    }

    val wr_en = Bool() setAsReg()
    val Last_din = Bits(S_DATA_WIDTH bits) setAsReg()
    val Upsampling_Write_FIFO = new fifo_sync(S_DATA_WIDTH, UPSAMPLING_M_FIFO_DEPTH, S_DATA_WIDTH, 0, "block", "fwft")
    Upsampling_Write_FIFO.io.wr_en := wr_en
    Upsampling_Write_FIFO.io.din := Last_din
    Upsampling_Write_FIFO.io.rd_en := (io.M_DATA.ready && io.M_DATA.valid)
    Upsampling_Write_FIFO.io.dout <> io.M_DATA.payload
    Upsampling_Write_FIFO.io.data_valid <> io.M_DATA.valid

    val fsm = new StateMachine {
        val IDLE = new State() with EntryPoint
        val WAIT = new State()
        val Judge_Fifo = new State()
        val Write_Fifo = new State()
        val Read1_2 = new State()
        val Read3_4 = new State()
        val Judge_M_Fifo = new State()
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


        when(isActive(Write_Fifo)) {
            Upsampling_Read_FIFO.io.rd_en := True
        } otherwise {
            Upsampling_Read_FIFO.io.rd_en := False
        }


        val Cnt_Cin_2 = UInt(WIDTH_CHANNEL_NUM_REG bits) setAsReg()
        val EN_Last_Cin_2 = Bool()
        when(Cnt_Cin_2 === Channel_Times.asUInt - 1) {
            EN_Last_Cin_2 := True
        } otherwise {
            EN_Last_Cin_2 := False
        }
        when(isActive(Read1_2)) {
            when(EN_Last_Cin_2) {
                Cnt_Cin_2 := 0
            } otherwise {
                Cnt_Cin_2 := Cnt_Cin_2 + 1
            }
        } elsewhen isActive(Read3_4) {
            when(EN_Last_Cin_2) {
                Cnt_Cin_2 := 0
            } otherwise {
                Cnt_Cin_2 := Cnt_Cin_2 + 1
            }
        } otherwise {
            Cnt_Cin_2 := 0
        }

        rd_en(0).setAsReg()
        rd_en(2).setAsReg()
        val Cnt_Column_2 = UInt(Col2_DATA_WIDTH bits) setAsReg()
        when(isActive(Read1_2)) {
            when(EN_Last_Cin_2) {
                rd_en(0) := ~rd_en(0)
                Cnt_Column_2 := Cnt_Column_2 + 1
            } otherwise {
                rd_en(0) := rd_en(0)
                Cnt_Column_2 := Cnt_Column_2
            }
        } elsewhen isActive(Read3_4) {
            when(EN_Last_Cin_2) {
                rd_en(2) := ~rd_en(2)
                Cnt_Column_2 := Cnt_Column_2 + 1
            } otherwise {
                rd_en(2) := rd_en(2)
                Cnt_Column_2 := Cnt_Column_2
            }
        } otherwise {
            Cnt_Column_2 := 0
            rd_en(0) := False
            rd_en(2) := False
        }
        when(isActive(Read1_2)) {
            rd_en(1) := ~rd_en(0)
        } otherwise {
            rd_en(1) := False
        }
        when(isActive(Read3_4)) {
            rd_en(3) := ~rd_en(2)
        } otherwise {
            rd_en(3) := False
        }


        when(isActive(Read1_2) || isActive(Read3_4)) {
            wr_en := True
        } otherwise {
            wr_en := False
        }
        when(isActive(Read1_2)) {
            when(rd_en(0)) {
                Last_din := fifo(0).io.dout
            } otherwise {
                Last_din := fifo(1).io.dout
            }
        } elsewhen isActive(Read3_4) {
            when(rd_en(2)) {
                Last_din := fifo(2).io.dout
            } otherwise {
                Last_din := fifo(3).io.dout
            }
        } otherwise {
            Last_din := 0
        }

        val EN_Row_Read_2 = Bool()
        when(Cnt_Column_2 === Col1.asUInt - 1 && EN_Last_Cin_2) {
            EN_Row_Read_2 := True
        } otherwise {
            EN_Row_Read_2 := False
        }
        val EN_Row_Read_3 = Bool()
        when(Cnt_Column_2 === Col2.asUInt - 1 && EN_Last_Cin_2) {
            EN_Row_Read_3 := True
        } otherwise {
            EN_Row_Read_3 := False
        }

        val Cnt_Row = UInt(WIDTH_FEATURE_SIZE bits) setAsReg()
        val EN_Judge_Row = Bool()
        when(Cnt_Row === io.Row_Num_Out_REG.asUInt - 1) {
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
        val M_Cnt_Column = UInt(Col2_DATA_WIDTH bits) setAsReg() init (0)
        val M_En_Last_Col = Bool()
        when(M_Cnt_Column === Col1.asUInt - 1) {
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
        val M_Cnt_Row = UInt(Col2_DATA_WIDTH bits) setAsReg() init (0)
        val M_En_Last_Row = Bool()
        when(M_Cnt_Row === Col1.asUInt - 1) {
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
            io.Last_Upsample := True
        } otherwise {
            io.Last_Upsample := False
        }
        when(io.Last_Upsample) {
            io.Upsample_Complete := True
        } otherwise {
            io.Upsample_Complete := False
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
                when(Upsampling_Read_FIFO.io.data_out_valid) {
                    goto(Write_Fifo)
                } otherwise {
                    goto(Judge_Fifo)
                }
            }
        Write_Fifo
            .whenIsActive {
                when(En_Col && EN_Last_Cin) {
                    goto(Judge_M_Fifo)
                } otherwise {
                    goto(Write_Fifo)
                }
            }
        Judge_M_Fifo
            .whenIsActive {
                when(Upsampling_Write_FIFO.io.empty) {
                    goto(Read1_2)
                } otherwise {
                    goto(Judge_M_Fifo)
                }
            }
        Read1_2
            .whenIsActive {
                when(EN_Row_Read_2) {
                    goto(Read3_4)
                } otherwise {
                    goto(Read1_2)
                }
            }
        Read3_4
            .whenIsActive {
                when(EN_Row_Read_3) {
                    goto(Judge_LastRow)
                } otherwise {
                    goto(Read3_4)
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

object upsampling {
    def main(args: Array[String]): Unit = {
        SpinalVerilog(new upsampling(64, 64, 11, 10, 8, 512, 2048))
    }
}
