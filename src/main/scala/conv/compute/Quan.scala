package conv.compute

import spinal.core._
import spinal.lib._
import wa.xip._

class Quan(convConfig: ConvConfig) extends Component {

}


case class QuanSubPort(convConfig: ConvConfig, inWidth: Int, quanWidth: Int, outWidth: Int) extends Bundle {
    val dataIn = in Vec(SInt(inWidth bits), convConfig.COMPUTE_CHANNEL_OUT_NUM)
    val quan = in Vec(UInt(quanWidth bits), convConfig.COMPUTE_CHANNEL_OUT_NUM)
    val dataOut = out Vec(SInt(outWidth bits), convConfig.COMPUTE_CHANNEL_OUT_NUM)
}

class Bias(convConfig: ConvConfig) extends Component {


    val port = QuanSubPort(convConfig, 32, 32, 32).setName("Bias")
    val biasAdd = Array.tabulate(convConfig.COMPUTE_CHANNEL_OUT_NUM)(i => {
        def gen = {
            val add = AddSub(32, 32, 32, AddSubConfig.signed, AddSubConfig.unsigned, 1, AddSubConfig.lut, this.clockDomain, AddSubConfig.add, "biasAdd", i == 0)
            add.io.A <> port.dataIn(i)
            add.io.B <> port.quan(i)
            add.io.S <> port.dataOut(i)
        }

        gen
    })
}
//object Bias extends App {
//    SpinalVerilog(new Bias(ConvConfig(8, 8, 8, 12, 8192, 512, 10, 2048, 1, ConvType.conv33)))
//}

class Scale(convConfig: ConvConfig) extends Component {
    val port = QuanSubPort(convConfig, 32, 32, 32).setName("Scale")
    val scaleMul = Array.tabulate(convConfig.COMPUTE_CHANNEL_OUT_NUM)(i => {
        def gen = {
            val mul = Mul(32, 32, 32, MulConfig.signed, MulConfig.unsigned, 3, MulConfig.dsp, this.clockDomain, "scaleMul", 63, 32, i == 0)
            mul.io.A <> port.dataIn(i)
            mul.io.B <> port.quan(i)
            mul.io.P <> port.dataOut(i)
        }

        gen
    })
}

class Shift(convConfig: ConvConfig) extends Component {
    val port = QuanSubPort(convConfig, 32, 32, 16).setName("shift")

    def <<(in: SInt, sh: UInt): SInt = {
        val dataTemp = SInt(32 bits)
        dataTemp := in >> sh
        val out = Reg(SInt(16 bits))
        when(dataTemp(0)) {
            out := dataTemp.sign.asSInt @@ (dataTemp(15 downto 1) + 1)
        } otherwise {
            out := dataTemp.sign.asSInt @@ dataTemp(15 downto 1)
        }
        out
    }

    (0 until convConfig.COMPUTE_CHANNEL_OUT_NUM).foreach { i =>
        port.dataOut(i) := <<(port.dataIn(i), port.quan(i))
    }

}
//object Shift extends App {
//    SpinalVerilog(new Shift(ConvConfig(8, 8, 8, 12, 8192, 512, 10, 2048, 1, ConvType.conv33)))
//}

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

class Zero(convConfig: ConvConfig) extends Component {
    val io = new Bundle {
        val dataIn = in Vec(SInt(16 bits), convConfig.COMPUTE_CHANNEL_OUT_NUM)
        val quan = in UInt (8 bits)
        val dataOut = out Vec(UInt(8 bits), convConfig.COMPUTE_CHANNEL_OUT_NUM)
    }
    val addZeroTemp = Vec(SInt(16 bits), convConfig.COMPUTE_CHANNEL_OUT_NUM)
    val addZero = Array.tabulate(convConfig.COMPUTE_CHANNEL_OUT_NUM)(i => {
        def gen = {
            val add = AddSub(16, 8, 16, AddSubConfig.signed, AddSubConfig.unsigned, 1, AddSubConfig.lut, this.clockDomain, AddSubConfig.add, "AddZero", i == 0)
            add.io.A <> io.dataIn(i)
            add.io.B <> io.quan
            add.io.S <> addZeroTemp(i)
            add
        }

        gen
    })

    val normalData = Vec(Reg(UInt(8 bits)), convConfig.COMPUTE_CHANNEL_OUT_NUM)
    io.dataOut := normalData
    (0 until convConfig.COMPUTE_CHANNEL_OUT_NUM).foreach(i => {
        when(addZeroTemp(i).sign) {
            normalData(i) := 0
        } elsewhen(addZeroTemp(i)>=255){
            normalData(i) := 255
        } otherwise{
            normalData(i) := addZeroTemp(i).asUInt.resized
        }
    })
}
//object Zero extends App {
//    SpinalVerilog(new Zero(ConvConfig(8, 8, 8, 12, 8192, 512, 10, 2048, 1, ConvType.conv33)))
//}

