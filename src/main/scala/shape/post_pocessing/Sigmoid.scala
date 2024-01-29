package shape.post_pocessing

import spinal.core._
import spinal.lib._
import config.Config._

import java.io.File
import scala.language.postfixOps

//Sigmoid近似实现公式
//    if num >= 0:
//        if abs(num) >= 5:
//            num = 1
//        elif 2.375 <= abs(num) < 5:
//            num = 0.03125 * abs(num) + 0.84375
//        elif 1 <= abs(num) < 2.375:
//            num = 0.125 * abs(num) + 0.625
//        elif 0 <= abs(num) < 1:
//            num = 0.25 * abs(num) + 0.5
//    else:
//        num = 1 - f((abs(num)))

//Sigmoid fpga实现公式
//    if num >= 0:
//        if abs(num) >= 5 << 17:
//            num = 1 << 17
//        elif (2.375 << 17) <= abs(num) < (5 << 17):
//            num = abs(num) >> 5 + 0.84375 << 17
//        elif (1 << 17) <= abs(num) < (2.375 << 17):
//            num = abs(num) >> 3 + 0.625 << 17
//        elif 0 <= abs(num) < (1 << 17):
//            num = abs(num) >> 2 + 0.5 << 17
//    else:
//        num = 1 << 17 - f((abs(num)))

/**
 * 上一级 dequant 左移17位
 * sigmoid 整体左移17位
 * @param pocessingConfig
 */
class Sigmoid(pocessingConfig: PocessingConfig) extends Component {
    val io = new Bundle {
        val sData_valid     = in Bool()
        val reg_data_quan   = in UInt (32 bits)
        val obj_data_quan   = in UInt (8 bits)
        val cls_data_quan   = in UInt (8 bits)
        val obj_data_dequan = in SInt (32 bits)
        val cls_data_dequan = in SInt (32 bits)
        val x_1             = in UInt (pocessingConfig.FEATURE_WIDTH bits)
        val y_1             = in UInt (pocessingConfig.FEATURE_WIDTH bits)
        val z_1             = in UInt (pocessingConfig.HEAD_WIDTH bits)

        val mData_valid     = out Bool()
        val m_reg_data      = out UInt(32 bits)
        val m_obj_data_quan = out UInt(8 bits)
        val m_cls_data_quan = out UInt(8 bits)
        val m_obj_data      = out UInt(32 bits)
        val m_cls_data      = out UInt(32 bits)
        val m_x             = out UInt(pocessingConfig.FEATURE_WIDTH bits)
        val m_y             = out UInt(pocessingConfig.FEATURE_WIDTH bits)
        val m_z             = out UInt(pocessingConfig.HEAD_WIDTH bits)
    }

    val obj_abs_data = UInt(32 bits)
    val cls_abs_data = UInt(32 bits)

    obj_abs_data := io.obj_data_dequan.abs
    cls_abs_data := io.cls_data_dequan.abs

    val obj_mid_result = Reg(UInt(32 bits)) init(0)
    val cls_mid_result = Reg(UInt(32 bits)) init(0)

    val obj_num_le_0       = io.obj_data_dequan.msb
    val obj_num_geq_5      = obj_abs_data >= 655360
    val obj_num_geq_2375   = obj_abs_data >= 311296
    val obj_num_geq_1      = obj_abs_data >= 131072

    val cls_num_le_0       = io.cls_data_dequan.msb
    val cls_num_geq_5      = cls_abs_data >= 655360
    val cls_num_geq_2375   = cls_abs_data >= 311296
    val cls_num_geq_1      = cls_abs_data >= 131072

    when(obj_num_geq_5){
        obj_mid_result := U(131072, 32 bits)
    }elsewhen(obj_num_geq_2375){
        obj_mid_result := ((obj_abs_data >> 5) + 110592).resized
    }elsewhen(obj_num_geq_1){
        obj_mid_result := ((obj_abs_data >> 3) + 81920).resized
    }otherwise({
        obj_mid_result := ((obj_abs_data >> 2) + 65536).resized
    })

    when(cls_num_geq_5) {
        cls_mid_result := U(131072, 32 bits)
    } elsewhen (cls_num_geq_2375) {
        cls_mid_result := ((cls_abs_data >> 5) + 110592).resized
    } elsewhen (cls_num_geq_1) {
        cls_mid_result := ((cls_abs_data >> 3) + 81920).resized
    } otherwise ({
        cls_mid_result := ((cls_abs_data >> 2) + 65536).resized
    })

    val obj_result = Reg(UInt(32 bits)) init (0)
    val cls_result = Reg(UInt(32 bits)) init (0)

    when(Delay(obj_num_le_0, 1, init = False)){
        obj_result := U(131072, 32 bits) - obj_mid_result
    }otherwise({
        obj_result := obj_mid_result
    })

    when(Delay(cls_num_le_0, 1, init = False)) {
        cls_result := U(131072, 32 bits) - cls_mid_result
    } otherwise ({
        cls_result := cls_mid_result
    })

    io.mData_valid := Delay(io.sData_valid, 2, init = False)
    io.m_reg_data := Delay(io.reg_data_quan, 2, init = U(0).resized)
    io.m_obj_data_quan := Delay(io.obj_data_quan, 2, init = U(0).resized)
    io.m_cls_data_quan := Delay(io.cls_data_quan, 2, init = U(0).resized)
    io.m_x := Delay(io.x_1, 2, init = U(0).resized)
    io.m_y := Delay(io.y_1, 2, init = U(0).resized)
    io.m_z := Delay(io.z_1, 2, init = U(0).resized)
    io.m_obj_data := obj_result
    io.m_cls_data := cls_result
}

object Sigmoid extends App {
    val clkCfg = ClockDomainConfig(resetKind = SYNC, resetActiveLevel = LOW) // 同步低电平复位
    SpinalConfig(
        headerWithDate = true,
        oneFilePerComponent = false,
        targetDirectory = filePath, // 文件生成路径
        defaultConfigForClockDomains = clkCfg
    ).generateVerilog(new Sigmoid(PocessingConfig(8, 16)))
}
