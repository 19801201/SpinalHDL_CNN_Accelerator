package conv.dataGenerate
import com.google.gson.JsonParser
import spinal.core.{Area, Bits, Bool, Bundle, ClockDomainConfig, Component, False, HIGH, IntToBuilder, Reg, RegInit, RegNext, SYNC, SpinalConfig, SpinalEnum, True, UInt, binaryOneHot, in, is, log2Up, out, switch, when}
import spinal.lib.{Counter, master, slave}
import wa.{WaCounter, WaStreamFifo}
import spinal.core.sim._

import scala.io.Source

case class PaddingConfig(DATA_WIDTH: Int, CHANNEL_WIDTH: Int, COMPUTE_CHANNEL_NUM: Int, FEATURE_WIDTH: Int, ZERO_NUM: Int) {
    val PICTURE_NUM = 1
    val STREAM_DATA_WIDTH = DATA_WIDTH * PICTURE_NUM * COMPUTE_CHANNEL_NUM
    val ZERO_NUM_WIDTH = ZERO_NUM.toBinaryString.length
}

object PaddingEnum extends SpinalEnum(defaultEncoding = binaryOneHot) {
    val IDLE, INIT, UPDOWN, LEFT, CENTER, RIGHT, END = newElement
}


case class PaddingFsm(start: Bool) extends Area {

    val initEnd = Bool()
    val leftEnd = Bool()
    val rightEnd = Bool()
    val upDownEnd = Bool()
    val centerEnd = Bool()
    val endEnd = Reg(False)
    val enPadding = Bool()
    val enUpDown = Bool()
    val currentState = Reg(PaddingEnum()) init PaddingEnum.IDLE
    val nextState = PaddingEnum()
    currentState := nextState
    switch(currentState) {
        is(PaddingEnum.IDLE) {
            when(start) {
                nextState := PaddingEnum.INIT
            } otherwise {
                nextState := PaddingEnum.IDLE
            }
        }
        is(PaddingEnum.INIT) {
            when(initEnd) {
                when(enPadding) {
                    nextState := PaddingEnum.LEFT
                } otherwise {
                    nextState := PaddingEnum.CENTER
                }
            } otherwise {
                nextState := PaddingEnum.INIT
            }
        }
        is(PaddingEnum.UPDOWN) {
            when(upDownEnd) {
                nextState := PaddingEnum.RIGHT
            } otherwise {
                nextState := PaddingEnum.UPDOWN
            }
        }
        is(PaddingEnum.LEFT) {
            when(leftEnd) {
                when(enUpDown) {
                    nextState := PaddingEnum.UPDOWN
                } otherwise {
                    nextState := PaddingEnum.CENTER
                }

            } otherwise {
                nextState := PaddingEnum.LEFT
            }
        }
        is(PaddingEnum.CENTER) {
            when(centerEnd) {
                when(enPadding) {
                    nextState := PaddingEnum.RIGHT
                } otherwise {
                    nextState := PaddingEnum.END
                }
            } otherwise {
                nextState := PaddingEnum.CENTER
            }

        }
        is(PaddingEnum.RIGHT) {
            when(rightEnd) {
                nextState := PaddingEnum.END
            } otherwise {
                nextState := PaddingEnum.RIGHT
            }
        }
        is(PaddingEnum.END) {
            when(endEnd) {
                nextState := PaddingEnum.IDLE
            } elsewhen (enPadding) {
                nextState := PaddingEnum.LEFT
            } otherwise {
                nextState := PaddingEnum.CENTER
            }
        }
    }
}

class Padding(paddingConfig: PaddingConfig) extends Component {
    val io = new Bundle {
        val sData = slave Stream (UInt(paddingConfig.STREAM_DATA_WIDTH bits))
        val mData = master Stream (UInt(paddingConfig.STREAM_DATA_WIDTH bits))  simPublic()
        val enPadding = in Bool()
        val channelIn = in UInt (paddingConfig.CHANNEL_WIDTH bits)
        val start = in Bool()
        val rowNumIn = in UInt (paddingConfig.FEATURE_WIDTH bits)
        val rowNumOut = out UInt (paddingConfig.FEATURE_WIDTH bits)
        val colNumIn = in UInt (paddingConfig.FEATURE_WIDTH bits)
        val colNumOut = out UInt (paddingConfig.FEATURE_WIDTH bits)
        val zeroDara = in Bits (paddingConfig.DATA_WIDTH bits)
        val zeroNum = in UInt (paddingConfig.ZERO_NUM_WIDTH bits)
        val last = out Bool()
    }
    noIoPrefix()
    when(io.enPadding) {
        io.rowNumOut := (io.zeroNum << 1) + io.rowNumIn
        io.colNumOut := (io.zeroNum << 1) + io.colNumIn
    } otherwise {
        io.rowNumOut := io.rowNumIn
        io.colNumOut := io.colNumIn
    }

