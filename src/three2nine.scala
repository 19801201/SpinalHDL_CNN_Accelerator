import spinal.core._
import spinal.lib._
import spinal.lib.fsm._

class three2nine(
                    S_DATA_WIDTH: Int,
                    M_DATA_WIDTH: Int,
                    CHANNEL_NUM_WIDTH: Int,
                    ROW_COL_DATA_COUNT_WIDTH: Int
                ) extends Component {
    val io = new Bundle {
        val Start = in Bool()
        val S_DATA = in Bits (S_DATA_WIDTH bits)
        val S_DATA_Valid = in Bool()
        val S_DATA_Ready = out Bool()
        val S_DATA_Addr = out UInt (ROW_COL_DATA_COUNT_WIDTH bits) setAsReg() init 0
        val Row_Num_After_Padding = in UInt (ROW_COL_DATA_COUNT_WIDTH bits)
        val Channel_In_Num_REG = in Bits (CHANNEL_NUM_WIDTH bits)
        val Row_Compute_Sign = in Bool()
        val M_Data = out Bits (M_DATA_WIDTH bits)
        val M_Ready = in Bool()
        val M_Valid = out Bits (9 bits) setAsReg() init 0
        val S_Ready = out Bool()
    }
    noIoPrefix()

    val Channel_Times = io.Channel_In_Num_REG.asUInt >> 3


    val t2n_fsm = new StateMachine {
        val IDLE = new State() with EntryPoint
        val Start_Wait = new State()
        val Judge_FIFO = new State()
        val ComputeRow_Read = new State()
        val Judge_LastRow = new State()

        val Cnt_Cin = UInt(CHANNEL_NUM_WIDTH bits) setAsReg()
        val EN_Last_Cin = Bool()
        when(Cnt_Cin === Channel_Times - 1) {
            EN_Last_Cin := True
        } otherwise {
            EN_Last_Cin := False
        }
        when(isActive(ComputeRow_Read)) {
            when(EN_Last_Cin) {
                Cnt_Cin := 0
            } otherwise {
                Cnt_Cin := Cnt_Cin + 1
            }
        } otherwise {
            Cnt_Cin := 0
        }

        val Cnt_Column = UInt(ROW_COL_DATA_COUNT_WIDTH bits) setAsReg()
        val EN_ComputeRow_Read = Bool()
        when(Cnt_Column === io.Row_Num_After_Padding - 1) {
            EN_ComputeRow_Read := True
        } otherwise (EN_ComputeRow_Read := False)
        when(isActive(ComputeRow_Read)) {
            when(EN_Last_Cin) {
                Cnt_Column := Cnt_Column + 1
            } otherwise {
                Cnt_Column := Cnt_Column
            }
        } otherwise {
            Cnt_Column := 0
        }

        val Cnt_Row = UInt(ROW_COL_DATA_COUNT_WIDTH bits) setAsReg()
        val EN_Judge_LastRow = Bool()
        when(Cnt_Row === io.Row_Num_After_Padding - 2) {
            EN_Judge_LastRow := True
        } otherwise {
            EN_Judge_LastRow := False
        }

        when(isEntering(Judge_LastRow)) {
            Cnt_Row := Cnt_Row + 1
        } elsewhen isActive(IDLE) {
            Cnt_Row := 0
        } otherwise {
            Cnt_Row := Cnt_Row
        }

        when(isActive(ComputeRow_Read)) {
            io.S_DATA_Ready := True
        } otherwise {
            io.S_DATA_Ready := False
        }
        when(io.S_DATA_Ready) {
            io.S_DATA_Addr := io.S_DATA_Addr + 1
        } otherwise {
            io.S_DATA_Addr := 0
        }
        when(isActive(Start_Wait)) {
            io.S_Ready := True
        } otherwise {
            io.S_Ready := False
        }
        for (i <- 0 to 2) {
            io.M_Data(3 * (i + 1) * 64 - 1 downto (3 * i * 64)) := io.S_DATA((i + 1) * 64 - 1 downto (i * 64)) ## io.S_DATA((i + 1) * 64 - 1 downto (i * 64)) ## io.S_DATA((i + 1) * 64 - 1 downto (i * 64))
        }
        when(isActive(ComputeRow_Read)) {

            when(Cnt_Column < io.Row_Num_After_Padding - 2) {
                io.M_Valid(0) := True
                io.M_Valid(3) := True
                io.M_Valid(6) := True
            } otherwise {
                io.M_Valid(0) := False
                io.M_Valid(3) := False
                io.M_Valid(6) := False
            }
            when(Cnt_Column > 0 && Cnt_Column < io.Row_Num_After_Padding - 1) {
                io.M_Valid(1) := True
                io.M_Valid(4) := True
                io.M_Valid(7) := True
            } otherwise {
                io.M_Valid(1) := False
                io.M_Valid(4) := False
                io.M_Valid(7) := False
            }
            when(Cnt_Column > 1 && Cnt_Column < io.Row_Num_After_Padding) {
                io.M_Valid(2) := True
                io.M_Valid(5) := True
                io.M_Valid(8) := True
            } otherwise {
                io.M_Valid(2) := False
                io.M_Valid(5) := False
                io.M_Valid(8) := False
            }
        } otherwise {
            io.M_Valid.clearAll()
        }
        IDLE
            .whenIsActive {
                when(io.Start) {
                    goto(Start_Wait)
                } otherwise goto(IDLE)
            }
        Start_Wait
            .whenIsActive {
                when(io.Row_Compute_Sign) {
                    goto(Judge_FIFO)
                } otherwise goto(Start_Wait)

            }
        Judge_FIFO
            .whenIsActive {
                when(io.M_Ready) {
                    goto(ComputeRow_Read)
                } otherwise goto(Judge_FIFO)
            }
        ComputeRow_Read
            .whenIsActive {
                when(EN_ComputeRow_Read && EN_Last_Cin) {
                    goto(Judge_LastRow)
                } otherwise {
                    goto(ComputeRow_Read)
                }
            }
        Judge_LastRow
            .whenIsActive {
                when(EN_Judge_LastRow) {
                    goto(IDLE)
                } otherwise {
                    goto(Start_Wait)
                }
            }

    }
}

object three2nine{
    def main(args: Array[String]): Unit = {
        SpinalVerilog(new three2nine(192,576,12,12))
    }
}
