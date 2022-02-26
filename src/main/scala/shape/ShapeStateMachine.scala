package shape

import spinal.core._

object ShapeStateMachineEnum extends SpinalEnum(defaultEncoding = binaryOneHot) {
    val IDLE, INIT, FIFO_READY, COMPUTE, LAST = newElement
}

case class ShapeStateMachine(start: Bool) extends Area {

    val initEnd = Bool()
    val fifoReady = Bool() //输出fifo可以存储一行数
    val computeEnd = Bool()
    val last = Bool() //整幅图片计算结束

    val currentState = Reg(ShapeStateMachineEnum()) init ShapeStateMachineEnum.IDLE
    val nextState = ShapeStateMachineEnum()
    currentState := nextState
    switch(currentState) {
        is(ShapeStateMachineEnum.IDLE) {
            when(start) {
                nextState := ShapeStateMachineEnum.INIT
            } otherwise {
                nextState := ShapeStateMachineEnum.IDLE
            }
        }

        is(ShapeStateMachineEnum.INIT) {
            when(initEnd) {
                nextState := ShapeStateMachineEnum.FIFO_READY
            } otherwise {
                nextState := ShapeStateMachineEnum.INIT
            }
        }
        is(ShapeStateMachineEnum.FIFO_READY) {
            when(fifoReady) {
                nextState := ShapeStateMachineEnum.COMPUTE
            } otherwise {
                nextState := ShapeStateMachineEnum.FIFO_READY
            }
        }
        is(ShapeStateMachineEnum.COMPUTE) {
            when(computeEnd) {
                nextState := ShapeStateMachineEnum.LAST
            } otherwise {
                nextState := ShapeStateMachineEnum.COMPUTE
            }
        }
        is(ShapeStateMachineEnum.LAST) {
            when(last) {
                nextState := ShapeStateMachineEnum.IDLE
            } otherwise {
                nextState := ShapeStateMachineEnum.FIFO_READY
            }
        }
    }
}
