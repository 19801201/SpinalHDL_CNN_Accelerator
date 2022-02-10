package conv.compute.activation

import conv.compute.ConvConfig
import spinal.core._
import spinal.lib._
import wa.xip.math.MulConfig
import wa.xip.math.{Mul, MulConfig}

class LeakyRelu(convConfig: ConvConfig) extends Component {
    val io = new Bundle {
        val dataIn = in Vec(SInt(16 bits), convConfig.COMPUTE_CHANNEL_OUT_NUM)
        val dataOut = out Vec(SInt(16 bits), convConfig.COMPUTE_CHANNEL_OUT_NUM)
    }
    noIoPrefix()

    val leaky = U((convConfig.leakyRatio * scala.math.pow(2, 18)).toInt, 16 bits)
    val midHigh = U((0.51 * scala.math.pow(2, 18)).toInt, 18 bits)
    val midLow = U((0.49 * scala.math.pow(2, 18)).toInt, 18 bits)

    def <<(in: SInt, genTcl: Boolean): SInt = {
        val out = Reg(SInt(16 bits))

        val mulTemp = SInt(32 bits)
        val mantissa = mulTemp(17 downto 0)
        val odd = (mulTemp >> 18) + 1
        val even = mulTemp >> 18
        val mul = Mul(16, 16, 32, MulConfig.signed, MulConfig.unsigned, 3, MulConfig.dsp, this.clockDomain, "leakyReluMul", genTcl)
        mul.io.A <> in
        mul.io.B <> leaky
        mul.io.P <> mulTemp

        val srcTemp = Delay(in, 3)
        when(!srcTemp.sign) {
            out := srcTemp
        } otherwise {
            when(mantissa.asUInt >= midHigh) {
                out := odd.resized
            } elsewhen (mantissa.asUInt <= midLow) {
                out := even.resized
            } otherwise {
                when(mulTemp(18)) {
                    out := odd.resized
                } otherwise {
                    out := even.resized
                }
            }
        }

        out
    }

    (0 until convConfig.COMPUTE_CHANNEL_OUT_NUM).foreach(i => {
        io.dataOut(i) := <<(io.dataIn(i), i == 0)
    })
}

//object LeakyRelu extends App {
//    SpinalVerilog(new LeakyRelu(ConvConfig(8, 8, 8, 12, 8192, 512, 10, 2048, 1, ConvType.conv33)))
//}
