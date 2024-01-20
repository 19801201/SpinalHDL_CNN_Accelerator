package shape.post_pocessing

import spinal.core._
import spinal.lib._
import config.Config._
import wa.xip.math.{AddSub, AddSubConfig, Mul, MulConfig}

import java.io.File

/**
 * 反量化处理, 把结果转回浮点值
 * 只对种类和置信度进行反量化
 * r = s(q-z)
 *
 * @param pocessingConfig
 */
class DeQuant(pocessingConfig: PocessingConfig) extends Component {
    val io = new Bundle {
        val scale       = in UInt (16 bits)
        val zp          = in SInt (16 bits)
        val sData_valid = in Bool()
        val reg_data    = in UInt (32 bits)
        val obj_data    = in UInt (8 bits)
        val cls_data    = in UInt (8 bits)
        val x           = in UInt (pocessingConfig.FEATURE_WIDTH bits)
        val y           = in UInt (pocessingConfig.FEATURE_WIDTH bits)
        val z           = in UInt (pocessingConfig.HEAD_WIDTH bits)

        val mData_valid     = out Bool()
        val reg_data_quan   = out UInt (32 bits)
        val obj_data_quan   = out UInt(8 bits)
        val cls_data_quan   = out UInt(8 bits)
        val obj_data_dequan = out SInt (32 bits)
        val cls_data_dequan = out SInt (32 bits)
        val x_1             = out UInt (pocessingConfig.FEATURE_WIDTH bits)
        val y_1             = out UInt (pocessingConfig.FEATURE_WIDTH bits)
        val z_1             = out UInt (pocessingConfig.HEAD_WIDTH bits)
    }
    noIoPrefix()
    io.reg_data_quan := Delay(io.reg_data, 4)
    io.obj_data_quan := Delay(io.obj_data, 4)
    io.cls_data_quan := Delay(io.cls_data, 4)
    io.x_1 := Delay(io.x, 4)
    io.y_1 := Delay(io.y, 4)
    io.z_1 := Delay(io.z, 4)
    io.mData_valid := Delay(io.sData_valid, 4)

    val u_obj_dequan_add = AddSub(8, 16, 16, AddSubConfig.unsigned, AddSubConfig.signed, 1, AddSubConfig.lut, this.clockDomain, AddSubConfig.subtract, "obj_dequan_add")
    u_obj_dequan_add.io.A <> io.obj_data
    u_obj_dequan_add.io.B <> io.zp

    val u_obj_dequan_mul = Mul(16, 16, 32, MulConfig.signed, MulConfig.unsigned, 3, MulConfig.dsp, this.clockDomain, "obj_dequan_mul")
    u_obj_dequan_mul.io.A <> u_obj_dequan_add.io.S
    u_obj_dequan_mul.io.B <> io.scale
    u_obj_dequan_mul.io.P <> io.obj_data_dequan

    val u_cls_dequan_add = AddSub(8, 16, 16, AddSubConfig.unsigned, AddSubConfig.signed, 1, AddSubConfig.lut, this.clockDomain, AddSubConfig.subtract, "cls_dequan_add")
    u_cls_dequan_add.io.A <> io.cls_data
    u_cls_dequan_add.io.B <> io.zp


    val u_cls_dequan_mul = Mul(16, 16, 32, MulConfig.signed, MulConfig.unsigned, 3, MulConfig.dsp, this.clockDomain, "cls_dequan_mul")
    u_cls_dequan_mul.io.A <> u_cls_dequan_add.io.S
    u_cls_dequan_mul.io.B <> io.scale
    u_cls_dequan_mul.io.P <> io.cls_data_dequan

}

object DeQuant extends App {
    val clkCfg = ClockDomainConfig(resetKind = SYNC, resetActiveLevel = LOW) // 同步低电平复位
    SpinalConfig(
        headerWithDate = true,
        oneFilePerComponent = false,
        targetDirectory = filePath, // 文件生成路径
        defaultConfigForClockDomains = clkCfg
    ).generateVerilog(new DeQuant(PocessingConfig(8, 16)))
}
