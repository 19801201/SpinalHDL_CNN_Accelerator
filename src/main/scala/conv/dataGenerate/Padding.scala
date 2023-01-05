package conv.dataGenerate

import com.google.gson.JsonParser
import spinal.core._
import spinal.lib._
import wa.{WaCounter, WaStreamFifo}
import spinal.core.sim._
import spinal.lib.fsm._
import wa.WaStream.WaStreamFifoPipe

import scala.io.Source

case class PaddingConfig(DATA_WIDTH: Int, CHANNEL_WIDTH: Int, COMPUTE_CHANNEL_NUM: Int, ROW_WIDTH: Int, COL_WIDTH: Int) {
    val PICTURE_NUM = 1
    val STREAM_DATA_WIDTH = DATA_WIDTH * PICTURE_NUM * COMPUTE_CHANNEL_NUM
//    val ZERO_NUM_WIDTH = ZERO_NUM.toBinaryString.length
}

object PaddingEnum {
    val left = 1;
    val right = 2;
    val up = 3;
    val down = 4;

    val leftIndex = 0;
    val rightIndex = 1;
    val upIndex = 2;
    val downIndex = 3;

}

class Padding(paddingConfig: PaddingConfig) extends Component {
    val io = new Bundle {
        val sData = slave Stream (UInt(paddingConfig.STREAM_DATA_WIDTH bits))
        val mData = master Stream (UInt(paddingConfig.STREAM_DATA_WIDTH bits)) simPublic()
        val enPadding = in Vec(Bool(), 4)
        val channelIn = in UInt (paddingConfig.CHANNEL_WIDTH bits)
        val start = in Bool()
        val rowNumIn = in UInt (paddingConfig.ROW_WIDTH bits)
        val rowNumOut = out UInt (paddingConfig.ROW_WIDTH + 1 bits)
        val colNumIn = in UInt (paddingConfig.COL_WIDTH bits)
        val colNumOut = out UInt (paddingConfig.COL_WIDTH + 1 bits)
        val zeroDara = in Bits (paddingConfig.DATA_WIDTH bits)
        //        val zeroNum = in UInt (paddingConfig.ZERO_NUM_WIDTH bits)
    }
    noIoPrefix()
    val leftRight = RegNext(io.enPadding(PaddingEnum.leftIndex) ## io.enPadding(PaddingEnum.rightIndex))
    val upDown = RegNext(io.enPadding(PaddingEnum.upIndex) ## io.enPadding(PaddingEnum.downIndex))

    def genRowColOut(index: Bits, in: UInt): UInt = {
        val out = Reg(UInt(in.getWidth + 1 bits))
        switch(index) {
            is(0) {
                out := in.resized
            }
            is(1, 2) {
                out := (in +^ 1).resized
            }
            is(3) {
                out := (in +^ 2).resized
            }

        }
        out
    }

    io.rowNumOut := genRowColOut(leftRight, io.rowNumIn)
    io.colNumOut := genRowColOut(upDown, io.colNumIn)


    val last = Reg(Bool()) init (False)


    val fsm = new StateMachine {
        val IDLE = new State() with EntryPoint
        val INIT = new State()
        val LEFT = new State()
        val UP = new State()
        val RIGHT = new State()
        val CENTRAL = new State()
        val DOWN = new State()
        val LAST = new State()

        val fifo = WaStreamFifoPipe(cloneOf(io.sData.payload), 16)

        val channelTimes: UInt = RegNext(io.channelIn >> log2Up(paddingConfig.COMPUTE_CHANNEL_NUM), 0)
        val channelTimesC = RegNext(channelTimes - 1)
        val colTimes = RegNext(io.colNumOut - 1)

        val rowTimes = RegNext(io.rowNumOut - 1)
        //        val channelCnt = WaCounter(fifo.io.push.fire, channelTimesC.getBitsWidth, channelTimesC)
        val channelCnt = Reg(UInt(channelTimesC.getBitsWidth bits))
        //        val colCnt = WaCounter(fifo.io.push.fire && channelCnt.valid, colTimes.getBitsWidth, colTimes)
        val colCnt = Reg(UInt(colTimes.getBitsWidth bits))
        val rowCnt = WaCounter(isEntering(LAST), rowTimes.getBitsWidth, rowTimes)

        val colTimes2 = Reg(UInt(io.colNumIn.getWidth bits))
        when(io.enPadding(PaddingEnum.leftIndex)) {
            colTimes2 := io.colNumIn
        } otherwise {
            colTimes2 := io.colNumIn - 1
        }

        val rowTimes2 = Reg(UInt(io.rowNumIn.getWidth bits))
        when(io.enPadding(PaddingEnum.upIndex)) {
            rowTimes2 := io.rowNumIn + 1
        } otherwise {
            rowTimes2 := io.rowNumIn
        }
        //        val leftEnd = selfClear(channelCnt.valid && fifo.io.push.fire)
        //        val rightEnd = selfClear(channelCnt.valid && fifo.io.push.fire && colCnt.valid)
        //        val upCentralDownEnd = selfClear(channelCnt.valid && fifo.io.push.fire && (colCnt.count === colTimes2))
        val enDown = selfClear(io.enPadding(PaddingEnum.downIndex) && rowCnt.count === rowTimes2)
        val enUp = selfClear(io.enPadding(PaddingEnum.upIndex) && rowCnt.count === 0)
        val lastEnd = selfClear(rowCnt.count === rowTimes)

        //        val initCounter = WaCounter(isActive(INIT), 3, 7)
        val initCounter = Reg(UInt(3 bits))

        val zeroValid: Bool = selfClear(isActive(LEFT) || isActive(RIGHT) || isActive(UP) || isActive(DOWN))
        when(isActive(CENTRAL)) {
            fifo.io.push.valid := io.sData.valid
            fifo.io.push.payload := io.sData.payload
        } otherwise {
            fifo.io.push.valid := zeroValid
            assign(fifo.io.push.payload, io.zeroDara.asUInt, paddingConfig.DATA_WIDTH)
        }
        io.sData.ready <> (fifo.io.push.ready && isActive(CENTRAL))
        fifo.io.pop <> io.mData

        IDLE.whenIsActive {
            when(io.start.rise()) {
                goto(INIT)
            }
        }
        INIT.onEntry {
            initCounter := 0
            rowCnt.clear
            colCnt := 0
            channelCnt := 0
        }
        INIT.whenIsActive {
            when(initCounter === 7) {
                when(io.enPadding(PaddingEnum.leftIndex)) {
                    goto(LEFT)
                } elsewhen io.enPadding(PaddingEnum.upIndex) {
                    goto(UP)
                } otherwise {
                    goto(CENTRAL)
                }
            }
            initCounter := initCounter + 1
        }
        LEFT.whenIsActive {
            channelCntFun
            colCntFun
            when(channelCnt === channelTimesC && fifo.io.push.fire) {
                when(enUp) {
                    goto(UP)
                } elsewhen enDown {
                    goto(DOWN)
                } otherwise {
                    goto(CENTRAL)
                }
            }
        }
        UP.whenIsActive {
            channelCntFun
            colCntFun
            when(channelCnt === channelTimesC && fifo.io.push.fire && (colCnt === colTimes2)) {
                when(io.enPadding(PaddingEnum.rightIndex)) {
                    goto(RIGHT)
                } otherwise {
                    goto(LAST)
                }
            }
        }
        RIGHT.whenIsActive {
            channelCntFun
            colCntFun
            when(channelCnt === channelTimesC && fifo.io.push.fire && colCnt === colTimes) {
                goto(LAST)
            }
        }
        CENTRAL.whenIsActive {
            channelCntFun
            colCntFun
            when(channelCnt === channelTimesC && fifo.io.push.fire && (colCnt === colTimes2)) {
                when(io.enPadding(PaddingEnum.rightIndex)) {
                    goto(RIGHT)
                } otherwise {
                    goto(LAST)
                }
            }
        }
        DOWN.whenIsActive {
            channelCntFun
            colCntFun
            when(channelCnt === channelTimesC && fifo.io.push.fire && (colCnt === colTimes2)) {
                when(io.enPadding(PaddingEnum.rightIndex)) {
                    goto(RIGHT)
                } otherwise {
                    goto(LAST)
                }
            }
        }
        LAST.whenIsActive {
            when(lastEnd) {
                goto(IDLE)
            } elsewhen io.enPadding(PaddingEnum.leftIndex) {
                goto(LEFT)
            } elsewhen enDown {
                //记得测试这个临界条件
                goto(DOWN)
            } otherwise {
                goto(CENTRAL)
            }

        }

        def channelCntFun: Unit = {
            when(channelCnt === channelTimesC) {
                channelCnt := 0
            } elsewhen fifo.io.push.fire {
                channelCnt := channelCnt + 1
            }
        }
        def colCntFun: Unit = {
            when(colCnt === colTimes) {
                colCnt := 0
            } elsewhen (fifo.io.push.fire && channelCnt === channelTimesC) {
                colCnt := colCnt + 1
            }
        }
    }

    private def assign(dst: UInt, src: UInt, dataWidth: Int): Unit = {
        if (dst.getWidth == dataWidth) dst := src
        else {
            assign(dst(dataWidth - 1 downto 0), src, dataWidth)
            assign(dst(dst.getWidth - 1 downto dataWidth), src, dataWidth)
        }
    }

    private def selfClear(en: Bool): Bool = {
        val out = Bool()
        when(en) {
            out := True
        } otherwise {
            out := False
        }
        out
    }


    def >>(featureGenerate: FeatureGenerate): Unit = {
        io.rowNumOut <> featureGenerate.io.rowNumIn
        io.colNumOut <> featureGenerate.io.colNumIn
        featureGenerate.io.channelIn := io.channelIn
        io.mData <> featureGenerate.io.sData
        featureGenerate.io.start := io.start
    }
}

object Padding {
    def main(args: Array[String]): Unit = {


        val paddingConfig = PaddingConfig(8, 10, 8, 640, 1)
        SpinalConfig(
            genVhdlPkg = false,
            enumPrefixEnable = false,
            defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH, resetKind = SYNC)
        ).withoutEnumString().generateVerilog(new Padding(paddingConfig)).printPruned()
    }
}
