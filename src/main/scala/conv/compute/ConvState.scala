package conv.compute

import spinal.core._
import spinal.lib.Delay

object ConvStateEnum extends SpinalEnum(defaultEncoding = binaryOneHot) {
    val IDLE, PARA, PARA_IRQ, COMPUTE, COMPUTE_IRQ = newElement
}

object CONV_STATE extends Area {
    val START_PA = 1
    val START_CU = 2
    val END_IRQ = 15

    val END_PA = 1
    val END_CU = 2

    val IDLE_STATE = 0
    val PARA_STATE = 1
    val COMPUTE_STATE = 2
    val IRQ_STATE = 15

    val PARA_SIGN = 1
    val COMPUTE_SIGN = 2
    val IDLE_SIGN = 0

    val CONV33 = 0
    val CONV11_8X = 1
    val CONV11 = 2

    def ROW_NUM_IN = 10 downto 0

    def COL_NUM_IN = 21 downto 11

    def CHANNEL_IN = 31 downto 22

    def CHANNEL_OUT = 41 downto 32

    def EN_PADDING = 42 downto 42

    def EN_ACTIVATION = 43 downto 43

    def Z1 = 51 downto 44

    def Z1_NUM = 54 downto 52

    def Z3 = 62 downto 55

    def EN_STRIDE = 63 downto 63

    def CONV_TYPE = 65 downto 64

    def FIRST_LAYER = 66 downto 66

    def EN_FOCUS = 67 downto 67

    def WEIGHT_NUM = 111 downto 96

    def QUAN_NUM = 127 downto 112

    def AMEND = 159 downto 128

    val Reg0 = ("ROW_NUM_IN", ROW_NUM_IN.length, "COL_NUM_IN", COL_NUM_IN.length, "CHANNEL_IN", CHANNEL_IN.length)
    val Reg1 = ("CHANNEL_OUT", CHANNEL_OUT.length, "EN_PADDING", EN_PADDING.length, "EN_ACTIVATION", EN_ACTIVATION.length, "Z1", Z1.length, "Z1_NUM", Z1_NUM.length, "Z3", Z3.length, "EN_STRIDE", EN_STRIDE.length)
    val Reg2 = ("CONV_TYPE", CONV_TYPE.length, "FIRST_LAYER", FIRST_LAYER.length, "EN_FOCUS", EN_FOCUS.length)
    val Reg3 = ("WEIGHT_NUM", WEIGHT_NUM.length, "QUAN_NUM", QUAN_NUM.length)
    val Reg4 = ("AMEND", AMEND.length)
    val Reg = Seq(("Reg0", Reg0), ("Reg1", Reg1), ("Reg2", Reg2), ("Reg3", Reg3), ("Reg4", Reg4))

}

case class ConvStateFsm(control: Bits, complete: Bits) extends Area {

    //    val control = Bits(4 bits)
    //    val complete = Bits(4 bits)

    val currentState = Reg(ConvStateEnum()) init ConvStateEnum.IDLE
    val nextState = ConvStateEnum()
    currentState := nextState
    switch(currentState) {
        is(ConvStateEnum.IDLE) {
            when(control === CONV_STATE.START_PA) {
                nextState := ConvStateEnum.PARA
            } elsewhen (control === CONV_STATE.START_CU) {
                nextState := ConvStateEnum.COMPUTE
            } otherwise {
                nextState := ConvStateEnum.IDLE
            }
        }
        is(ConvStateEnum.PARA) {
            when(complete === CONV_STATE.END_PA) {
                nextState := ConvStateEnum.PARA_IRQ
            } otherwise {
                nextState := ConvStateEnum.PARA
            }
        }
        is(ConvStateEnum.PARA_IRQ) {
            when(control === CONV_STATE.END_IRQ) {
                nextState := ConvStateEnum.IDLE
            } otherwise {
                nextState := ConvStateEnum.PARA_IRQ
            }
        }
        is(ConvStateEnum.COMPUTE) {
            when(complete === CONV_STATE.END_CU) {
                nextState := ConvStateEnum.COMPUTE_IRQ
            } otherwise {
                nextState := ConvStateEnum.COMPUTE
            }
        }
        is(ConvStateEnum.COMPUTE_IRQ) {
            when(control === CONV_STATE.END_IRQ) {
                nextState := ConvStateEnum.IDLE
            } otherwise {
                nextState := ConvStateEnum.COMPUTE_IRQ
            }
        }

    }
}

case class ConvState(convConfig: ConvConfig) extends Component {
    val io = new Bundle {
        val control = in Bits (4 bits)
        val complete = in Bits (4 bits)
        val state = out(Reg(Bits(4 bits)) init(0))
        val sign = out(Reg(Bits(4 bits)) init(0))
        val dmaReadValid = out(Reg(Bool()) init False)
        val dmaWriteValid = out(Reg(Bool()) init False)
        val softReset = out Bool()
    }
    noIoPrefix()
    val fsm = ConvStateFsm(io.control, io.complete)
    switch(fsm.currentState) {
        is(ConvStateEnum.IDLE) {
            io.state := CONV_STATE.IDLE_STATE
        }
        is(ConvStateEnum.PARA) {
            io.state := CONV_STATE.PARA_STATE
        }
        is(ConvStateEnum.COMPUTE) {
            io.state := CONV_STATE.COMPUTE_STATE
        }
        is(ConvStateEnum.COMPUTE_IRQ) {
            io.state := CONV_STATE.IRQ_STATE
        }
        is(ConvStateEnum.PARA_IRQ) {
            io.state := CONV_STATE.IRQ_STATE
        }
        //        default {
        //            io.state := CONV_STATE.IDLE_STATE
        //        }
    }

    val dmaReadValid = Reg(Bool()) init False
    val dmaWriteValid = Reg(Bool()) init False
    io.dmaWriteValid := Delay(dmaWriteValid, 4, init = False)
    io.dmaReadValid := Delay(dmaReadValid, 4, init = False)
    when(fsm.currentState === ConvStateEnum.IDLE && fsm.nextState === ConvStateEnum.PARA) {
        io.sign := CONV_STATE.PARA_SIGN
        dmaReadValid.set()
        dmaWriteValid.clear()
    } elsewhen (fsm.currentState === ConvStateEnum.IDLE && fsm.nextState === ConvStateEnum.COMPUTE) {
        io.sign := CONV_STATE.COMPUTE_SIGN
        dmaWriteValid.set()
        dmaReadValid.set()
    } otherwise {
        io.sign := CONV_STATE.IDLE_SIGN
        dmaReadValid.clear()
        dmaWriteValid.clear()
    }

    when(fsm.currentState === ConvStateEnum.COMPUTE_IRQ && fsm.nextState === ConvStateEnum.IDLE) {
        io.softReset := True
    } otherwise {
        io.softReset := False
    }


}