    val channelTimes: UInt = RegNext(io.channelIn >> log2Up(paddingConfig.COMPUTE_CHANNEL_NUM), 0)
    val fifo = WaStreamFifo(UInt(paddingConfig.STREAM_DATA_WIDTH bits), 5)
    fifo.io.pop <> io.mData

    val fsm = PaddingFsm(io.start)
    fsm.enPadding := io.enPadding
    io.sData.ready <> (fifo.io.push.ready && fsm.currentState === PaddingEnum.CENTER)

    private def assign(dst: UInt, src: UInt, dataWidth: Int): Unit = {
        if (dst.getWidth == dataWidth) dst := src
        else {
            assign(dst(dataWidth - 1 downto 0), src, dataWidth)
            assign(dst(dst.getWidth - 1 downto dataWidth), src, dataWidth)
        }
    }

    private def selfClear(in: Bool, en: Bool): Unit = {
        when(en) {
            in := True
        } otherwise {
            in := False
        }
    }

    val initEn = RegInit(False) setWhen (fsm.currentState === PaddingEnum.INIT) clearWhen (fsm.nextState =/= PaddingEnum.INIT)
    val initCount = WaCounter(initEn, 5, 8)
    when(fsm.currentState === PaddingEnum.IDLE) {
        initCount.clear
    }
    fsm.initEnd := initCount.valid


    val zeroValid = Bool()
    when(fsm.currentState === PaddingEnum.CENTER) {
        fifo.io.push.valid := io.sData.fire
        fifo.io.push.payload := io.sData.payload
    } otherwise {
        fifo.io.push.valid := zeroValid
        assign(fifo.io.push.payload, io.zeroDara.asUInt, paddingConfig.DATA_WIDTH)
    }

    val channelCnt = WaCounter(fifo.io.push.fire, paddingConfig.CHANNEL_WIDTH, channelTimes - 1)
    when(fsm.currentState === PaddingEnum.IDLE) {
        channelCnt.clear
    }
    val colCnt = WaCounter(channelCnt.valid && (fifo.io.push.fire), paddingConfig.FEATURE_WIDTH, io.colNumOut - 1)
    when(fsm.currentState === PaddingEnum.IDLE) {
        colCnt.clear
    }
    val rowCnt = WaCounter(fsm.nextState === PaddingEnum.END, paddingConfig.FEATURE_WIDTH, io.rowNumOut - 1)
    when(fsm.currentState === PaddingEnum.IDLE) {
        rowCnt.clear
    }
    selfClear(zeroValid, fsm.currentState === PaddingEnum.LEFT || fsm.currentState === PaddingEnum.RIGHT || fsm.currentState === PaddingEnum.UPDOWN)
    selfClear(fsm.leftEnd, colCnt.count === io.zeroNum - 1 && channelCnt.valid && fifo.io.push.fire)
    selfClear(fsm.rightEnd, colCnt.count === io.colNumOut - 1 && channelCnt.valid && fifo.io.push.fire)
    selfClear(fsm.endEnd, rowCnt.count === io.rowNumOut - 1)
    selfClear(fsm.upDownEnd, colCnt.count === io.colNumOut - io.zeroNum - 1 && channelCnt.valid && fifo.io.push.fire)
    selfClear(fsm.centerEnd, colCnt.count === io.colNumOut - io.zeroNum - 1 && channelCnt.valid && fifo.io.push.fire)
    selfClear(fsm.enUpDown, rowCnt.count < io.zeroNum || rowCnt.count > io.rowNumOut - io.zeroNum - 1)
    selfClear(io.last, fsm.currentState === PaddingEnum.END && fsm.nextState === PaddingEnum.IDLE)

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


        val json = Source.fromFile("G:/spinal_cnn_accelerator/simData/config.json").mkString
        val jsonP = new JsonParser().parse(json)
        val zeroNum = jsonP.getAsJsonObject.get("paddingSim").getAsJsonObject.get("zeroNum").getAsInt
        val COMPUTE_CHANNEL_NUM = jsonP.getAsJsonObject.get("total").getAsJsonObject.get("COMPUTE_CHANNEL_NUM").getAsInt
        val DATA_WIDTH = jsonP.getAsJsonObject.get("total").getAsJsonObject.get("DATA_WIDTH").getAsInt
        val CHANNEL_WIDTH = jsonP.getAsJsonObject.get("total").getAsJsonObject.get("CHANNEL_WIDTH").getAsInt
        val FEATURE_WIDTH = jsonP.getAsJsonObject.get("total").getAsJsonObject.get("FEATURE_WIDTH").getAsInt

        val paddingConfig = PaddingConfig(DATA_WIDTH, CHANNEL_WIDTH, COMPUTE_CHANNEL_NUM, FEATURE_WIDTH, zeroNum)
        SpinalConfig(
            genVhdlPkg = false,
            enumPrefixEnable = false,
            defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH, resetKind = SYNC)
        ).withoutEnumString().generateVerilog(new Padding(paddingConfig)).printPruned()
    }
}
