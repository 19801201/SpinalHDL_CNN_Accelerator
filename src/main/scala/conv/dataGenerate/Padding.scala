package conv.dataGenerate

import com.google.gson.JsonParser
import spinal.core._
import spinal.lib._
import wa.{WaCounter, WaStreamFifo}
import spinal.core.sim._
import spinal.lib.fsm._
import wa.WaStream.WaStreamFifoPipe

import scala.io.Source

case class PaddingConfig(DATA_WIDTH: Int, CHANNEL_WIDTH: Int, COMPUTE_CHANNEL_NUM: Int, FEATURE_WIDTH: Int, ZERO_NUM: Int) {
    val PICTURE_NUM = 1
    val STREAM_DATA_WIDTH = DATA_WIDTH * PICTURE_NUM * COMPUTE_CHANNEL_NUM
    val ZERO_NUM_WIDTH = ZERO_NUM.toBinaryString.length
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
        val rowNumIn = in UInt (paddingConfig.FEATURE_WIDTH bits)
        val rowNumOut = out UInt (paddingConfig.FEATURE_WIDTH + 1 bits)
        val colNumIn = in UInt (paddingConfig.FEATURE_WIDTH bits)
        val colNumOut = out UInt (paddingConfig.FEATURE_WIDTH + 1 bits)
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


    val state = new StateMachine {
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
        val channelCnt = WaCounter(fifo.io.push.fire, channelTimesC.getBitsWidth, channelTimesC)
        val colCnt = WaCounter(fifo.io.push.fire && channelCnt.valid, colTimes.getBitsWidth, colTimes)
        val rowCnt = WaCounter(stateNext === LAST, rowTimes.getBitsWidth, rowTimes)

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
        val leftEnd = selfClear(channelCnt.valid && fifo.io.push.fire)
        val rightEnd = selfClear(channelCnt.valid && fifo.io.push.fire && colCnt.valid)
        val upCentralDownEnd = selfClear(channelCnt.valid && fifo.io.push.fire && (colCnt.count === colTimes2))
        val enDown = selfClear(io.enPadding(PaddingEnum.downIndex) && rowCnt.count === rowTimes2)

        val initCounter = WaCounter(isActive(INIT), 3, 7)
        IDLE.whenIsActive {
            when(io.start.rise()) {
                goto(INIT)
            }
        }
        INIT.onEntry {
            initCounter.clear
            rowCnt.clear
            colCnt.clear
            channelCnt.clear
        }
        INIT.whenIsActive {
            when(initCounter.valid) {
                when(io.enPadding(PaddingEnum.leftIndex)) {
                    goto(LEFT)
                } elsewhen io.enPadding(PaddingEnum.upIndex) {
                    goto(UP)
                } otherwise {
                    goto(CENTRAL)
                }
            }
        }
        LEFT.whenIsActive {

        }
        UP.whenIsActive {

        }
        RIGHT.whenIsActive {

        }
        CENTRAL.whenIsActive {

        }
        DOWN.whenIsActive {

        }
        LAST.whenIsActive {

        }
    }

    io.sData.ready := False
    io.mData.valid := False
    io.mData.payload := 0

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
