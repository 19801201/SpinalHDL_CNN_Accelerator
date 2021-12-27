import spinal.core._
import spinal.lib._
import spinal.lib.fsm._

class image_three2nine(
                    S_DATA_WIDTH: Int,
                    ROW_COL_DATA_COUNT_WIDTH: Int
                ) extends Component {
    val io = new Bundle {
        val Start = in Bool()
        val S_DATA = in Bits (S_DATA_WIDTH bits)
        val S_DATA_Valid = in Bool()
        val S_DATA_Ready = out Bool()
        val S_DATA_Addr = out UInt (ROW_COL_DATA_COUNT_WIDTH bits) setAsReg() init 0
        val Row_Num_After_Padding = in UInt (ROW_COL_DATA_COUNT_WIDTH bits)
        val Row_Compute_Sign = in Bool()
        val M_Data = out Bits (S_DATA_WIDTH * 3 bits)
        val M_Ready = in Bool()
        val M_Valid = out Bits (9 bits) setAsReg() init 0
        val S_Ready = out Bool()
    }

    noIoPrefix()

    val three2nine_fsm = new StateMachine {
        val IDLE = new State() with EntryPoint
        val Start_Wait = new State()
        val Judge_FIFO = new State()
        val ComputeRow_Read = new State()
        val Judge_LastRow = new State()


        val EN_ComputeRow_Read = Bool()
        val Cnt_COl = UInt(ROW_COL_DATA_COUNT_WIDTH bits) setAsReg() init 0
        when(isActive(ComputeRow_Read)) {
            Cnt_COl := Cnt_COl + 1
        }otherwise (Cnt_COl := 0)
//        } elsewhen isActive(ComputeRow_Read) {
//            Cnt_COl := Cnt_COl
//        }

        when(Cnt_COl === io.Row_Num_After_Padding - 1) {
            EN_ComputeRow_Read := True
        } otherwise (EN_ComputeRow_Read := False)

        val EN_Judge_LastRow = Bool()
        val Cnt_Row = UInt(ROW_COL_DATA_COUNT_WIDTH bits) setAsReg() init 0
        when(isEntering(Judge_LastRow)) {
            Cnt_Row := Cnt_Row + 1
        } elsewhen (isActive(IDLE)) {
            Cnt_Row := 0
        } otherwise (
            Cnt_Row := Cnt_Row
            )
        when(Cnt_Row === io.Row_Num_After_Padding - 2) {
            EN_Judge_LastRow := True
        } otherwise (
            EN_Judge_LastRow := False
            )

        when(isActive(ComputeRow_Read)) {
            io.S_DATA_Ready := True
        } otherwise (io.S_DATA_Ready := False)
        when(io.S_DATA_Ready) {
            io.S_DATA_Addr := io.S_DATA_Addr + 1
        } otherwise (io.S_DATA_Addr := 0)
        when(isActive(Start_Wait)) {
            io.S_Ready := True
        } otherwise (io.S_Ready := False)
        for (i <- 0 to 2){
            io.M_Data(3*(i+1)*8 - 1 downto (3*i*8)) := io.S_DATA((i+1)*8-1 downto (i*8)) ## io.S_DATA((i+1)*8-1 downto (i*8)) ## io.S_DATA((i+1)*8-1 downto (i*8))
        }
        when(isActive(ComputeRow_Read)){

            when(Cnt_COl < io.Row_Num_After_Padding -2){
                io.M_Valid(0) := True
                io.M_Valid(3) := True
                io.M_Valid(6) := True
            } otherwise{
                io.M_Valid(0) := False
                io.M_Valid(3) := False
                io.M_Valid(6) := False
            }
            when(Cnt_COl>0 && Cnt_COl < io.Row_Num_After_Padding -1){
                io.M_Valid(1) := True
                io.M_Valid(4) := True
                io.M_Valid(7) := True
            } otherwise{
                io.M_Valid(1) := False
                io.M_Valid(4) := False
                io.M_Valid(7) := False
            }
            when(Cnt_COl >1 && Cnt_COl < io.Row_Num_After_Padding){
                io.M_Valid(2) := True
                io.M_Valid(5) := True
                io.M_Valid(8) := True
            } otherwise{
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
                when(EN_ComputeRow_Read) {
                    goto(Judge_LastRow)
                } otherwise goto(ComputeRow_Read)
            }
        Judge_LastRow
            .whenIsActive {
                when(EN_Judge_LastRow) {
                    goto(IDLE)
                } otherwise (goto(Start_Wait))
            }
    }
}

object image_three2nine {
    def main(args: Array[String]): Unit = {
SpinalVerilog(new image_three2nine(24,12))
    }
}
