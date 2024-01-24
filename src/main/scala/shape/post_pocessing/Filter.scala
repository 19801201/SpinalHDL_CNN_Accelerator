package shape.post_pocessing

import spinal.core._
import spinal.lib._
import config.Config._
import wa.WaCounter
import wa.xip.math.{Mul, MulConfig}

import java.io.File

object FilterEnum extends SpinalEnum(defaultEncoding = binaryOneHot) {
    val IDLE, INIT, P3, P4, P5, SEND_CONF, END = newElement
}

case class FilterState(start: Bool) extends Area {
    val initEnd = Bool()
    val P3End = Bool()
    val P4End = Bool()
    val P5End = Bool()
    val SEND_CONF_END = Bool()

    val currentState = Reg(FilterEnum()) init FilterEnum.IDLE
    val nextState = FilterEnum()
    currentState := nextState
    switch(currentState) {
        is(FilterEnum.IDLE) {
            when(start) {
                nextState := FilterEnum.INIT
            } otherwise {
                nextState := FilterEnum.IDLE
            }
        }

        is(FilterEnum.INIT) {
            when(initEnd) {
                nextState := FilterEnum.P3
            } otherwise {
                nextState := FilterEnum.INIT
            }
        }
        is(FilterEnum.P3) {
            when(P3End) {
                nextState := FilterEnum.P4
            } otherwise {
                nextState := FilterEnum.P3
            }
        }
        is(FilterEnum.P4) {
            when(P4End) {
                nextState := FilterEnum.P5
            } otherwise {
                nextState := FilterEnum.P4
            }
        }
        is(FilterEnum.P5) {
            when(P5End) {
                nextState := FilterEnum.SEND_CONF
            } otherwise {
                nextState := FilterEnum.P5
            }
        }
        is(FilterEnum.SEND_CONF) {
            when(SEND_CONF_END) {
                nextState := FilterEnum.END
            } otherwise {
                nextState := FilterEnum.SEND_CONF
            }
        }
        is(FilterEnum.END) {
            nextState := FilterEnum.IDLE
        }
    }
}


/**
 * 利用置信度进行第一轮筛选
 * obj_data * cls_data >= conf_thres(0.625) << 34  // 10,737,418,240 (0.625)   // 8,589,934,592 (0.5)
 * 地址划分 0 - 51,200 obj
 * 51,200 - 52,224 conf
 * @param pocessingConfig
 */
class Filter(pocessingConfig: PocessingConfig) extends Component {
    val io = new Bundle {
        val start           = in Bool()
        val sData_valid     = in Bool()
        val s_reg_data      = in UInt (32 bits)
        val s_obj_data_quan = in UInt (8 bits)
        val s_cls_data_quan = in UInt (8 bits)
        val s_obj_data      = in UInt (32 bits)
        val s_cls_data      = in UInt (32 bits)
        val s_x             = in UInt (pocessingConfig.FEATURE_WIDTH bits)
        val s_y             = in UInt (pocessingConfig.FEATURE_WIDTH bits)
        val s_z             = in UInt (pocessingConfig.HEAD_WIDTH bits)

        val w_addr = out UInt (12 bits)
        val w_data = out UInt (64 bits)
        val w_en   = out Bool()
        val finish = out Bool()
    }

    val fsm = FilterState(io.start)
    val initCount = WaCounter(fsm.currentState === FilterEnum.INIT, 3, 5)
    fsm.initEnd := initCount.valid

    val p3_colCnt = WaCounter(io.sData_valid && fsm.currentState === FilterEnum.P3, pocessingConfig.FEATURE_WIDTH, pocessingConfig.P3_ROW_COL_NUM - 1)
    val p3_rowCnt = WaCounter(p3_colCnt.last_valid, pocessingConfig.FEATURE_WIDTH, pocessingConfig.P3_ROW_COL_NUM - 1)
    fsm.P3End := p3_rowCnt.last_valid

