package shape

import spinal.core._


object State {
    val IDLE = 0
    val MAX_POOLING = 1
    val SPLIT = 2
    val UP_SAMPLING = 3
    val CONCAT = 4
    val ADD = 5
    val DECODE = 6
    val IRQ = 15
}

object Control {
    val IDLE = 0
    val MAX_POOLING = 1
    val SPLIT = 2
    val UP_SAMPLING = 3
    val CONCAT = 4
    val ADD = 5
    val DECODE = 6
    val IRQ = 15
}


object ShapeStateEnum extends SpinalEnum(defaultEncoding = binaryOneHot) {
    val IDLE, MAX_POOLING, SPLIT, UP_SAMPLING, CONCAT, ADD, DECODE, IRQ = newElement
}

case class ShapeStateFsm(control: Bits, complete: Bool, finish: Bool) extends Area {
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
                is(Control.ADD) {
                    nextState := ShapeStateEnum.ADD
                }
                is(Control.DECODE){
                    nextState := ShapeStateEnum.DECODE
                }
                default {
                    nextState := ShapeStateEnum.IDLE
                }
            }
        }
        is(ShapeStateEnum.MAX_POOLING) {
            when(complete) {
                nextState := ShapeStateEnum.IRQ
            } otherwise {
                nextState := ShapeStateEnum.MAX_POOLING
            }
        }
        is(ShapeStateEnum.SPLIT) {
            when(complete) {
                nextState := ShapeStateEnum.IRQ
            } otherwise {
                nextState := ShapeStateEnum.SPLIT
            }
        }
        is(ShapeStateEnum.UP_SAMPLING) {
            when(complete) {
                nextState := ShapeStateEnum.IRQ
            } otherwise {
                nextState := ShapeStateEnum.UP_SAMPLING
            }
        }
        is(ShapeStateEnum.CONCAT) {
            when(complete) {
                nextState := ShapeStateEnum.IRQ
            } otherwise {
                nextState := ShapeStateEnum.CONCAT
            }
        }
        is(ShapeStateEnum.ADD) {
            when(complete) {
                nextState := ShapeStateEnum.IRQ
            } otherwise {
                nextState := ShapeStateEnum.ADD
            }
        }
        is(ShapeStateEnum.DECODE) {
            when(finish) {
                nextState := ShapeStateEnum.IRQ
            } otherwise {
                nextState := ShapeStateEnum.DECODE
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
    val ADD = 4
    val DECODE = 5
}

object Instruction {
    def ROW_NUM_IN = 10 downto 0

    def COL_NUM_IN = 21 downto 11

    def CHANNEL_IN = 31 downto 22

    def CHANNEL_IN1 = 41 downto 32

    def SCALE = 95 downto 64

    def SCALE1 = 127 downto 96

    def ZERO = 159 downto 128

    def ZERO1 = 191 downto 160

    val Reg0 = ("ROW_NUM_IN", ROW_NUM_IN.length, "COL_NUM_IN", COL_NUM_IN.length, "CHANNEL_IN", CHANNEL_IN.length)
    val Reg1 = ("CHANNEL_IN1", CHANNEL_IN1.length)
    val Reg2 = ("SCALE", SCALE.length)
    val Reg3 = ("SCALE1", SCALE1.length)
    val Reg4 = ("ZERO", ZERO.length)
    val Reg5 = ("ZERO1", ZERO1.length)
    val Reg = Seq(("Reg0", Reg0), ("Reg1", Reg1), ("Reg2", Reg2), ("Reg3", Reg3), ("Reg4", Reg4), ("Reg5", Reg5))
}

class ShapeState extends Component {
    val io = new Bundle {
        val control = in Bits (4 bits)
        val complete = in Bool()
        val state = out(Reg(Bits(4 bits)))
        val start = out(Vec(Reg(Bool()), 6))
        val dmaReadValid = out(Vec(Bool(), 2))
        val dmaWriteValid = out(Bool())

        val finish = in Bool()
    }
    noIoPrefix()

    val fsm = ShapeStateFsm(io.control, io.complete, io.finish)

    val dmaReadValid = Vec(Vec(Reg(Bool()) init False, 2), 6)
    val dmaWriteValid = Vec(Reg(Bool()) init False, 6)

    //    io.dmaReadValid := Vec(dmaReadValid.foreach(i=>i(0)))
    io.dmaReadValid(0) := dmaReadValid(0)(0) ^ dmaReadValid(1)(0) ^ dmaReadValid(2)(0) ^ dmaReadValid(3)(0) ^ dmaReadValid(4)(0) ^ dmaReadValid(5)(0)
    io.dmaReadValid(1) := dmaReadValid(0)(1) ^ dmaReadValid(1)(1) ^ dmaReadValid(2)(1) ^ dmaReadValid(3)(1) ^ dmaReadValid(4)(1) ^ dmaReadValid(5)(1)
    io.dmaWriteValid := dmaWriteValid(0) ^ dmaWriteValid(1) ^ dmaWriteValid(2) ^ dmaWriteValid(3) ^ dmaWriteValid(4)

    def setStart(en: Bool, index: Int, isConcat: Boolean = false): Unit = {
        when(en) {
            io.start(index) := True
            if (isConcat) {
                dmaReadValid(index) := Vec(True, True)
            } else {
                dmaReadValid(index) := Vec(True, False)
            }
            dmaWriteValid(index) := True

        } otherwise {
            io.start(index) := False
            dmaReadValid(index).map(_ := False)
            dmaWriteValid(index) := False
        }
    }

    setStart(fsm.currentState === ShapeStateEnum.IDLE && fsm.nextState === ShapeStateEnum.MAX_POOLING, Start.MAX_POOLING)
    setStart(fsm.currentState === ShapeStateEnum.IDLE && fsm.nextState === ShapeStateEnum.UP_SAMPLING, Start.UP_SAMPLING)
    setStart(fsm.currentState === ShapeStateEnum.IDLE && fsm.nextState === ShapeStateEnum.SPLIT, Start.SPLIT)
    setStart(fsm.currentState === ShapeStateEnum.IDLE && fsm.nextState === ShapeStateEnum.CONCAT, Start.CONCAT, true)
    setStart(fsm.currentState === ShapeStateEnum.IDLE && fsm.nextState === ShapeStateEnum.ADD, Start.ADD, true)
    setStart(fsm.currentState === ShapeStateEnum.IDLE && fsm.nextState === ShapeStateEnum.DECODE, Start.DECODE)
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
        is(ShapeStateEnum.ADD) {
            io.state := State.ADD
        }
        is(ShapeStateEnum.DECODE) {
            io.state := State.DECODE
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
