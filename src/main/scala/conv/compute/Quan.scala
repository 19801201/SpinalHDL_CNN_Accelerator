package conv.compute

import conv.compute.activation.LeakyRelu
import spinal.core._
import spinal.lib._
import wa.xip._

class Quan(convConfig: ConvConfig) extends Component {
    val io = new Bundle {
        val dataIn = in Vec(SInt(convConfig.addChannelTimesWidth bits), convConfig.COMPUTE_CHANNEL_OUT_NUM)
        val biasIn = in UInt (convConfig.QUAN_M_DATA_WIDTH bits)
        val scaleIn = in UInt (convConfig.QUAN_M_DATA_WIDTH bits)
        val shiftIn = in UInt (convConfig.QUAN_M_DATA_WIDTH bits)
        val zeroIn = in UInt (8 bits)
        val activationEn = in Bool()
        val dataOut = out UInt (convConfig.COMPUTE_CHANNEL_OUT_NUM * 8 bits)
    }
    noIoPrefix()
    val bias = new Bias(convConfig)
    bias.port.dataIn <> io.dataIn
    bias.port.quan <> io.biasIn.subdivideIn(convConfig.COMPUTE_CHANNEL_OUT_NUM slices)

    val scale = new Scale(convConfig)
    scale.port.dataIn <> bias.port.dataOut
    scale.port.quan <> io.scaleIn.subdivideIn(convConfig.COMPUTE_CHANNEL_OUT_NUM slices)

    val shift = new Shift(convConfig)
    shift.port.dataIn <> scale.port.dataOut
    shift.port.quan <> io.shiftIn.subdivideIn(convConfig.COMPUTE_CHANNEL_OUT_NUM slices)

    val leakyRelu = new LeakyRelu(convConfig)
    leakyRelu.io.dataIn <> shift.port.dataOut

    val zero = new Zero(convConfig)
    when(io.activationEn){
        zero.io.dataIn <> leakyRelu.io.dataOut
    } otherwise{
        zero.io.dataIn <> shift.port.dataOut
    }
    zero.io.quan <> io.zeroIn
    io.dataOut.subdivideIn(convConfig.COMPUTE_CHANNEL_OUT_NUM slices) <> zero.io.dataOut
}
//object Quan extends App {
//    SpinalVerilog(new Quan(ConvConfig(8, 8, 8, 12, 8192, 512, 10, 2048, 1, ConvType.conv33)))
//}

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


class Zero(convConfig: ConvConfig) extends Component {
    val io = new Bundle {
        val dataIn = in Vec(SInt(16 bits), convConfig.COMPUTE_CHANNEL_OUT_NUM)
        val quan = in UInt (8 bits)
        val dataOut = out Vec(UInt(8 bits), convConfig.COMPUTE_CHANNEL_OUT_NUM)
    }
    noIoPrefix()
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
        } elsewhen (addZeroTemp(i) >= 255) {
            normalData(i) := 255
        } otherwise {
            normalData(i) := addZeroTemp(i).asUInt.resized
        }
    })
}
//object Zero extends App {
//    SpinalVerilog(new Zero(ConvConfig(8, 8, 8, 12, 8192, 512, 10, 2048, 1, ConvType.conv33)))
//}

