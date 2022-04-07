package shape

import spinal.core._


object State {
    val IDLE = 0
    val MAX_POOLING = 1
    val SPLIT = 2
    val UP_SAMPLING = 3
    val CONCAT = 4
    val IRQ = 15
}

object Control {
    val IDLE = 0
    val MAX_POOLING = 1
    val SPLIT = 2
    val UP_SAMPLING = 3
    val CONCAT = 4
    val IRQ = 15
}

object Complete {
    val IDLE = 0
    val MAX_POOLING = 1
    val SPLIT = 2
    val UP_SAMPLING = 3
    val CONCAT = 4
}

object ShapeStateEnum extends SpinalEnum(defaultEncoding = binaryOneHot) {
    val IDLE, MAX_POOLING, SPLIT, UP_SAMPLING, CONCAT, IRQ = newElement
}

case class ShapeStateFsm(control: Bits, complete: Bits) extends Area {
    val currentState = Reg(ShapeStateEnum()) init ShapeStateEnum.IDLE
    val nextState = ShapeStateEnum()
    currentState := nextState
    switch(currentState) {
        is(ShapeStateEnum.IDLE) {
            switch(control) {
                is(Control.MAX_POOLING) {
                    nextState := ShapeStateEnum.MAX_POOLING
                }
                is(Control.SPLIT) {
                    nextState := ShapeStateEnum.SPLIT
                }
                is(Control.UP_SAMPLING) {
                    nextState := ShapeStateEnum.UP_SAMPLING
                }
                is(Control.CONCAT) {
                    nextState := ShapeStateEnum.CONCAT
                }
                default {
                    nextState := ShapeStateEnum.IDLE
                }
            }
        }
        is(ShapeStateEnum.MAX_POOLING) {
            when(complete === Complete.MAX_POOLING) {
                nextState := ShapeStateEnum.IRQ
            } otherwise {
                nextState := ShapeStateEnum.MAX_POOLING
            }
        }
        is(ShapeStateEnum.SPLIT) {
            when(complete === Complete.SPLIT) {
                nextState := ShapeStateEnum.IRQ
            } otherwise {
                nextState := ShapeStateEnum.SPLIT
            }
        }
        is(ShapeStateEnum.UP_SAMPLING) {
            when(complete === Complete.UP_SAMPLING) {
                nextState := ShapeStateEnum.IRQ
            } otherwise {
                nextState := ShapeStateEnum.UP_SAMPLING
            }
        }
        is(ShapeStateEnum.CONCAT) {
            when(complete === Complete.CONCAT) {
                nextState := ShapeStateEnum.IRQ
            } otherwise {
                nextState := ShapeStateEnum.CONCAT
            }
        }
        is(ShapeStateEnum.IRQ) {
            when(control === Control.IRQ) {
                nextState := ShapeStateEnum.IDLE
            } otherwise {
                nextState := ShapeStateEnum.IRQ
            }
        }
    }
}

object Start {
    val MAX_POOLING = 0
    val SPLIT = 1
    val UP_SAMPLING = 2
    val CONCAT = 3
}

class ShapeState extends Component {
    val io = new Bundle {
        val control = in Bits (4 bits)
        val complete = in Bits (4 bits)
        val state = out(Reg(Bits(4 bits)))
        val start = out(Vec(Reg(Bool()) init False, 4))
        val dmaReadValid = out Vec(Bool(), 2)
        val dmaWriteValid = out Bool()
    }
    noIoPrefix()

    val fsm = ShapeStateFsm(io.control, io.complete)

    def setStart(en: Bool, index: Int, isConcat: Boolean = false): Unit = {
        when(en) {
            io.start(index) := True
            if (isConcat) {
                io.dmaReadValid := Vec(True, True)
            } else {
                io.dmaReadValid := Vec(True, False)
            }
            io.dmaWriteValid := True

        } otherwise {
            io.start(index) := False
            io.dmaReadValid.foreach(_ := False)
            io.dmaWriteValid := False
        }
    }

    setStart(fsm.currentState === ShapeStateEnum.IDLE && fsm.nextState === ShapeStateEnum.MAX_POOLING, Start.MAX_POOLING)
    setStart(fsm.currentState === ShapeStateEnum.IDLE && fsm.nextState === ShapeStateEnum.UP_SAMPLING, Start.UP_SAMPLING)
    setStart(fsm.currentState === ShapeStateEnum.IDLE && fsm.nextState === ShapeStateEnum.SPLIT, Start.SPLIT)
    setStart(fsm.currentState === ShapeStateEnum.IDLE && fsm.nextState === ShapeStateEnum.CONCAT, Start.CONCAT, true)

    switch(fsm.currentState) {
        is(ShapeStateEnum.CONCAT) {
            io.state := State.CONCAT
        }
        is(ShapeStateEnum.MAX_POOLING) {
            io.state := State.MAX_POOLING
        }
        is(ShapeStateEnum.UP_SAMPLING) {
            io.state := State.UP_SAMPLING
        }
        is(ShapeStateEnum.SPLIT) {
            io.state := State.SPLIT
        }
        is(ShapeStateEnum.IRQ) {
            io.state := State.IRQ
        }
        default {
            io.state := State.IDLE
        }
    }

}

object ShapeState extends App {
    SpinalVerilog(new ShapeState)
}
