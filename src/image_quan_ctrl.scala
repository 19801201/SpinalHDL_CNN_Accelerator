import spinal.core._
import spinal.lib.Delay
import spinal.lib.fsm._

class image_quan_ctrl(
                         ROW_COL_DATA_COUNT_WIDTH: Int,
                         CHANNEL_OUT_TIMES: Int,
                         FEATURE_MAP_SIZE: Int
                     ) extends Component {
    val io = new Bundle {
        val fifo_valid = in Bool()
        val M_Ready = in Bool()
        val rd_en_fifo = out Bool()
        val para_select = out Bits (CHANNEL_OUT_TIMES bits) setAsReg() init 0
        val M_Valid = out Bool()
    }
    noIoPrefix()

    val image_quan_fsm = new StateMachine {
        val IDLE = new State() with EntryPoint
        val After_Fifo = new State()
        val Compute = new State()


        val Cnt_Cout = UInt(CHANNEL_OUT_TIMES bits) setAsReg() init 0
        val En_Last_Cout = Bool()
        when(Cnt_Cout === CHANNEL_OUT_TIMES - 1) {
            En_Last_Cout := True
        } otherwise {
            En_Last_Cout := False
        }
        when(isActive(Compute)) {
            when(Cnt_Cout === CHANNEL_OUT_TIMES - 1) {
                Cnt_Cout := 0
            } otherwise {
                Cnt_Cout := Cnt_Cout + 1
            }
        } otherwise {
            Cnt_Cout := 0
        }
        val Cnt_Column = UInt(ROW_COL_DATA_COUNT_WIDTH bits) setAsReg() init 0
        val En_Last_Column = Bool()
        when(isActive(Compute)) {
            when(En_Last_Cout) {
                Cnt_Column := Cnt_Column + 1
            } otherwise {
                Cnt_Column := Cnt_Column
            }
        } otherwise {
            Cnt_Column := 0
        }
        //以后要把FEATURE_MAP_SIZE放到io端口的寄存器里
        when(Cnt_Column === FEATURE_MAP_SIZE - 1 && En_Last_Cout) {
            En_Last_Column := True
        } otherwise {
            En_Last_Column := False
        }
        IDLE
            .whenIsActive {
                when(io.fifo_valid) {
                    goto(After_Fifo)
                } otherwise goto(IDLE)
            }
        After_Fifo
            .whenIsActive {
                when(io.M_Ready) {
                    goto(Compute)
                } otherwise goto(After_Fifo)
            }
        Compute
            .whenIsActive {
                when(En_Last_Column) {
                    goto(IDLE)
                } otherwise goto(Compute)
            }


        switch(Cnt_Cout) {
            is(0) {
                io.para_select := 1
            }
            is(1) {
                io.para_select := 2
            }
            is(2) {
                io.para_select := 3
            }
            is(3) {
                io.para_select := 4
            }
            default {
                io.para_select := 0
            }
        }

        val M_Valid_Temp = Bool()
        when(isActive(Compute)) {
            M_Valid_Temp := True
            io.rd_en_fifo := True
        } otherwise {
            M_Valid_Temp := False
            io.rd_en_fifo := False
        }
        //待定
        io.M_Valid := Delay(M_Valid_Temp, 21)

    }
}

