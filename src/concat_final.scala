import spinal.core._
import spinal.lib._
import spinal.lib.fsm._

class concat_final(
                      RE_CHANNEL_IN_NUM: Int,
                      RE_WIDTH_FEATURE_SIZE: Int,
                      RE_WIDTH_CHANNEL_NUM_REG: Int,
                      RE_WIDTH_CONNECT_TIMES: Int,
                      S_DATA_WIDTH: Int,
                      M_DATA_WIDTH: Int,
                      ZERO_DATA_WIDTH: Int,
                      SCALE_DATA_WIDTH: Int,
                      CONNECT_S_FIFO1_DEPTH: Int,
                      CONNECT_S_FIFO2_DEPTH: Int,
                      CONNECT_M_FIFO_DEPTH: Int
                  ) extends Component {
    val io = new Bundle {
        val Start = in Bool()
        val Row_Num_Out_REG = in Bits (RE_WIDTH_FEATURE_SIZE bits)
        val Channel_Ram_Part = in Bits (RE_WIDTH_CHANNEL_NUM_REG bits)
        val Channel_Direct_Part = in Bits (RE_WIDTH_CHANNEL_NUM_REG bits)
        val Row_Num_In_REG = in Bits (RE_WIDTH_FEATURE_SIZE bits)
        val Connect_Complete = out Bool() setAsReg()

        val S_DATA_1 = slave Stream Bits(S_DATA_WIDTH bits)
        val S_DATA_2 = slave Stream Bits(S_DATA_WIDTH bits)

        val Concat1_ZeroPoint = in Bits (ZERO_DATA_WIDTH bits)
        val Concat2_ZeroPoint = in Bits (ZERO_DATA_WIDTH bits)
        val Concat1_Scale = in Bits (SCALE_DATA_WIDTH bits)
        val Concat2_Scale = in Bits (SCALE_DATA_WIDTH bits)

        val M_DATA = master Stream Bits(M_DATA_WIDTH bits)
        val Last_Concat = out Bool()
    }
    noIoPrefix()

    val Ram_Channel_Times = io.Channel_Ram_Part >> log2Up(RE_CHANNEL_IN_NUM)
    val Direct_Channel_Times = io.Channel_Direct_Part >> log2Up(RE_CHANNEL_IN_NUM)

    val S_Count_Fifo_1 = Bits(RE_WIDTH_FEATURE_SIZE bits)
    val S_Count_Fifo_2 = Bits(RE_WIDTH_FEATURE_SIZE bits)
    val S_Count_Fifo_3 = Bits(RE_WIDTH_FEATURE_SIZE bits)
    S_Count_Fifo_3 := RegNext((S_Count_Fifo_1.asUInt + S_Count_Fifo_2.asUInt).asBits)
    val count_mult1 = new mul(RE_WIDTH_FEATURE_SIZE, RE_WIDTH_FEATURE_SIZE, RE_WIDTH_FEATURE_SIZE, false)
    count_mult1.io.A := io.Row_Num_Out_REG
    count_mult1.io.B := Ram_Channel_Times.resized
    count_mult1.io.P <> S_Count_Fifo_1

    val count_mult2 = new mul(RE_WIDTH_FEATURE_SIZE, RE_WIDTH_FEATURE_SIZE, RE_WIDTH_FEATURE_SIZE, false)
    count_mult2.io.A := io.Row_Num_Out_REG
    count_mult2.io.B := Direct_Channel_Times.resized
    count_mult2.io.P <> S_Count_Fifo_2

    val concat_read_fifo_1 = new general_fifo_sync(S_DATA_WIDTH, S_DATA_WIDTH, CONNECT_S_FIFO1_DEPTH, RE_WIDTH_FEATURE_SIZE, true)
    val concat_read_fifo_2 = new general_fifo_sync(S_DATA_WIDTH, S_DATA_WIDTH, CONNECT_S_FIFO2_DEPTH, RE_WIDTH_FEATURE_SIZE, true)

    concat_read_fifo_1.io.data_in <> io.S_DATA_1.payload
    concat_read_fifo_1.io.wr_en <> (io.S_DATA_1.valid && io.S_DATA_1.ready)
    concat_read_fifo_1.io.m_data_count <> S_Count_Fifo_1.asUInt
    concat_read_fifo_1.io.s_data_count <> S_Count_Fifo_1.asUInt
    concat_read_fifo_1.io.data_in_ready <> io.S_DATA_1.ready

    concat_read_fifo_2.io.data_in <> io.S_DATA_2.payload
    concat_read_fifo_2.io.wr_en <> (io.S_DATA_2.valid && io.S_DATA_2.ready)
    concat_read_fifo_2.io.m_data_count <> S_Count_Fifo_2.asUInt
    concat_read_fifo_2.io.s_data_count <> S_Count_Fifo_2.asUInt
    concat_read_fifo_2.io.data_in_ready <> io.S_DATA_2.ready


    def data_convert(in: Bits, zero: Bits, scale: Bits): Bits = {
        val Ram_Data_Trans = Bits(RE_CHANNEL_IN_NUM * 32 bits) setAsReg()
        for (i <- 0 until RE_CHANNEL_IN_NUM) {
            Ram_Data_Trans((i + 1) * 32 - 1 downto i * 32) := B"8'd0" ## in((i + 1) * 8 - 1 downto i * 8) ## B"16'd0"
        }

        val Concat_Zero = new concat_zero(RE_CHANNEL_IN_NUM * 32, RE_CHANNEL_IN_NUM, ZERO_DATA_WIDTH)
        Concat_Zero.io.data_in <> Ram_Data_Trans
        Concat_Zero.io.zero <> zero

        val Concat_Scale = new concat_scale(RE_CHANNEL_IN_NUM * 32, RE_CHANNEL_IN_NUM, SCALE_DATA_WIDTH)
        Concat_Scale.io.data_in <> Concat_Zero.io.data_out
        Concat_Scale.io.scale <> scale

        val Concat_32to8 = new connect_32to8(RE_CHANNEL_IN_NUM * 32, RE_CHANNEL_IN_NUM, S_DATA_WIDTH)
        Concat_32to8.io.data_in <> Concat_Scale.io.data_out

        Concat_32to8.io.data_out
    }

    val Ram_Data_Final = data_convert(concat_read_fifo_1.io.data_out, io.Concat1_ZeroPoint, io.Concat1_Scale)
    val S_Data_Final = data_convert(concat_read_fifo_2.io.data_out, io.Concat2_ZeroPoint, io.Concat2_Scale)
    val En_Write = Bool()
    val M_Fifo_Data = Bits(S_DATA_WIDTH bits) setAsReg()
    val FIFO_Concat = new general_fifo_sync(S_DATA_WIDTH, M_DATA_WIDTH, CONNECT_M_FIFO_DEPTH, RE_WIDTH_FEATURE_SIZE, true)
    FIFO_Concat.io.data_in <> M_Fifo_Data
    FIFO_Concat.io.wr_en <> En_Write
    //    FIFO_Concat.io.s_data_count <> S_Count_Fifo_3.asUInt
    //    FIFO_Concat.io.m_data_count <> S_Count_Fifo_3.asUInt
    FIFO_Concat.io.rd_en <> (io.M_DATA.ready && io.M_DATA.valid)
    FIFO_Concat.io.data_valid <> io.M_DATA.valid
    FIFO_Concat.io.data_out <> io.M_DATA.payload
    val data_count2 = RegNext((Ram_Channel_Times.asUInt + Direct_Channel_Times.asUInt).asBits)
    val M_Cnt_Cout = UInt(RE_WIDTH_CONNECT_TIMES bits) setAsReg() init (0)
    val M_En_Last_Cout = Bool()
    when(M_Cnt_Cout === data_count2.asUInt - 1) {
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
    val M_Cnt_Column = UInt(RE_WIDTH_FEATURE_SIZE bits) setAsReg() init (0)
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
    val M_Cnt_Row = UInt(RE_WIDTH_FEATURE_SIZE bits) setAsReg() init (0)
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
        io.Last_Concat := True
    } otherwise {
        io.Last_Concat := False
    }
    when(io.Last_Concat) {
        io.Connect_Complete := True
    } otherwise {
        io.Connect_Complete := False
    }

    val fsm = new StateMachine {
        val IDLE = new State() with EntryPoint
        val WAIT = new State()
        val Judge_Before_Fifo = new State()
        val Judge_After_Fifo = new State()
        val READ_S_DATA_1 = new State()
        val WAIT_S_DATA_1 = new State()
        val Direct_Data = new State()
        val Judge_Col = new State()
        val Judge_Row = new State()


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


        val Ram_Channel_Cnt = UInt(RE_WIDTH_CONNECT_TIMES bits) setAsReg()
        val Ram_Complete = Bool()
        when(Ram_Channel_Cnt === Ram_Channel_Times.asUInt - 1) {
            Ram_Complete := True
        } otherwise {
            Ram_Complete := False
        }
        when(isActive(READ_S_DATA_1)) {
            Ram_Channel_Cnt := Ram_Channel_Cnt + 1
        } otherwise {
            Ram_Channel_Cnt := 0
        }

        val sign = Bool() setAsReg()
        when(isEntering(WAIT_S_DATA_1)) {
            sign := True
        } otherwise {
            sign := False
        }
        val sign_delay = Bool()
        sign_delay := Delay(sign, 8)

        val rd_en_fifo_1 = Bool() setAsReg()
        when(isActive(READ_S_DATA_1)) {
            rd_en_fifo_1 := True
        } otherwise {
            rd_en_fifo_1 := False
        }
        val En_Write_1 = History(rd_en_fifo_1, 9)
        val rd_en_fifo_2 = Bool() setAsReg()
        when(isActive(Direct_Data)) {
            rd_en_fifo_2 := True
        } otherwise {
            rd_en_fifo_2 := False
        }
        val En_Write_2 = History(rd_en_fifo_2, 9)

        En_Write := En_Write_1(8) || En_Write_2(8)
        when(En_Write_1(7)) {
            M_Fifo_Data := Ram_Data_Final
        } elsewhen En_Write_2(7) {
            M_Fifo_Data := S_Data_Final
        } otherwise {
            M_Fifo_Data := 0
        }
        concat_read_fifo_1.io.rd_en <> rd_en_fifo_1
        concat_read_fifo_2.io.rd_en <> rd_en_fifo_2


        val Direct_Complete = Bool()
        val Direct_Channel_Cnt = UInt(RE_WIDTH_CONNECT_TIMES bits) setAsReg()
        when(Direct_Channel_Cnt === Direct_Channel_Times.asUInt - 1) {
            Direct_Complete := True
        } otherwise {
            Direct_Complete := False
        }
        when(isActive(Direct_Data)) {
            Direct_Channel_Cnt := Direct_Channel_Cnt + 1
        } otherwise {
            Direct_Channel_Cnt := 0
        }

        val Col_Complete = Bool()
        val Col_Cnt = UInt(RE_WIDTH_FEATURE_SIZE bits) setAsReg()
        when(Col_Cnt === io.Row_Num_Out_REG.asUInt - 1) {
            Col_Complete := True
        } otherwise {
            Col_Complete := False
        }
        when(isActive(Judge_Col)) {
            when(Col_Complete) {
                Col_Cnt := 0
            } otherwise {
                Col_Cnt := Col_Cnt + 1
            }
        } elsewhen isActive(IDLE) {
            Col_Cnt := 0
        } otherwise {
            Col_Cnt := Col_Cnt
        }
        val Row_Cnt = UInt(RE_WIDTH_FEATURE_SIZE bits) setAsReg()
        val Row_Complete = Bool()
        when(Row_Cnt === io.Row_Num_In_REG.asUInt - 1) {
            Row_Complete := True
        } otherwise {
            Row_Complete := False
        }
        when(isActive(Judge_Row)) {
            when(Row_Complete) {
                Row_Cnt := 0
            } otherwise {
                Row_Cnt := Row_Cnt + 1
            }
        } elsewhen isActive(IDLE) {
            Row_Cnt := 0
        } otherwise {
            Row_Cnt := Row_Cnt
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
                    goto(Judge_Before_Fifo)
                } otherwise {
                    goto(WAIT)
                }
            }
        Judge_Before_Fifo
            .whenIsActive {
                when(concat_read_fifo_1.io.data_out_valid && concat_read_fifo_2.io.data_out_valid) {
                    goto(Judge_After_Fifo)
                } otherwise {
                    goto(Judge_Before_Fifo)
                }
            }
        Judge_After_Fifo
            .whenIsActive {
                when(FIFO_Concat.io.empty) {
                    goto(READ_S_DATA_1)
                } otherwise {
                    goto(Judge_After_Fifo)
                }
            }
        READ_S_DATA_1
            .whenIsActive {
                when(Ram_Complete) {
                    goto(WAIT_S_DATA_1)
                } otherwise {
                    goto(READ_S_DATA_1)
                }
            }
        WAIT_S_DATA_1
            .whenIsActive {
                when(sign_delay) {
                    goto(Direct_Data)
                } otherwise {
                    goto(WAIT_S_DATA_1)
                }
            }
        Direct_Data
            .whenIsActive {
                when(Direct_Complete) {
                    goto(Judge_Col)
                } otherwise {
                    goto(Direct_Data)
                }
            }
        Judge_Col
            .whenIsActive {
                when(Col_Complete) {
                    goto(Judge_Row)
                } otherwise {
                    goto(Judge_Before_Fifo)
                }
            }
        Judge_Row
            .whenIsActive {
                when(Row_Complete) {
                    goto(IDLE)
                } otherwise {
                    goto(Judge_Before_Fifo)
                }
            }
    }
}

object concat_final{
    def main(args: Array[String]): Unit = {
        SpinalVerilog(new concat_final(8,15,10,10,64,64,32,32,2048,2048,1024))
    }
}
