package shape.post_pocessing

import spinal.core._
import spinal.lib._
import config.Config._
import wa.WaCounter

import java.io.File

object ChannelChoiceEnum extends SpinalEnum(defaultEncoding = binaryOneHot) {
    val IDLE, INIT, P3, P4, P5, END = newElement
}

case class ChannelChoiceState(start: Bool) extends Area {
    val initEnd = Bool()
    val P3End = Bool()
    val P4End = Bool()
    val P5End = Bool()

    val currentState = Reg(ChannelChoiceEnum()) init ChannelChoiceEnum.IDLE
    val nextState = ChannelChoiceEnum()
    currentState := nextState
    switch(currentState) {
        is(ChannelChoiceEnum.IDLE) {
            when(start) {
                nextState := ChannelChoiceEnum.INIT
            } otherwise {
                nextState := ChannelChoiceEnum.IDLE
            }
        }

        is(ChannelChoiceEnum.INIT) {
            when(initEnd) {
                nextState := ChannelChoiceEnum.P3
            } otherwise {
                nextState := ChannelChoiceEnum.INIT
            }
        }
        is(ChannelChoiceEnum.P3) {
            when(P3End) {
                nextState := ChannelChoiceEnum.P4
            } otherwise {
                nextState := ChannelChoiceEnum.P3
            }
        }
        is(ChannelChoiceEnum.P4) {
            when(P4End) {
                nextState := ChannelChoiceEnum.P5
            } otherwise {
                nextState := ChannelChoiceEnum.P4
            }
        }
        is(ChannelChoiceEnum.P5) {
            when(P5End) {
                nextState := ChannelChoiceEnum.END
            } otherwise {
                nextState := ChannelChoiceEnum.P5
            }
        }
        is(ChannelChoiceEnum.END) {
            nextState := ChannelChoiceEnum.IDLE
        }
    }
}


/**
 * 选取通道模块
 * 检测头选取 0-3(reg) 16(obj) 32(cls) 通道
 * from channel_in = 48 to channel_out = 6
 * 加坐标点
 */
class ChannelChoice(pocessingConfig: PocessingConfig) extends Component {
    val io = new Bundle {
        val start = in Bool()
        val sData = slave Stream UInt(pocessingConfig.STREAM_DATA_WIDTH bits)

        val mData_valid = out Bool()
        val reg_data = out UInt(32 bits)
        val obj_data = out UInt(8 bits)
        val cls_data = out UInt(8 bits)
        val x = out UInt(pocessingConfig.FEATURE_WIDTH bits)
        val y = out UInt(pocessingConfig.FEATURE_WIDTH bits)
        val z = out UInt(pocessingConfig.HEAD_WIDTH bits)
    }

    val fsm = ChannelChoiceState(io.start)
    val initCount = WaCounter(fsm.currentState === ChannelChoiceEnum.INIT, 3, 5)
    fsm.initEnd := initCount.valid

    io.sData.ready := fsm.currentState === ChannelChoiceEnum.P3 || fsm.currentState === ChannelChoiceEnum.P4 || fsm.currentState === ChannelChoiceEnum.P5

    val channelCnt = WaCounter(io.sData.fire &&
        (fsm.currentState === ChannelChoiceEnum.P3 || fsm.currentState === ChannelChoiceEnum.P4 || fsm.currentState === ChannelChoiceEnum.P5),
        pocessingConfig.CHANNEL_WIDTH, pocessingConfig.CHANNEL_IN_TIMES - 1)

    val p3_colCnt = WaCounter(channelCnt.last_valid && fsm.currentState === ChannelChoiceEnum.P3, pocessingConfig.FEATURE_WIDTH, pocessingConfig.P3_ROW_COL_NUM - 1)
    val p3_rowCnt = WaCounter(p3_colCnt.last_valid, pocessingConfig.FEATURE_WIDTH, pocessingConfig.P3_ROW_COL_NUM - 1)
    fsm.P3End := p3_rowCnt.last_valid

    val p4_colCnt = WaCounter(channelCnt.last_valid && fsm.currentState === ChannelChoiceEnum.P4, pocessingConfig.FEATURE_WIDTH, pocessingConfig.P4_ROW_COL_NUM - 1)
    val p4_rowCnt = WaCounter(p4_colCnt.last_valid, pocessingConfig.FEATURE_WIDTH, pocessingConfig.P4_ROW_COL_NUM - 1)
    fsm.P4End := p4_rowCnt.last_valid

    val p5_colCnt = WaCounter(channelCnt.last_valid && fsm.currentState === ChannelChoiceEnum.P5, pocessingConfig.FEATURE_WIDTH, pocessingConfig.P5_ROW_COL_NUM - 1)
    val p5_rowCnt = WaCounter(p5_colCnt.last_valid, pocessingConfig.FEATURE_WIDTH, pocessingConfig.P5_ROW_COL_NUM - 1)
    fsm.P5End := p5_rowCnt.last_valid

    val reg_obj_cls_cat = Reg(UInt(pocessingConfig.FLOW_DATA_WIDTH bits)) init (0)

    when(channelCnt.count === 0) {
        reg_obj_cls_cat(31 downto (0)) := io.sData.payload(31 downto (0))
    } elsewhen (channelCnt.count === 2) {
        reg_obj_cls_cat(39 downto (32)) := io.sData.payload(7 downto (0))
    } elsewhen (channelCnt.count === 4){
        reg_obj_cls_cat(47 downto (40)) := io.sData.payload(7 downto (0))
    } otherwise({
        reg_obj_cls_cat := reg_obj_cls_cat
    })

    io.reg_data := reg_obj_cls_cat(31 downto (0))
    io.obj_data := reg_obj_cls_cat(39 downto (32))
    io.cls_data := reg_obj_cls_cat(47 downto (40))
    when(Delay(channelCnt.last_valid, 1)) {
        io.mData_valid.set()
    } otherwise ({
        io.mData_valid.clear()
    })

    when(fsm.currentState === ChannelChoiceEnum.P3) {
        io.z := RegNext(U(1)).resized
        io.x := Delay(p3_colCnt.count, 1)
        io.y := Delay(p3_rowCnt.count, 1)
    } elsewhen (fsm.currentState === ChannelChoiceEnum.P4) {
        io.z := RegNext(U(2))
        io.x := Delay(p4_colCnt.count, 1)
        io.y := Delay(p4_rowCnt.count, 1)
    } elsewhen (fsm.currentState === ChannelChoiceEnum.P5) {
        io.z := RegNext(U(3))
        io.x := Delay(p5_colCnt.count, 1)
        io.y := Delay(p5_rowCnt.count, 1)
    }otherwise({
        io.z.clearAll()
        io.x.clearAll()
        io.y.clearAll()
    })

    when(fsm.currentState === ChannelChoiceEnum.END) {
        channelCnt.clear
        p3_colCnt.clear
        p3_rowCnt.clear
        p4_colCnt.clear
        p4_rowCnt.clear
        p5_colCnt.clear
        p5_rowCnt.clear
    }
}

object ChannelChoice extends App {
    val clkCfg = ClockDomainConfig(resetKind = SYNC, resetActiveLevel = LOW) // 同步低电平复位
    SpinalConfig(
        headerWithDate = true,
        oneFilePerComponent = false,
        targetDirectory = filePath, // 文件生成路径
        defaultConfigForClockDomains = clkCfg
    ).generateVerilog(new ChannelChoice(PocessingConfig(8, 16)))
}