    val p4_colCnt = WaCounter(io.sData_valid && fsm.currentState === FilterEnum.P4, pocessingConfig.FEATURE_WIDTH, pocessingConfig.P4_ROW_COL_NUM - 1)
    val p4_rowCnt = WaCounter(p4_colCnt.last_valid, pocessingConfig.FEATURE_WIDTH, pocessingConfig.P4_ROW_COL_NUM - 1)
    fsm.P4End := p4_rowCnt.last_valid

    val p5_colCnt = WaCounter(io.sData_valid && fsm.currentState === FilterEnum.P5, pocessingConfig.FEATURE_WIDTH, pocessingConfig.P5_ROW_COL_NUM - 1)
    val p5_rowCnt = WaCounter(p5_colCnt.last_valid, pocessingConfig.FEATURE_WIDTH, pocessingConfig.P5_ROW_COL_NUM - 1)
    fsm.P5End := p5_rowCnt.last_valid

    val send_cnt = WaCounter(fsm.currentState === FilterEnum.SEND_CONF, 6, pocessingConfig.MEM_DEPTH - 1)
    fsm.SEND_CONF_END := send_cnt.valid

    val cls_data = Reg(UInt(64 bits)) init 0
    when(io.sData_valid){
        cls_data :=  io.s_cls_data_quan @@ cls_data(63 downto(8))
    }otherwise({
        cls_data := cls_data
    })

    val obj_cls_mul_result = UInt(64 bits)
    val u_obj_cls_mul = Mul(32, 32, 64, MulConfig.unsigned, MulConfig.unsigned, 4, MulConfig.dsp, this.clockDomain, "obj_cls_mul")
    u_obj_cls_mul.io.A <> io.s_obj_data
    u_obj_cls_mul.io.B <> io.s_cls_data
    u_obj_cls_mul.io.P <> obj_cls_mul_result

    val conf_mask = Bool()
    when(obj_cls_mul_result(63 downto (28)) >= 40) {
        conf_mask := True
    } otherwise ({
        conf_mask := False
    })

    val conf_data = UInt(64 bits)
    val conf_fifo = StreamFifo(UInt(64 bits), pocessingConfig.MEM_DEPTH)
    conf_fifo.io.push.valid := conf_mask && Delay(io.sData_valid, 4)
    conf_fifo.io.push.payload := Delay(io.s_reg_data @@ io.s_obj_data_quan @@ io.s_cls_data_quan @@ io.s_x @@ io.s_y @@ io.s_z, 4)
    conf_fifo.io.pop.ready := fsm.currentState === FilterEnum.SEND_CONF
    conf_data := Mux(conf_fifo.io.pop.valid, conf_fifo.io.pop.payload, U(0).resized)

    when(Delay(fsm.currentState === FilterEnum.P3, 1)){
        io.w_data := cls_data
    }elsewhen(fsm.currentState === FilterEnum.SEND_CONF){
        io.w_data := conf_data
    }otherwise({
        io.w_data.clearAll()
    })

    val send_addr = Reg(UInt(12 bits)) init 0
    when(Delay(io.sData_valid && p3_colCnt.count(2 downto (0)) === 7, 1)) {
        send_addr := send_addr + 1
        io.w_en := True
    } elsewhen (fsm.currentState === FilterEnum.SEND_CONF) {
        send_addr := send_addr + 1
        io.w_en := True
    } otherwise ({
        io.w_en := False
    })

    io.w_addr := send_addr
    io.finish := fsm.currentState === FilterEnum.END

    when(fsm.currentState === FilterEnum.END){
        p3_colCnt.clear
        p3_rowCnt.clear
        p4_colCnt.clear
        p4_rowCnt.clear
        p5_colCnt.clear
        p5_rowCnt.clear
        send_cnt.clear
        send_addr.clearAll()
    }
}

object Filter extends App {
    val clkCfg = ClockDomainConfig(resetKind = SYNC, resetActiveLevel = LOW) // 同步低电平复位
    SpinalConfig(
        headerWithDate = true,
        oneFilePerComponent = false,
        targetDirectory = filePath, // 文件生成路径
        defaultConfigForClockDomains = clkCfg
    ).generateVerilog(new Filter(PocessingConfig(8, 16)))
}
