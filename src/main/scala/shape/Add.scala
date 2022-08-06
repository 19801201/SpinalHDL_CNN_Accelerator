package shape

import spinal.core._
import spinal.lib._
import wa.WaCounter
import wa.xip.math.{AddSub, AddSubConfig, Mul, MulConfig}

case class AddConfig(DATA_WIDTH: Int, COMPUTE_CHANNEL_NUM: Int, FEATURE: Int, CHANNEL_WIDTH: Int, MEM_DEPTH: Int) {
    val STREAM_DATA_WIDTH = DATA_WIDTH * COMPUTE_CHANNEL_NUM
    val FEATURE_WIDTH = log2Up(FEATURE)
    val channelMemDepth = 512 / COMPUTE_CHANNEL_NUM //最多支持512通道
}

object AddMachineEnum extends SpinalEnum(defaultEncoding = binaryOneHot) {
    val IDLE, INIT, FIFO_READY, DATA_READY, COMPUTE, LAST = newElement
}

case class AddStateMachine(start: Bool) extends Area {

    val initEnd = Bool()
    val fifoReady = Bool() //输出fifo可以存储一行数
    val dataReady = Bool()
    val computeEnd = Bool()
    val last = Bool() //整幅图片计算结束

    val currentState = Reg(AddMachineEnum()) init AddMachineEnum.IDLE
    val nextState = AddMachineEnum()
    currentState := nextState

    switch(currentState) {
        is(AddMachineEnum.IDLE) {
            when(start) {
                nextState := AddMachineEnum.INIT
            } otherwise {
                nextState := AddMachineEnum.IDLE
            }
        }
        is(AddMachineEnum.INIT) {
            when(initEnd) {
                nextState := AddMachineEnum.FIFO_READY
            } otherwise {
                nextState := AddMachineEnum.INIT
            }
        }
        is(AddMachineEnum.FIFO_READY) {
            when(fifoReady) {
                nextState := AddMachineEnum.DATA_READY
            } otherwise {
                nextState := AddMachineEnum.FIFO_READY
            }
        }
        is(AddMachineEnum.DATA_READY) {
            when(dataReady) {
                nextState := AddMachineEnum.COMPUTE
            } otherwise {
                nextState := AddMachineEnum.DATA_READY
            }
        }
        is(AddMachineEnum.COMPUTE) {
            when(computeEnd) {
                nextState := AddMachineEnum.LAST
            } otherwise {
                nextState := AddMachineEnum.COMPUTE
            }
        }
        is(AddMachineEnum.LAST) {
            when(last) {
                nextState := AddMachineEnum.IDLE
            } otherwise {
                nextState := AddMachineEnum.FIFO_READY
            }
        }
    }
}

class Add(addConfig: AddConfig) extends Component {
    val dataPort = ShapePort(addConfig.STREAM_DATA_WIDTH, addConfig.FEATURE_WIDTH, addConfig.CHANNEL_WIDTH)
    noIoPrefix()
    val zero = in UInt (32 bits)
    val zero1 = in UInt (32 bits)
    val scale = in UInt (32 bits)
    val scale1 = in UInt (32 bits)

    val sData1 = slave Stream UInt(addConfig.STREAM_DATA_WIDTH bits)
    val channelIn1 = in UInt (addConfig.CHANNEL_WIDTH bits)

    val fsm = AddStateMachine(dataPort.start)

    fsm.fifoReady := dataPort.fifoReady
    val initCount = WaCounter(fsm.currentState === AddMachineEnum.INIT, 3, 5)
    fsm.initEnd := initCount.valid

    val mem1 = StreamFifo(UInt(addConfig.STREAM_DATA_WIDTH bits), addConfig.MEM_DEPTH)
    val mem2 = StreamFifo(UInt(addConfig.STREAM_DATA_WIDTH bits), addConfig.MEM_DEPTH)

    val channelTimes = dataPort.channelIn >> log2Up(addConfig.COMPUTE_CHANNEL_NUM)
    val cnt = RegNext(channelTimes * dataPort.colNumIn)
    val channelCnt = WaCounter(mem1.io.pop.fire, addConfig.CHANNEL_WIDTH, channelTimes - 1)
    val columnCnt = WaCounter(channelCnt.valid && mem1.io.pop.fire, addConfig.FEATURE_WIDTH, dataPort.colNumIn - 1)
    val rowCnt = WaCounter(fsm.currentState === AddMachineEnum.LAST, addConfig.FEATURE_WIDTH, dataPort.rowNumIn - 1)

    fsm.computeEnd := channelCnt.valid && columnCnt.valid
    fsm.last := rowCnt.valid

