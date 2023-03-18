package conv.compute.activation

import conv.compute.{ConvConfig, ConvType}
import spinal.core._
import spinal.core.sim.SimDataPimper
import spinal.lib._
import wa.xip.math.{AddSub, AddSubConfig, Mul, MulConfig}

class LeakyRelu(convConfig: ConvConfig) extends Component {
    val io = new Bundle {
        val dataIn = in Vec(UInt(8 bits), convConfig.COMPUTE_CHANNEL_OUT_NUM)
        val quanZero = in UInt (8 bits)
        val bias1 = in UInt (32 bits)
        val bias2 = in UInt (32 bits)
        val scale1 = in UInt (32 bits)
        val scale2 = in UInt (32 bits)
        val dataOut = out Vec(UInt(8 bits), convConfig.COMPUTE_CHANNEL_OUT_NUM)
    }
    noIoPrefix()

    def <<(in: UInt, genTcl: Boolean): UInt = {
        val out = Reg(UInt(8 bits))
        val mulOut = SInt(64 bits)  simPublic()
        val addOut = SInt(32 bits)  simPublic()
        val inTemp = (U"8'd0" @@ in @@ U"16'd0").asSInt simPublic()

        val bia = UInt(32 bits) simPublic()
        val scale = UInt(32 bits)   simPublic()

        when(in >= io.quanZero){
            bia := io.bias1
            scale := io.scale1
        }otherwise{
            bia := io.bias2
            scale := io.scale2
        }

        val addBias = AddSub(32, 32, 32, AddSubConfig.signed, AddSubConfig.unsigned, 2, AddSubConfig.dsp, this.clockDomain, AddSubConfig.add, "leakyReluAdd", genTcl)
        addBias.io.A <> inTemp
        addBias.io.B <> bia
        addBias.io.S <> addOut


        val mul = Mul(32, 32, 64, MulConfig.signed, MulConfig.unsigned, 3 + 3, MulConfig.dsp, this.clockDomain, "leakyReluMul", 63, 0, genTcl)
        mul.io.A <> addOut
        mul.io.B <> Delay(scale, 2)
        mul.io.P <> mulOut

        val temp32 = Reg(SInt(32 bits))
        when(mulOut(31)) {
            temp32 := mulOut(63 downto 32) + 1
        } otherwise {
            temp32 := mulOut(63 downto 32)
        }

        when(temp32.sign){
            out := 0
        } elsewhen (temp32 > 255) {
            out := 255
        } otherwise {
            out := temp32(7 downto 0).asUInt
        }

        out
    }

    (0 until convConfig.COMPUTE_CHANNEL_OUT_NUM).foreach(i => {
        io.dataOut(i) := <<(io.dataIn(i), i == 0)
    })
}

object LeakyRelu extends App {
    SpinalVerilog(new LeakyRelu(ConvConfig(8, 8, 8, 12, 8192, 512, 10, 2048, 1)))
}
