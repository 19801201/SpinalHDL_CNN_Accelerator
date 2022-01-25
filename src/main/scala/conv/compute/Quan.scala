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

class LeakyRelu(convConfig: ConvConfig) extends Component{

}
