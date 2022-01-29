package conv.compute

import spinal.core._

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
        val state = out(Reg(Bits(4 bits)))
        val sign = out(Reg(Bits(4 bits)))
        val dmaReadValid = out Bool()
        val dmaWriteValid = out Bool()
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

    when(fsm.currentState === ConvStateEnum.IDLE && fsm.nextState === ConvStateEnum.PARA) {
        io.sign := CONV_STATE.PARA_SIGN
        io.dmaReadValid.set()
        io.dmaWriteValid.clear()
    } elsewhen (fsm.currentState === ConvStateEnum.IDLE && fsm.nextState === ConvStateEnum.COMPUTE) {
        io.sign := CONV_STATE.COMPUTE_SIGN
        io.dmaWriteValid.set()
        io.dmaReadValid.set()
    } otherwise {
        io.sign := CONV_STATE.IDLE_SIGN
        io.dmaReadValid.clear()
        io.dmaWriteValid.clear()
    }


}
