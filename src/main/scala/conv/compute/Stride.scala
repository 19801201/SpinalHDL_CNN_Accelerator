package conv.compute

import spinal.core._
import spinal.lib._
import wa.WaCounter
import wa.WaStream.WaStreamFifoPipe

object StrideEnum extends SpinalEnum(defaultEncoding = binaryOneHot) {
    val IDLE, INIT, STRIDE = newElement
}


case class StrideFsm(start: Bool, end: Bool) extends Area {

    val initEnd = Bool()

    val currentState = Reg(StrideEnum()) init StrideEnum.IDLE
    val nextState = StrideEnum()
    currentState := nextState
    switch(currentState) {
        is(StrideEnum.IDLE) {
            when(start) {
                nextState := StrideEnum.INIT
            } otherwise {
                nextState := StrideEnum.IDLE
            }
        }
        is(StrideEnum.INIT) {
            when(initEnd) {
                nextState := StrideEnum.STRIDE
            } otherwise {
                nextState := StrideEnum.INIT
            }
        }
        is(StrideEnum.STRIDE) {
            when(end) {
                nextState := StrideEnum.IDLE
            } otherwise {
                nextState := StrideEnum.STRIDE
            }
        }
    }
}


class Stride(convConfig: ConvConfig) extends Component {
    val io = new Bundle {
        val sData = slave Stream UInt(convConfig.FEATURE_M_DATA_WIDTH bits)
        val mData = master Stream UInt(convConfig.FEATURE_M_DATA_WIDTH bits)
        val sReady = out Bool()
        val complete = out Bool()
        val enStride = in Bool()
        val rowNumIn = in UInt (convConfig.FEATURE_WIDTH bits)
        val colNumIn = in UInt (convConfig.FEATURE_WIDTH bits)
        val channelOut = in UInt (convConfig.CHANNEL_WIDTH bits)
        val start = in Bool()
        val last = out Bool()
    }
    noIoPrefix()

    val fsm = StrideFsm(io.start, io.complete)
    val fifo = WaStreamFifoPipe(UInt(convConfig.FEATURE_M_DATA_WIDTH bits), convConfig.strideFifoDepth)

    val initCnt = WaCounter(fsm.currentState === StrideEnum.INIT, 3, 7)
    fsm.initEnd := initCnt.valid

    val channelTimes = RegNextWhen(io.channelOut >> log2Up(convConfig.COMPUTE_CHANNEL_OUT_NUM), fsm.currentState === StrideEnum.INIT)
    val colTimes = RegNextWhen(io.colNumIn, fsm.currentState === StrideEnum.INIT)
    val rowTimes = RegNextWhen(io.rowNumIn, fsm.currentState === StrideEnum.INIT)

    //    val dataCount1 = RegNext(channelTimes * colTimes)
    //    val dataCount2 = RegNext(dataCount1 |<< 1)
    //    val dataCount = io.enStride ? dataCount2 | dataCount1
    val dataCount = RegNext(channelTimes * colTimes)

    val channelCnt = WaCounter(fsm.currentState === StrideEnum.STRIDE && io.sData.fire, channelTimes.getWidth, channelTimes - 1)
    val colCnt = WaCounter(channelCnt.valid && io.sData.fire, colTimes.getWidth, colTimes - 1)
    val rowCnt = WaCounter(channelCnt.valid && colCnt.valid && io.sData.fire, rowTimes.getWidth, rowTimes - 1)
    io.complete := rowCnt.valid && colCnt.valid && channelCnt.valid && io.sData.fire
    when(fsm.currentState === StrideEnum.IDLE) {
        initCnt.clear
        channelCnt.clear
        colCnt.clear
        rowCnt.clear
    }
    when(fsm.currentState === StrideEnum.STRIDE) {
        when(io.enStride) {
            fifo.io.push.arbitrationFrom(io.sData.throwWhen(colCnt.count(0) || rowCnt.count(0)))
        } otherwise {
            fifo.io.push.arbitrationFrom(io.sData)
        }
    } otherwise {
        fifo.io.push.valid := False
        io.sData.ready := False
    }

    fifo.io.push.payload := io.sData.payload

    when(fifo.io.availability > dataCount) {
        io.sReady := True
    } otherwise {
        io.sReady := False
    }

    fifo.io.pop <> io.mData
    val colOutTimes = Reg(UInt(io.colNumIn.getWidth bits))
    val rowOutTimes = Reg(UInt(io.rowNumIn.getWidth bits))
    when(io.enStride) {
        colOutTimes := (colTimes >> 1).resized
        rowOutTimes := (rowTimes >> 1).resized
    } otherwise{
        colOutTimes := colTimes
        rowOutTimes := rowTimes
    }
    val channelOutCnt = WaCounter(io.mData.fire, channelTimes.getWidth, channelTimes - 1)
    val colOutCnt = WaCounter(channelOutCnt.valid && io.mData.fire, colOutTimes.getWidth, colOutTimes - 1)
    val rowOutCnt = WaCounter(channelOutCnt.valid && colOutCnt.valid && io.mData.fire, rowOutTimes.getWidth, rowOutTimes - 1)
    io.last := channelOutCnt.valid && colOutCnt.valid && rowOutCnt.valid

}
//
object Stride extends App {
    SpinalVerilog(new Stride(ConvConfig(8, 8, 8, 12, 8192, 512, 416, 2048, 1)))
}

