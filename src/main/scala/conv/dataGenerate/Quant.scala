package conv.dataGenerate

import spinal.core._
import spinal.lib._
import config.Config._
import conv.compute.ConvConfig
import wa.xip.math.{AddSub, AddSubConfig, Mul, MulConfig}

import java.io.File

class Quant(convConfig: ConvConfig) extends Component {
    val sDataWidth = if (imageType.dataType == imageType.rgb) {
        4 * convConfig.DATA_WIDTH
    } else if (imageType.dataType == imageType.gray) {
        1 * convConfig.DATA_WIDTH
    } else {
        assert(false, "imageType不正确");
        0
    }

    val io = new Bundle {
        val scale = in UInt (32 bits)
        val zp = in UInt (32 bits)
        val sData = slave Stream (UInt(sDataWidth bits))
        val mData = master Stream (UInt(sDataWidth bits))
    }
    val quan_result = UInt(8 bits)

    val mul = Mul(sDataWidth, 32, 40, MulConfig.unsigned, MulConfig.unsigned, 4, MulConfig.dsp, this.clockDomain, "quan_mul")
    mul.io.A <> io.sData.payload
    mul.io.B <> io.scale

    val add = AddSub(40, 32, 40, AddSubConfig.unsigned, AddSubConfig.unsigned, 1, AddSubConfig.lut, this.clockDomain, AddSubConfig.add, "quan_add")
    add.io.A <> mul.io.P
    add.io.B <> io.zp
    add.io.S(24 downto (17)) <> quan_result


    val quan_fifo = StreamFifo(UInt(8 bits), 20)
    quan_fifo.io.push.payload <> quan_result
    quan_fifo.io.push.valid <> Delay(io.sData.fire, 5, init = False)

    io.sData.ready := quan_fifo.io.availability > 5
    io.mData <> quan_fifo.io.pop
}

object Quant extends App {
    val clkCfg = ClockDomainConfig(resetKind = SYNC, resetActiveLevel = LOW) // 同步低电平复位
    SpinalConfig(
        headerWithDate = true,
        oneFilePerComponent = false,
        targetDirectory = filePath, // 文件生成路径
        defaultConfigForClockDomains = clkCfg
    ).generateVerilog(new Quant(ConvConfig(8, 8, 8, 12, 8192, 512, 416, 2048, 1)))
}
