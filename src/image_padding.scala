import spinal.core._
import spinal.lib._
import spinal.lib.fsm._

import scala.math._
import xfifo._

class image_padding(
                 DATA_WIDTH: Int,
                 ROW_COL_DATA_COUNT_WIDTH: Int,
                 FEATURE_MAP_SIZE: Int
             ) extends Component {
    val io = new Bundle {
        val Start = in Bool()
        val S_DATA = slave Stream Bits(DATA_WIDTH bits)
        val M_DATA = master Stream Bits(DATA_WIDTH bits)
        val Row_Num_After_Padding = out UInt (ROW_COL_DATA_COUNT_WIDTH bits)
        val Last = out(Reg(Bool())) init (False)

    }
    noIoPrefix()
    val in_size = UInt(ROW_COL_DATA_COUNT_WIDTH bits)
    in_size := FEATURE_MAP_SIZE
    io.Row_Num_After_Padding := RegNext(in_size + U"2'd2")
    val EN_Row0 = Bool()
    EN_Row0 := True
    val EN_Row1 = Bool()
    EN_Row1 := True
    val EN_Col0 = Bool()
    EN_Col0 := True
    val EN_Col1 = Bool()
    EN_Col1 := True
    val padding_fifo = new padding_fifo(DATA_WIDTH, DATA_WIDTH,FEATURE_MAP_SIZE,ROW_COL_DATA_COUNT_WIDTH)
    padding_fifo.io.data_in_ready <> io.S_DATA.ready
    padding_fifo.io.wr_en <> io.S_DATA.valid
    padding_fifo.io.data_in <> io.S_DATA.payload

    padding_fifo.io.m_data_count <> FEATURE_MAP_SIZE
    val padding_fsm = new StateMachine {
        val IDLE = new State() with EntryPoint
        val M_Row_Wait = new State()
        val S_Left_Padding = new State()
        val S_Row_Wait = new State()
        val M_Up_Down_Padding = new State()
        val M_Right_Padding = new State()
        val M_Row_Read = new State()
        val Judge_Row = new State()


        val EN_Row_Read = Bool()
        val Cnt_Column = Reg(UInt(ROW_COL_DATA_COUNT_WIDTH bits)) init (0)
        when(Cnt_Column === (in_size - 1)) {
            EN_Row_Read := True
        } otherwise (EN_Row_Read := False)
        when(isActive(M_Row_Read) || isActive(M_Up_Down_Padding)) {
            Cnt_Column := Cnt_Column + 1
        } otherwise {
            Cnt_Column := 0
        }
        val EN_Judge_Row = Bool()
        when(EN_Judge_Row) {
            io.Last := True
        } otherwise (io.Last := False)
        val Cnt_Row = Reg(UInt(ROW_COL_DATA_COUNT_WIDTH bits)) init (0)
        when(isEntering(Judge_Row)) {
            Cnt_Row := Cnt_Row + 1
        } elsewhen isActive(IDLE) {
            Cnt_Row := 0
        } otherwise (Cnt_Row := Cnt_Row)
        when(Cnt_Row === io.Row_Num_After_Padding) {
            EN_Judge_Row := True
        } otherwise (EN_Judge_Row := False)

        val EN_UP_DOWN_Padding = Bool()
        when(Cnt_Row === 0 || Cnt_Row === (io.Row_Num_After_Padding - 1)) {
            EN_UP_DOWN_Padding := True
        } otherwise (EN_UP_DOWN_Padding := False)
        IDLE
            .whenIsActive {
                when(io.Start) {
                    goto(M_Row_Wait)
                } otherwise goto(IDLE)
            }
        M_Row_Wait
            .whenIsActive {
                when(io.M_DATA.ready) {
                    when(EN_Row0) {
                        goto(S_Left_Padding)
                    } otherwise goto(S_Row_Wait)
                } otherwise goto(M_Row_Wait)
            }
        S_Row_Wait
            .whenIsActive {
                when(padding_fifo.io.data_out_valid) {
                    goto(M_Row_Read)
                } otherwise goto(S_Row_Wait)
            }
        M_Row_Read
            .whenIsActive {
                when(EN_Row_Read) {
                    when(!EN_Col1) {
                        goto(Judge_Row)
                    } otherwise goto(M_Right_Padding)
                } otherwise goto(M_Row_Read)
            }
        Judge_Row
            .whenIsActive {
                when(EN_Judge_Row) {
                    goto(IDLE)
                } otherwise goto(M_Row_Wait)
            }
        S_Left_Padding
            .whenIsActive {
                when(EN_UP_DOWN_Padding) {
                    goto(M_Up_Down_Padding)
                } otherwise goto(S_Row_Wait)
            }
        M_Up_Down_Padding
            .whenIsActive {
                when(EN_Row_Read) {
                    when(!EN_Col1) {
                        goto(Judge_Row)
                    } otherwise goto(M_Right_Padding)
                } otherwise goto(M_Up_Down_Padding)
            }
        M_Right_Padding
            .whenIsActive {
                goto(Judge_Row)
            }
    }
    io.M_DATA.valid setAsReg()
    io.M_DATA.payload setAsReg()
    when(padding_fsm.isActive(padding_fsm.S_Left_Padding) ||
        padding_fsm.isActive(padding_fsm.M_Up_Down_Padding) ||
        padding_fsm.isActive(padding_fsm.M_Right_Padding) ||
        padding_fsm.isActive(padding_fsm.M_Row_Read)
    ) {
        io.M_DATA.valid := True
    } otherwise (
        io.M_DATA.valid := False
        )
    when(padding_fsm.isActive(padding_fsm.S_Left_Padding) ||
        padding_fsm.isActive(padding_fsm.M_Right_Padding) ||
        padding_fsm.isActive(padding_fsm.M_Up_Down_Padding)
    ) {
        io.M_DATA.payload := 0
    } elsewhen padding_fsm.isActive(padding_fsm.M_Row_Read) {
        io.M_DATA.payload := padding_fifo.io.data_out
    } otherwise (
        io.M_DATA.payload := 0
        )
    when(padding_fsm.isActive(padding_fsm.M_Row_Read)) {
        padding_fifo.io.rd_en := True
    } otherwise (padding_fifo.io.rd_en := False)

}



object image_padding {
    def main(args: Array[String]): Unit = {
        SpinalConfig(
            defaultConfigForClockDomains = ClockDomainConfig(clockEdge = RISING, resetKind = SYNC),
            globalPrefix = "padding",
            oneFilePerComponent = true,
            headerWithDate = true

        ).generateVerilog(new image_padding(util.util.IMAGE_DATA_WIDTH, util.util.ROW_COL_DATA_COUNT_WIDTH, util.util.IMAGE_WIDTH_HIGH))
    }
}
