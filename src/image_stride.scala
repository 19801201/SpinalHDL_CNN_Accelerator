import spinal.core._
import spinal.lib._
import spinal.lib.fsm._

class image_stride(
                      S_DATA_WIDTH: Int,
                      M_DATA_WIDTH: Int,
                      MEM_DEPTH: Int,
                      FEATURE_MAP_SIZE: Int,
                      ROW_COL_DATA_COUNT_WIDTH: Int,
                      CHANNEL_OUT_TIMES: Int
                  ) extends Component {

    val io = new Bundle {
        val Start = in Bool()
        val S_DATA = slave Stream Bits(S_DATA_WIDTH bits)
        val M_DATA = master Stream Bits(M_DATA_WIDTH bits)
        val Stride_Complete = out Bool()
        val Img_Last = out Bool()
    }
    noIoPrefix()

    val stride_fifo = new general_fifo_sync(S_DATA_WIDTH, M_DATA_WIDTH, MEM_DEPTH, ROW_COL_DATA_COUNT_WIDTH)
    io.S_DATA.ready <> stride_fifo.io.data_in_ready
    stride_fifo.io.s_data_count := (FEATURE_MAP_SIZE >> 1) * CHANNEL_OUT_TIMES
    stride_fifo.io.m_data_count := (FEATURE_MAP_SIZE >> 1) * CHANNEL_OUT_TIMES
    io.M_DATA.valid <> stride_fifo.io.data_valid
    (io.M_DATA.ready & stride_fifo.io.data_valid) <> stride_fifo.io.rd_en
    io.M_DATA.payload <> stride_fifo.io.data_out
    val data_count = B((FEATURE_MAP_SIZE >> 1) * (FEATURE_MAP_SIZE >> 1) * CHANNEL_OUT_TIMES)
    val Cnt_Stride_Complete = UInt(data_count.getBitsWidth bits) setAsReg() init 0
    when(Cnt_Stride_Complete === data_count.asUInt - 1) {
        Cnt_Stride_Complete := 0
    } elsewhen(io.M_DATA.valid && io.M_DATA.ready){
        Cnt_Stride_Complete := Cnt_Stride_Complete + 1
    } otherwise{
        Cnt_Stride_Complete := Cnt_Stride_Complete
    }
    when(Cnt_Stride_Complete === data_count.asUInt - 1){
        io.Stride_Complete := True
        io.Img_Last := True
    } otherwise{
        io.Stride_Complete := False
        io.Img_Last := False
    }

    val fsm = new StateMachine {
        val IDLE = new State() with EntryPoint
        val STRIDE = new State()

        val Cnt_Row = UInt(ROW_COL_DATA_COUNT_WIDTH bits) setAsReg() init 0
        val Cnt_Channel_out = UInt(log2Up(CHANNEL_OUT_TIMES - 1) bits) setAsReg() init 0
        val Cnt_Column = UInt(ROW_COL_DATA_COUNT_WIDTH bits) setAsReg() init 0
        val En_Last_Channel_out = Bool()
        val En_Last_Col = Bool()
        val En_Last_Row = Bool()
        when(Cnt_Channel_out === CHANNEL_OUT_TIMES - 1) {
            En_Last_Channel_out := True
        } otherwise {
            En_Last_Channel_out := False
        }
        when(Cnt_Column === FEATURE_MAP_SIZE - 1) {
            En_Last_Col := True
        } otherwise {
            En_Last_Col := False
        }
        when(Cnt_Row === FEATURE_MAP_SIZE - 1) {
            En_Last_Row := True
        } otherwise {
            En_Last_Row := False
        }
        when(isActive(STRIDE)) {
            when(io.S_DATA.valid) {
                when(En_Last_Channel_out) {
                    Cnt_Channel_out := 0
                } otherwise {
                    Cnt_Channel_out := Cnt_Channel_out + 1
                }
            } otherwise {
                Cnt_Channel_out := Cnt_Channel_out
            }
        } otherwise {
            Cnt_Channel_out := 0
        }

        when(isActive(STRIDE)) {
            when(io.S_DATA.valid) {
                when(En_Last_Channel_out) {
                    when(En_Last_Col) {
                        Cnt_Column := 0
                    } otherwise {
                        Cnt_Column := Cnt_Column + 1
                    }
                } otherwise {
                    Cnt_Column := Cnt_Column
                }
            } otherwise {
                Cnt_Column := Cnt_Column
            }
        } otherwise {
            Cnt_Column := 0
        }
        when(isActive(STRIDE)) {
            when(En_Last_Channel_out && En_Last_Col) {
                Cnt_Row := Cnt_Row + 1
            } otherwise {
                Cnt_Row := Cnt_Row
            }
        } otherwise {
            Cnt_Row := 0
        }
        val wr_en_fifo = Bool() setAsReg() init False
        when(isActive(STRIDE)) {
            when(Cnt_Row(0).asUInt === 0 && Cnt_Column(0).asUInt === 0 && io.S_DATA.valid) {
                wr_en_fifo := True
            } otherwise {
                wr_en_fifo := False
            }
        } otherwise {
            wr_en_fifo := False
        }
        stride_fifo.io.wr_en := wr_en_fifo
        stride_fifo.io.data_in := RegNext(io.S_DATA.payload)


        IDLE
            .whenIsActive {
                when(io.Start) {
                    goto(STRIDE)
                } otherwise goto(IDLE)

            }
        STRIDE
            .whenIsActive {
                when(En_Last_Channel_out && En_Last_Col && En_Last_Row){
                    goto(IDLE)
                } otherwise{
                    goto(STRIDE)
                }

            }
    }
}

object image_stride {
    def main(args: Array[String]): Unit = {
        SpinalVerilog(new image_stride(64, 64, 1024, 640, 12, 4))
    }
}
