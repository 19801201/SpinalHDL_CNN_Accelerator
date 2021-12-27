import spinal.core._
import spinal.lib.Delay
import spinal.lib.fsm._

class image_compute_ctrl(
                            ROW_COL_DATA_COUNT_WIDTH: Int,
                            FEATURE_MAP_SIZE: Int
                        ) extends Component {

    val io = new Bundle {
        val Start = in Bool()
        val compute_fifo_ready = in Bool()
        val M_Ready = in Bool()
        val Compute_Complete = out Bool() setAsReg() init False
        val Conv_Complete = out Bool()
        val rd_en_fifo = out Bool() setAsReg() init False
        val M_Valid = out Bool()
        val weight_select = out Bits (3 bits) setAsReg() init 0
    }
    noIoPrefix()


    val image_cmp_ctrl_fsm = new StateMachine {
        val IDLE = new State() with EntryPoint
        val Judge_Before_Fifo = new State()
        val Judge_After_Fifo = new State()
        //        val Load_Weight = new State()
        val Compute = new State()
        val Judge_Row = new State()

        val En_Compute_Column = Bool()
        val COMPUTE_TIMES_CHANNEL_OUT_REG = U"3'b100"
        val Cnt_Channel_Out_Num = UInt(3 bits) setAsReg() init 0
        val Cnt_Column = UInt(ROW_COL_DATA_COUNT_WIDTH bits) setAsReg() init 0
        when(isActive(Compute)) {
            when(Cnt_Channel_Out_Num === COMPUTE_TIMES_CHANNEL_OUT_REG - 1) {
                Cnt_Channel_Out_Num := 0
            } otherwise {
                Cnt_Channel_Out_Num := Cnt_Channel_Out_Num + 1
            }
        } otherwise {
            Cnt_Channel_Out_Num := 0
        }
        when(isActive(Compute)) {
            when(Cnt_Channel_Out_Num === COMPUTE_TIMES_CHANNEL_OUT_REG - 1) {
                io.rd_en_fifo := True
                Cnt_Column := Cnt_Column + 1
            } otherwise {
                io.rd_en_fifo := False
                Cnt_Column := Cnt_Column
            }
        } otherwise {
            io.rd_en_fifo := False
            Cnt_Column:=0
        }
        when((Cnt_Channel_Out_Num === COMPUTE_TIMES_CHANNEL_OUT_REG - 1) && (Cnt_Column === FEATURE_MAP_SIZE - 3)) {
            En_Compute_Column := True
        } otherwise {
            En_Compute_Column := False
        }

        val En_Compute_Row = Bool() setAsReg() init False
        val Cnt_Row = UInt(ROW_COL_DATA_COUNT_WIDTH bits) setAsReg() init 0
        when(isEntering(Judge_Row)) {
            Cnt_Row := Cnt_Row + 1
        } elsewhen isActive(IDLE) {
            Cnt_Row := 0
        } otherwise {
            Cnt_Row := Cnt_Row
        }
        when(Cnt_Row === FEATURE_MAP_SIZE - 3&&En_Compute_Column) {
            En_Compute_Row := True
        } otherwise {
            En_Compute_Row := False
        }

        when(isEntering(IDLE)) {
            io.Compute_Complete := True
        } otherwise {
            io.Compute_Complete := False
        }

        val M_Fifo_Valid = Bool() setAsReg() init False
        when(isActive(Compute)){
            M_Fifo_Valid:= True
        } otherwise{
            M_Fifo_Valid := False
        }
//        io.M_Valid := Delay(io.rd_en_fifo,13)
        io.M_Valid := Delay(M_Fifo_Valid,13)
        io.Conv_Complete := Delay(En_Compute_Row, 14)
        //val weight = Bits (3 bits) setAsReg() init 0
       // io.weight_select := Delay(weight,3)
        switch(Cnt_Channel_Out_Num){
            is(0){
                io.weight_select := 1
            }
            is(1){
                io.weight_select := 2
            }
            is(2){
                io.weight_select := 3
            }
            is(3){
                io.weight_select := 4
            }
            default{
                io.weight_select := 0
            }
        }
        IDLE
            .whenIsActive {
                when(io.Start) {
                    goto(Judge_Before_Fifo)
                } otherwise goto(IDLE)
            }
        Judge_Before_Fifo
            .whenIsActive {
                when(io.compute_fifo_ready) {
                    goto(Judge_After_Fifo)
                } otherwise goto(Judge_Before_Fifo)
            }
        Judge_After_Fifo
            .whenIsActive {
                when(io.M_Ready) {
                    goto(Compute)
                } otherwise goto(Judge_After_Fifo)
            }
        Compute
            .whenIsActive {
                when(En_Compute_Column) {
                    goto(Judge_Row)
                } otherwise goto(Compute)
            }
        Judge_Row
            .whenIsActive {
                when(En_Compute_Row) {
                    goto(IDLE)
                } otherwise goto(Judge_Before_Fifo)
            }

    }

}
