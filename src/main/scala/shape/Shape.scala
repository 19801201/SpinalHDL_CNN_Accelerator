package shape

import spinal.core._
import spinal.lib._
import wa.WaStream.{WaStreamDemux, WaStreamFifoPipe, WaStreamMux}
import wa.WaCounter
import wa.xip.math.{Mul, MulConfig}

case class ShapeConfig(DATA_WIDTH: Int, COMPUTE_CHANNEL_NUM: Int, FEATURE: Int, CHANNEL_WIDTH: Int, ROW_MEM_DEPTH: Int) {
    val STREAM_DATA_WIDTH = DATA_WIDTH * COMPUTE_CHANNEL_NUM

    val concatConfig = ConcatConfig(DATA_WIDTH, COMPUTE_CHANNEL_NUM, FEATURE, CHANNEL_WIDTH)
    val splitConfig = SplitConfig(DATA_WIDTH, COMPUTE_CHANNEL_NUM, FEATURE, CHANNEL_WIDTH)
    val upSamplingConfig = UpSamplingConfig(DATA_WIDTH, COMPUTE_CHANNEL_NUM, FEATURE, CHANNEL_WIDTH, ROW_MEM_DEPTH)
    val maxPoolingConfig = MaxPoolingConfig(DATA_WIDTH, COMPUTE_CHANNEL_NUM, FEATURE, CHANNEL_WIDTH, ROW_MEM_DEPTH)
    val addConfig = AddConfig(DATA_WIDTH, COMPUTE_CHANNEL_NUM, FEATURE, CHANNEL_WIDTH, ROW_MEM_DEPTH)
}


class Shape(shapeConfig: ShapeConfig) extends Component {
    val io = new Bundle {
        val sData = Vec(slave Stream (UInt(shapeConfig.STREAM_DATA_WIDTH bits)), 2)
        val mData = master Stream (UInt(shapeConfig.STREAM_DATA_WIDTH bits))
        val dmaReadValid = out Vec(Bool(), 2)
        val dmaWriteValid = out Bool()
        val control = in Bits (4 bits)
        val state = out Bits (4 bits)
        val introut = in Bool()
        val instruction = in Vec(Bits(32 bits), 6)
        val last = out Bool()
    }
    noIoPrefix()

    val shapeState = new ShapeState
    shapeState.io.dmaReadValid <> io.dmaReadValid
    shapeState.io.dmaWriteValid <> io.dmaWriteValid
    shapeState.io.control <> io.control
    shapeState.io.state <> io.state

    shapeState.io.complete <> io.introut

