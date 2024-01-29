package conv.compute

import conv.compute.activation.LeakyRelu
import spinal.core._
import spinal.lib._
import wa.xip._
import wa.xip.math.{AddSub, AddSubConfig, Mul, MulConfig}

class Quan(convConfig: ConvConfig) extends Component {
    val io = new Bundle {
        val dataIn = in Vec(SInt(convConfig.addChannelTimesWidth bits), convConfig.COMPUTE_CHANNEL_OUT_NUM)
        val biasIn = in UInt (convConfig.QUAN_M_DATA_WIDTH bits)
        val scaleIn = in UInt (convConfig.QUAN_M_DATA_WIDTH bits)
        val shiftIn = in UInt (convConfig.QUAN_M_DATA_WIDTH bits)
        val zeroIn = in UInt (8 bits)
        val activationEn = in Bool()
        val dataOut = out UInt (convConfig.COMPUTE_CHANNEL_OUT_NUM * 8 bits)
        val amendReg = in Bits (32 bits)
    }
    noIoPrefix()
    val bias = new Bias(convConfig)
    bias.port.dataIn <> RegNext(io.dataIn, init = Vec(S(0).resized, convConfig.COMPUTE_CHANNEL_OUT_NUM))
    bias.port.quan <> io.biasIn.subdivideIn(convConfig.COMPUTE_CHANNEL_OUT_NUM slices)

    val scale = new Scale(convConfig)
    scale.port.dataIn <> bias.port.dataOut
    scale.port.quan <> Delay(io.scaleIn.subdivideIn(convConfig.COMPUTE_CHANNEL_OUT_NUM slices), 2, init = Vec(U(0).resized, convConfig.COMPUTE_CHANNEL_OUT_NUM))

    val shift = new Shift(convConfig)
    shift.port.dataIn <> scale.port.dataOut
    shift.port.quan <> Delay(io.shiftIn.subdivideIn(convConfig.COMPUTE_CHANNEL_OUT_NUM slices), 10 + 1, init = Vec(U(0).resized, convConfig.COMPUTE_CHANNEL_OUT_NUM))

    val zero = new Zero(convConfig)
    zero.io.dataIn <> shift.port.dataOut
    zero.io.quan <> io.zeroIn

    val leakyRelu = new LeakyRelu(convConfig)
    leakyRelu.io.dataIn <> zero.io.dataOut
    leakyRelu.io.quanZero <> io.zeroIn
    leakyRelu.io.amendReg <> io.amendReg
    when(io.activationEn) {
        io.dataOut.subdivideIn(convConfig.COMPUTE_CHANNEL_OUT_NUM slices) <> leakyRelu.io.dataOut
    } otherwise {
        io.dataOut.subdivideIn(convConfig.COMPUTE_CHANNEL_OUT_NUM slices) <> zero.io.dataOut
    }


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


    val port = QuanSubPort(convConfig, 32, 32, 48).setName("Bias")
    val dataInTemp = Vec(Reg(SInt(48 bits)) init(0), convConfig.COMPUTE_CHANNEL_OUT_NUM)
    val biasInTemp = Vec(Reg(UInt(48 bits)) init(0), convConfig.COMPUTE_CHANNEL_OUT_NUM)
    (0 until convConfig.COMPUTE_CHANNEL_OUT_NUM).foreach(i => {
        dataInTemp(i) := port.dataIn(i) @@ S"16'd0"
        biasInTemp(i) := (S(port.quan(i)(31)).resize(8 bits) @@ port.quan(i)(23 downto 0) @@ U(0, 16 bits) >> port.quan(i)(30 downto(24))).asUInt
    })
    val biasAdd = Array.tabulate(convConfig.COMPUTE_CHANNEL_OUT_NUM)(i => {
        def gen = {
            val add = AddSub(48, 48, 48, AddSubConfig.signed, AddSubConfig.unsigned, 1, AddSubConfig.lut, this.clockDomain, AddSubConfig.add, "biasAdd", i == 0)
            add.io.A <> dataInTemp(i)
            add.io.B <> biasInTemp(i)
            add.io.S <> port.dataOut(i)
        }

        gen
    })
}
//object Bias extends App {
//    SpinalVerilog(new Bias(ConvConfig(8, 8, 8, 12, 8192, 512, 10, 2048, 1, ConvType.conv33)))
//}

class Scale(convConfig: ConvConfig) extends Component {
    val port = QuanSubPort(convConfig, 48, 32, 32).setName("Scale")
    val scaleMulOut = Vec(SInt(32 bits), convConfig.COMPUTE_CHANNEL_OUT_NUM)
    val scaleMul = Array.tabulate(convConfig.COMPUTE_CHANNEL_OUT_NUM)(i => {
        def gen = {
            val mul = Mul(48, 32, 32, MulConfig.signed, MulConfig.unsigned, 8, MulConfig.dsp, this.clockDomain, "scaleMul", 79, 48, i == 0)
            mul.io.A <> port.dataIn(i)
            mul.io.B <> port.quan(i)
            mul.io.P <> scaleMulOut(i)
        }

        gen
    })

    //    def <<(in: SInt): SInt = {
    //        val out = Reg(SInt(32 bits))
    //        when(in(0)){
    //            out := in(32 downto 1) + 1
    //        } otherwise {
    //            out := in(32 downto 1)
    //        }
    //        out
    //    }
    (0 until convConfig.COMPUTE_CHANNEL_OUT_NUM).foreach(i => {
        port.dataOut(i) := RegNext(scaleMulOut(i)) init(0)
    })

}

class Shift(convConfig: ConvConfig) extends Component {
    val port = QuanSubPort(convConfig, 32, 32, 16).setName("shift")

    def <<(in: SInt, sh: UInt): SInt = {
        val dataTemp = SInt(32 bits)
        dataTemp := in >> sh
        val out = Reg(SInt(16 bits)) init 0
        when(dataTemp(0)) {
            out := (dataTemp.sign.asSInt @@ dataTemp(15 downto 1)) + 1
        } otherwise {
            out := dataTemp.sign.asSInt @@ dataTemp(15 downto 1)
        }
        out
    }

    (0 until convConfig.COMPUTE_CHANNEL_OUT_NUM).foreach { i =>
        port.dataOut(i) := <<(port.dataIn(i), port.quan(i))
    }

}
object Shift extends App {
    SpinalVerilog(new Shift(ConvConfig(8, 16, 16, 12, 4096, 512, 640, 4096, 1)))
}


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

    val normalData = Vec(Reg(UInt(8 bits)) init(0), convConfig.COMPUTE_CHANNEL_OUT_NUM)
    io.dataOut := normalData
    (0 until convConfig.COMPUTE_CHANNEL_OUT_NUM).foreach(i => {
        when(addZeroTemp(i).sign) {
            normalData(i) := 0
        } elsewhen (addZeroTemp(i) > 255) {
            normalData(i) := 255
        } otherwise {
            normalData(i) := addZeroTemp(i).asUInt.resized
        }
    })
}
//object Zero extends App {
//    SpinalVerilog(new Zero(ConvConfig(8, 8, 8, 12, 8192, 512, 10, 2048, 1, ConvType.conv33)))
//}

