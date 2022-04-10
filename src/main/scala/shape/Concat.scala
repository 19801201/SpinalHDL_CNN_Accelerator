package shape


import spinal.core._
import spinal.lib._
import wa.WaCounter
import wa.xip.math.{AddSub, AddSubConfig, Mul, MulConfig}

case class ConcatConfig(DATA_WIDTH: Int, COMPUTE_CHANNEL_NUM: Int, FEATURE: Int, CHANNEL_WIDTH: Int) {
    val STREAM_DATA_WIDTH = DATA_WIDTH * COMPUTE_CHANNEL_NUM
    val FEATURE_WIDTH = log2Up(FEATURE)
    val channelMemDepth = 512 / COMPUTE_CHANNEL_NUM //最多支持512通道
}

class Concat(concatConfig: ConcatConfig) extends Component {

    val dataPort = ShapePort(concatConfig.STREAM_DATA_WIDTH, concatConfig.FEATURE_WIDTH, concatConfig.CHANNEL_WIDTH)
    noIoPrefix()
    val zero = in UInt (32 bits)
    val zero1 = in UInt (32 bits)
    val scale = in UInt (32 bits)
    val scale1 = in UInt (32 bits)

    val sData1 = slave Stream UInt(concatConfig.STREAM_DATA_WIDTH bits)
    val channelIn1 = in UInt (concatConfig.CHANNEL_WIDTH bits)
    val fsm = ShapeStateMachine(dataPort.start)

    val channelTimes0 = dataPort.channelIn >> log2Up(concatConfig.COMPUTE_CHANNEL_NUM)
    val channelTimes1 = channelIn1 >> log2Up(concatConfig.COMPUTE_CHANNEL_NUM)

    val channelTimes = RegNext(channelTimes0 + channelTimes1)

    val channelCnt = WaCounter(dataPort.sData.fire && (fsm.currentState === ShapeStateMachineEnum.COMPUTE), channelTimes.getWidth, channelTimes - 1)
    val columnCnt = WaCounter(channelCnt.valid, concatConfig.FEATURE_WIDTH, dataPort.colNumIn - 1)
    val rowCnt = WaCounter(fsm.currentState === ShapeStateMachineEnum.LAST, concatConfig.FEATURE_WIDTH, dataPort.rowNumIn - 1)

    val initCount = WaCounter(fsm.currentState === ShapeStateMachineEnum.INIT, 3, 5)
    fsm.initEnd := initCount.valid
    fsm.fifoReady := dataPort.fifoReady
    fsm.computeEnd := channelCnt.valid && columnCnt.valid
    fsm.last := rowCnt.valid

    when(fsm.currentState === ShapeStateMachineEnum.COMPUTE && dataPort.mData.ready) {
        when(channelCnt.count < channelTimes0) {
            dataPort.sData.ready := True
            sData1.ready := False
        } otherwise {
            sData1.ready := True
            dataPort.sData.ready := False
        }
    } otherwise {
        dataPort.sData.ready := False
        sData1.ready := False
    }

    val concatZero = ConcatZero(concatConfig)
    val concatScale = ConcatScale(concatConfig)
    val scaleTemp = UInt(32 bits)
    when(dataPort.sData.fire) {
        concatZero.io.dataIn <> dataPort.sData.payload.asSInt
        concatZero.io.zero <> zero
        scaleTemp := scale
    } elsewhen (sData1.fire) {
        concatZero.io.dataIn <> sData1.payload.asSInt
        concatZero.io.zero <> zero1
        scaleTemp := scale1
    } otherwise {
        concatZero.io.dataIn <> 0
        concatZero.io.zero <> 0
        scaleTemp := 0
    }
    concatScale.io.dataIn <> concatZero.io.dataOut
    concatScale.io.scale := Delay(scaleTemp, 2)
    dataPort.mData.payload.subdivideIn(concatConfig.COMPUTE_CHANNEL_NUM slices) <> concatScale.io.dataOut
    dataPort.mData.valid := Delay(dataPort.sData.fire || sData1.fire, 7)
}

case class ConcatZero(concatConfig: ConcatConfig) extends Component {

    val io = new Bundle {
        val dataIn = in SInt (concatConfig.STREAM_DATA_WIDTH bits)
        val zero = in UInt (32 bits)
        val dataOut = out Vec(SInt(32 bits), concatConfig.COMPUTE_CHANNEL_NUM)
    }
    noIoPrefix()

    val dataInTemp = io.dataIn.subdivideIn(concatConfig.COMPUTE_CHANNEL_NUM slices)

    val add = Array.tabulate(concatConfig.COMPUTE_CHANNEL_NUM)(i => {
        def gen = {
            val addZero = AddSub(32, 32, 32, AddSubConfig.signed, AddSubConfig.unsigned, 2, AddSubConfig.lut, this.clockDomain, AddSubConfig.add, "concatAdd", i == 0)
            addZero.io.A <> S"8'd0" @@ dataInTemp(i) @@ S"16'd0"
            addZero.io.B <> io.zero
            addZero.io.S <> io.dataOut(i)
            addZero
        }

        gen
    })

}

case class ConcatScale(concatConfig: ConcatConfig) extends Component {
    val io = new Bundle {
        val dataIn = in Vec(SInt(32 bits), concatConfig.COMPUTE_CHANNEL_NUM)
        val scale = in UInt (32 bits)
        val dataOut = out Vec(UInt(8 bits), concatConfig.COMPUTE_CHANNEL_NUM)
    }
    noIoPrefix()

    val mulDataOut = Vec(SInt(33 bits), concatConfig.COMPUTE_CHANNEL_NUM)
    val mulScale = Array.tabulate(concatConfig.COMPUTE_CHANNEL_NUM)(i => {
        def gen = {
            val mul = Mul(32, 32, 33, MulConfig.signed, MulConfig.unsigned, 3, MulConfig.dsp, this.clockDomain, "concatMul", 63, 31, i == 0)
            mul.io.A <> io.dataIn(i)
            mul.io.B <> io.scale
            mul.io.P <> mulDataOut(i)
            mul
        }

        gen
    })

    def <<(dataIn: SInt): UInt = {
        val dataOut = Reg(UInt(8 bits))
        val dataInTemp = Reg(SInt(32 bits))
        when(dataIn(0)) {
            dataInTemp := dataIn(32 downto 1) + 1
        } otherwise {
            dataInTemp := dataIn(32 downto 1)
        }
        when(dataInTemp.sign) {
            dataOut := 0
        } elsewhen (dataInTemp > 255) {
            dataOut := 255
        } otherwise {
            dataOut := dataInTemp(7 downto 0).asUInt
        }
        dataOut
    }

    (0 until concatConfig.COMPUTE_CHANNEL_NUM).foreach(i => {
        io.dataOut(i) := <<(mulDataOut(i))
    })

}

object Concat extends App {
    SpinalVerilog(new Concat(ConcatConfig(8, 8, 640, 10)))
}