    val start = shapeState.io.start.map(_.rise()).reduce(_ || _)
    val instruction = io.instruction.reverse.reduceRight(_ ## _)
    val instructionReg = Reg(Bits(instruction.getWidth bits)) init 0
    when(start) {
        instructionReg := instruction
    }


    val fifoReady = Reg(Bool()) init False

    val concat = new Concat(shapeConfig.concatConfig)
    concat.dataPort.start <> Delay(shapeState.io.start(Start.CONCAT), 8)
    concat.dataPort.colNumIn <> instructionReg(Instruction.COL_NUM_IN).asUInt.resized
    concat.dataPort.rowNumIn <> instructionReg(Instruction.ROW_NUM_IN).asUInt.resized
    concat.dataPort.channelIn <> instructionReg(Instruction.CHANNEL_IN).asUInt.resized
    concat.channelIn1 <> instructionReg(Instruction.CHANNEL_IN1).asUInt.resized
    concat.zero <> instructionReg(Instruction.ZERO).asUInt.resized
    concat.scale <> instructionReg(Instruction.SCALE).asUInt.resized
    concat.zero1 <> instructionReg(Instruction.ZERO1).asUInt.resized
    concat.scale1 <> instructionReg(Instruction.SCALE1).asUInt.resized
    concat.dataPort.fifoReady <> fifoReady

    val add = new Add(shapeConfig.addConfig)
    add.dataPort.start <> Delay(shapeState.io.start(Start.ADD), 8)
    add.dataPort.colNumIn <> instructionReg(Instruction.COL_NUM_IN).asUInt.resized
    add.dataPort.rowNumIn <> instructionReg(Instruction.ROW_NUM_IN).asUInt.resized
    add.dataPort.channelIn <> instructionReg(Instruction.CHANNEL_IN).asUInt.resized
    add.channelIn1 <> instructionReg(Instruction.CHANNEL_IN1).asUInt.resized
    add.zero <> instructionReg(Instruction.ZERO).asUInt.resized
    add.scale <> instructionReg(Instruction.SCALE).asUInt.resized
    add.zero1 <> instructionReg(Instruction.ZERO1).asUInt.resized
    add.scale1 <> instructionReg(Instruction.SCALE1).asUInt.resized
    add.dataPort.fifoReady <> fifoReady

    val maxPooling = new MaxPooling(shapeConfig.maxPoolingConfig)
    maxPooling.io.start <> Delay(shapeState.io.start(Start.MAX_POOLING), 8)
    maxPooling.io.colNumIn <> instructionReg(Instruction.COL_NUM_IN).asUInt.resized
    maxPooling.io.rowNumIn <> instructionReg(Instruction.ROW_NUM_IN).asUInt.resized
    maxPooling.io.channelIn <> instructionReg(Instruction.CHANNEL_IN).asUInt.resized
    maxPooling.io.enPadding <> instructionReg(Instruction.ENPADDING).asBool.resized
    maxPooling.io.kernelNum <> instructionReg(Instruction.KERNELNUM).asUInt.resized
    maxPooling.io.strideNum <> instructionReg(Instruction.STRIDENUM).asUInt.resized
    maxPooling.io.zeroDara <> instructionReg(Instruction.ZERODATA).asBits.resized
    maxPooling.io.zeroNum <> instructionReg(Instruction.ZERONUM).asUInt.resized

    val split = new Split(shapeConfig.splitConfig)
    split.io.start <> Delay(shapeState.io.start(Start.SPLIT), 8)
    split.io.colNumIn <> instructionReg(Instruction.COL_NUM_IN).asUInt.resized
    split.io.rowNumIn <> instructionReg(Instruction.ROW_NUM_IN).asUInt.resized
    split.io.channelIn <> instructionReg(Instruction.CHANNEL_IN).asUInt.resized
    split.io.fifoReady <> fifoReady

    val upSampling = new UpSampling(shapeConfig.upSamplingConfig)
    upSampling.io.start <> Delay(shapeState.io.start(Start.UP_SAMPLING), 8)
    upSampling.io.colNumIn <> instructionReg(Instruction.COL_NUM_IN).asUInt.resized
    upSampling.io.rowNumIn <> instructionReg(Instruction.ROW_NUM_IN).asUInt.resized
    upSampling.io.channelIn <> instructionReg(Instruction.CHANNEL_IN).asUInt.resized
    upSampling.io.fifoReady <> fifoReady


    //    val dataCount1 = RegNext((instructionReg(Instruction.CHANNEL_IN) >> log2Up(shapeConfig.COMPUTE_CHANNEL_NUM)).asUInt * instructionReg(Instruction.COL_NUM_IN).asUInt)
    val mulDataCount1 = Mul((instructionReg(Instruction.CHANNEL_IN) >> log2Up(shapeConfig.COMPUTE_CHANNEL_NUM)).asUInt.getWidth, instructionReg(Instruction.COL_NUM_IN).asUInt.getWidth, (instructionReg(Instruction.CHANNEL_IN) >> log2Up(shapeConfig.COMPUTE_CHANNEL_NUM)).asUInt.getWidth + instructionReg(Instruction.COL_NUM_IN).asUInt.getWidth, MulConfig.unsigned, MulConfig.unsigned, 3, MulConfig.dsp, this.clockDomain, "shapeCount1", true)
    mulDataCount1.io.A := (instructionReg(Instruction.CHANNEL_IN) >> log2Up(shapeConfig.COMPUTE_CHANNEL_NUM)).asUInt
    mulDataCount1.io.B := instructionReg(Instruction.COL_NUM_IN).asUInt
//    println(mulDataCount1.io.P.getWidth)
    val dataCount1 = UInt(mulDataCount1.io.P.getWidth bits)
    dataCount1 := mulDataCount1.io.P.asBits.asUInt
    val dataCount2 = RegNext(dataCount1 |<< 1)
    val dataCount = Reg(UInt(dataCount2.getWidth bits))

    val fifo = WaStreamFifoPipe(UInt(shapeConfig.STREAM_DATA_WIDTH bits), shapeConfig.ROW_MEM_DEPTH << 1)
    fifo.fifo.logic.ram.addAttribute("ram_style = \"block\"")
    fifo.io.pop <> io.mData

    val channelOutTimes = Reg(UInt(instructionReg(Instruction.CHANNEL_IN).getWidth bits))
    val colOutTimes = Reg(UInt(instructionReg(Instruction.COL_NUM_IN).getWidth bits))
    val rowOutTimes = Reg(UInt(instructionReg(Instruction.ROW_NUM_IN).getWidth bits))
    switch(shapeState.io.state) {
        is(State.CONCAT) {
            dataCount := RegNext(dataCount2)
            colOutTimes := RegNext(instructionReg(Instruction.COL_NUM_IN).asUInt)
            rowOutTimes := RegNext(instructionReg(Instruction.ROW_NUM_IN).asUInt)
            channelOutTimes := (RegNext((instructionReg(Instruction.CHANNEL_IN) >> log2Up(shapeConfig.COMPUTE_CHANNEL_NUM)).asUInt) + RegNext((instructionReg(Instruction.CHANNEL_IN1) >> log2Up(shapeConfig.COMPUTE_CHANNEL_NUM)).asUInt)).resized
        }
        is(State.ADD) {
            dataCount := RegNext(dataCount2)
            colOutTimes := RegNext(instructionReg(Instruction.COL_NUM_IN).asUInt)
            rowOutTimes := RegNext(instructionReg(Instruction.ROW_NUM_IN).asUInt)
            channelOutTimes := RegNext((instructionReg(Instruction.CHANNEL_IN) >> log2Up(shapeConfig.COMPUTE_CHANNEL_NUM))).asUInt.resized
        }
        is(State.MAX_POOLING) {
            dataCount := RegNext(dataCount1.resized)
            colOutTimes := RegNext((instructionReg(Instruction.COL_NUM_IN) >> 1)).asUInt.resized
            rowOutTimes := RegNext((instructionReg(Instruction.ROW_NUM_IN) >> 1)).asUInt.resized
            channelOutTimes := RegNext((instructionReg(Instruction.CHANNEL_IN) >> log2Up(shapeConfig.COMPUTE_CHANNEL_NUM))).asUInt.resized
        }
        is(State.UP_SAMPLING) {
            dataCount := RegNext(dataCount2)
            colOutTimes := RegNext((instructionReg(Instruction.COL_NUM_IN) << 1)).asUInt.resized
            rowOutTimes := RegNext((instructionReg(Instruction.ROW_NUM_IN) << 1)).asUInt.resized
            channelOutTimes := RegNext((instructionReg(Instruction.CHANNEL_IN) >> log2Up(shapeConfig.COMPUTE_CHANNEL_NUM))).asUInt.resized
        }
        is(State.SPLIT) {
            dataCount := RegNext(dataCount1.resized)
            colOutTimes := RegNext(instructionReg(Instruction.COL_NUM_IN).asUInt)
            rowOutTimes := RegNext(instructionReg(Instruction.ROW_NUM_IN).asUInt)
            channelOutTimes := RegNext((instructionReg(Instruction.CHANNEL_IN) >> (1 + log2Up(shapeConfig.COMPUTE_CHANNEL_NUM)))).asUInt.resized
        }
        default {
            dataCount := 0
            colOutTimes := colOutTimes
            rowOutTimes := rowOutTimes
            channelOutTimes := channelOutTimes
        }
    }
    val channelOutCnt = WaCounter(io.mData.fire, channelOutTimes.getWidth, channelOutTimes - 1)
    val colOutCnt = WaCounter(channelOutCnt.valid && io.mData.fire, colOutTimes.getWidth, colOutTimes - 1)
    val rowOutCnt = WaCounter(channelOutCnt.valid && colOutCnt.valid && io.mData.fire, rowOutTimes.getWidth, rowOutTimes - 1)
    io.last := channelOutCnt.valid && colOutCnt.valid && rowOutCnt.valid

    when(fifo.io.availability > dataCount) {
        fifoReady := True
    } otherwise {
        fifoReady := False
    }


    val s = Vec(Stream(UInt(io.sData(1).payload.getWidth bits)), 3)
    s.foreach(a => a.ready := False)
    Vec(concat.dataPort.sData, add.dataPort.sData, maxPooling.io.sData, upSampling.io.sData, split.io.sData) <> WaStreamDemux(Seq(State.CONCAT, State.ADD, State.MAX_POOLING, State.UP_SAMPLING, State.SPLIT), io.sData(0), shapeState.io.state)
    Vec(concat.sData1, add.sData1, s(0), s(1), s(2)) <> WaStreamDemux(Seq(State.CONCAT, State.ADD, State.MAX_POOLING, State.UP_SAMPLING, State.SPLIT), io.sData(1), shapeState.io.state)

    fifo.io.push <> WaStreamMux(Seq(State.CONCAT, State.ADD, State.MAX_POOLING, State.UP_SAMPLING, State.SPLIT), shapeState.io.state, Seq(concat.dataPort.mData, add.dataPort.mData, maxPooling.io.mData, upSampling.io.mData, split.io.mData))

    //    switch(shapeState.io.state) {
    //        is(State.CONCAT) {
    //            io.sData(0) <> concat.dataPort.sData
    //            io.sData(1) <> concat.sData1
    //            fifo.io.push <> concat.dataPort.mData
    //            dataCount := dataCount2
    //            clearS(maxPooling.io.sData)
    //            clearS(split.io.sData)
    //            clearS(upSampling.io.sData)
    //            clearM(maxPooling.io.mData)
    //            clearM(upSampling.io.mData)
    //            clearM(split.io.mData)
    //            clearS(add.sData1)
    //            clearS(add.dataPort.sData)
    //            clearM(add.dataPort.mData)
    //        }
    //        is(State.ADD) {
    //            io.sData(0) <> add.dataPort.sData
    //            io.sData(1) <> add.sData1
    //            fifo.io.push <> add.dataPort.mData
    //            dataCount := dataCount2
    //            clearS(concat.sData1)
    //            clearS(concat.dataPort.sData)
    //            clearS(maxPooling.io.sData)
    //            clearS(split.io.sData)
    //            clearS(upSampling.io.sData)
    //            clearM(concat.dataPort.mData)
    //            clearM(maxPooling.io.mData)
    //            clearM(upSampling.io.mData)
    //            clearM(split.io.mData)
    //        }
    //        is(State.MAX_POOLING) {
    //            io.sData(0) <> maxPooling.io.sData
    //            io.sData(1).ready <> False
    //            fifo.io.push <> maxPooling.io.mData
    //            dataCount := dataCount1.resized
    //            clearS(concat.sData1)
    //            clearS(concat.dataPort.sData)
    //            clearS(split.io.sData)
    //            clearS(upSampling.io.sData)
    //            clearM(concat.dataPort.mData)
    //            clearM(upSampling.io.mData)
    //            clearM(split.io.mData)
    //            clearS(add.sData1)
    //            clearS(add.dataPort.sData)
    //            clearM(add.dataPort.mData)
    //        }
    //        is(State.UP_SAMPLING) {
    //            io.sData(0) <> upSampling.io.sData
    //            io.sData(1).ready <> False
    //            fifo.io.push <> upSampling.io.mData
    //            dataCount := dataCount2
    //            clearS(concat.sData1)
    //            clearS(concat.dataPort.sData)
    //            clearS(maxPooling.io.sData)
    //            clearS(split.io.sData)
    //            clearM(concat.dataPort.mData)
    //            clearM(maxPooling.io.mData)
    //            clearM(split.io.mData)
    //            clearS(add.sData1)
    //            clearS(add.dataPort.sData)
    //            clearM(add.dataPort.mData)
    //        }
    //        is(State.SPLIT) {
    //            io.sData(0) <> split.io.sData
    //            io.sData(1).ready <> False
    //            fifo.io.push <> split.io.mData
    //            dataCount := dataCount1.resized
    //            clearS(concat.sData1)
    //            clearS(concat.dataPort.sData)
    //            clearS(maxPooling.io.sData)
    //            clearS(upSampling.io.sData)
    //            clearM(concat.dataPort.mData)
    //            clearM(maxPooling.io.mData)
    //            clearM(upSampling.io.mData)
    //            clearS(add.sData1)
    //            clearS(add.dataPort.sData)
    //            clearM(add.dataPort.mData)
    //        }
    //        default {
    //            io.sData(0).ready := False
    //            io.sData(1).ready := False
    //            dataCount := 0
    //            clearS(concat.sData1)
    //            clearS(concat.dataPort.sData)
    //            clearS(maxPooling.io.sData)
    //            clearS(split.io.sData)
    //            clearS(upSampling.io.sData)
    //            clearS(fifo.io.push)
    //            //            fifo.io.push.valid := False
    //            //            fifo.io.push.payload := 0
    //            clearM(concat.dataPort.mData)
    //            clearM(maxPooling.io.mData)
    //            clearM(upSampling.io.mData)
    //            clearM(split.io.mData)
    //            clearS(add.sData1)
    //            clearS(add.dataPort.sData)
    //            clearM(add.dataPort.mData)
    //        }
    //    }
    //
    //    def clearS(s: Stream[UInt]): Unit = {
    //        s.payload := 0
    //        s.valid := False
    //    }
    //
    //    def clearM(m: Stream[UInt]): Unit = {
    //        m.ready := False
    //    }
}

object Shape extends App {
    SpinalVerilog(new Shape(ShapeConfig(8, 8, 416, 10, 2048))).printPruned()
}