    mem1.io.push <> dataPort.sData
    mem2.io.push <> sData1

    when(mem1.io.occupancy >= cnt && mem2.io.occupancy >= cnt) {
        fsm.dataReady := True
    } otherwise {
        fsm.dataReady := False
    }
    when(fsm.currentState === AddMachineEnum.COMPUTE) {
        mem1.io.pop.ready := True
        mem2.io.pop.ready := True
    } otherwise {
        mem1.io.pop.ready := False
        mem2.io.pop.ready := False
    }

    val add1 = AddAdd(addConfig)
    val add2 = AddAdd(addConfig)
    add1.io.dataIn <> mem1.io.pop.payload.asSInt
    add2.io.dataIn <> mem2.io.pop.payload.asSInt
    add1.io.zero <> zero
    add2.io.zero <> zero1

    val addScale1 = AddScale(addConfig)
    val addScale2 = AddScale(addConfig)
    addScale1.io.dataIn <> add1.io.dataOut
    addScale2.io.dataIn <> add2.io.dataOut

    addScale1.io.scale <> scale
    addScale2.io.scale <> scale1

    val dataTemp = Vec(SInt(64 bits), addConfig.COMPUTE_CHANNEL_NUM)
    val add = Array.tabulate(addConfig.COMPUTE_CHANNEL_NUM)(i => {
        def gen = {
            val addZero = AddSub(64, 64, 64, AddSubConfig.signed, AddSubConfig.signed, 2, AddSubConfig.lut, this.clockDomain, AddSubConfig.add, "addAdd64_64", i == 0)
            addZero.io.A <> addScale1.io.dataOut(i)
            addZero.io.B <> addScale2.io.dataOut(i)
            addZero.io.S <> dataTemp(i)
            addZero
        }

        gen
    })

    (0 until addConfig.COMPUTE_CHANNEL_NUM).foreach(i => {
        val temp32 = Reg(SInt(32 bits))
        when(dataTemp(i)(31)) {
            temp32 := dataTemp(i)(63 downto 32) + 1
        } otherwise {
            temp32 := dataTemp(i)(63 downto 32)
        }

        val temp8 = Reg(UInt(8 bits))
        when(temp32.sign) {
            temp8 := 0
        } elsewhen (temp32 > 255) {
            temp8 := 255
        } otherwise {
            temp8 := temp32(7 downto 0).asUInt
        }
        dataPort.mData.payload.subdivideIn(addConfig.COMPUTE_CHANNEL_NUM slices)(i) := temp8
    })

    dataPort.mData.valid := Delay(mem1.io.pop.fire, 9)
}

case class AddAdd(addConfig: AddConfig) extends Component {

    val io = new Bundle {
        val dataIn = in SInt (addConfig.STREAM_DATA_WIDTH bits)
        val zero = in UInt (32 bits)
        val dataOut = out Vec(SInt(32 bits), addConfig.COMPUTE_CHANNEL_NUM)
    }
    noIoPrefix()

    val dataInTemp = io.dataIn.subdivideIn(addConfig.COMPUTE_CHANNEL_NUM slices)

    val add = Array.tabulate(addConfig.COMPUTE_CHANNEL_NUM)(i => {
        def gen = {
            val addZero = AddSub(32, 32, 32, AddSubConfig.signed, AddSubConfig.unsigned, 2, AddSubConfig.dsp, this.clockDomain, AddSubConfig.add, "addAdd", i == 0)
            addZero.io.A <> S"8'd0" @@ dataInTemp(i) @@ S"16'd0"
            addZero.io.B <> io.zero
            addZero.io.S <> io.dataOut(i)
            addZero
        }

        gen
    })

}

case class AddScale(addConfig: AddConfig) extends Component {
    val io = new Bundle {
        val dataIn = in Vec(SInt(32 bits), addConfig.COMPUTE_CHANNEL_NUM)
        val scale = in UInt (32 bits)
        val dataOut = out Vec(SInt(64 bits), addConfig.COMPUTE_CHANNEL_NUM)
    }
    noIoPrefix()
    val mulScale = Array.tabulate(addConfig.COMPUTE_CHANNEL_NUM)(i => {
        def gen = {
            val mul = Mul(32, 32, 64, MulConfig.signed, MulConfig.unsigned, 3, MulConfig.dsp, this.clockDomain, "addMul", 63, 0, i == 0)
            mul.io.A <> io.dataIn(i)
            mul.io.B <> io.scale
            mul.io.P <> io.dataOut(i)
            mul
        }

        gen
    })
}

object Add extends App {
    SpinalVerilog(new Add(AddConfig(8, 8, 416, 10, 2048)))
}

