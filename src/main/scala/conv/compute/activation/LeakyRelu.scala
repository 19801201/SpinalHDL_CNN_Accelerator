package conv.compute.activation

import conv.compute.{ConvConfig, ConvType}
import spinal.core._
import spinal.lib._
import wa.xip.math.{AddSub, AddSubConfig, Mul, MulConfig}

class LeakyRelu(convConfig: ConvConfig) extends Component {
    val io = new Bundle {
        val dataIn = in Vec(UInt(8 bits), convConfig.COMPUTE_CHANNEL_OUT_NUM)
        val quanZero = in UInt (8 bits)
        val amendReg = in Bits (32 bits)
        val dataOut = out Vec(UInt(8 bits), convConfig.COMPUTE_CHANNEL_OUT_NUM)
    }
    noIoPrefix()

    val leaky = U((convConfig.leakyRatio * scala.math.pow(2, 17)).toInt, 16 bits)
    // val midHigh = U((0.501 * scala.math.pow(2, 17)).toInt, 17 bits)
    val midLow = U((0.5 * scala.math.pow(2, 17)).toInt, 17 bits)

    def <<(in: UInt, genTcl: Boolean): UInt = {
        val out = Reg(UInt(8 bits))
        val mulOut = Reg(SInt(16 bits))

        val subOut = SInt(16 bits)
        val inTemp = (U"8'd0" @@ in).asSInt
        val subZ3 = AddSub(16, 8, 16, AddSubConfig.signed, AddSubConfig.unsigned, 1, AddSubConfig.lut, this.clockDomain, AddSubConfig.subtract, "leakySubZ3", genTcl)
        subZ3.io.A <> inTemp
        subZ3.io.B <> io.quanZero
        subZ3.io.S <> subOut

        val mulTemp = SInt(32 bits)
        val mantissa = mulTemp(16 downto 13)
        val odd = (mulTemp >> 17) + 1
        val even = mulTemp >> 17
        val mul = Mul(16, 16, 32, MulConfig.signed, MulConfig.unsigned, 3, MulConfig.dsp, this.clockDomain, "leakyReluMul", genTcl)
        mul.io.A <> subOut
        mul.io.B <> leaky
        mul.io.P <> mulTemp

        //        val isFive = Bool()
        //        switch(subOut) {
        //            (0 until 10).foreach(i => {
        //                is(-10 * i - 5) {
        //                    isFive := True
        //                }
        //                default {
        //                    isFive := False
        //                }
        //            })
        //        }

        val srcTemp = Delay(subOut, 3)

        //        when(!srcTemp.sign) {
        //            mulOut := srcTemp
        //        } otherwise {
        //            when(mantissa.asUInt >= midHigh) {
        //                mulOut := odd.resized
        //            } elsewhen (mantissa.asUInt <= midLow) {
        //                mulOut := even.resized
        //            } otherwise {
        //                when(mulTemp(18)) {
        //                    mulOut := odd.resized
        //                } otherwise {
        //                    mulOut := even.resized
        //                }
        //            }
        //        }
        //3*3更优
        //        when(!srcTemp.sign) {
        //            mulOut := srcTemp
        //        } otherwise {
        //            when(mantissa.asUInt < midLow) {
        //                mulOut := even.resized
        //            } otherwise {
        //                mulOut := odd.resized
        //            }
        //        }


        //1*1更优
        //        val isFiveDelay = Delay(isFive, 3)
        //        when(!srcTemp.sign) {
        //            mulOut := srcTemp
        //        } elsewhen (isFiveDelay) {
        //            when(mulTemp(17)) {
        //                mulOut := odd.resized
        //            } otherwise {
        //                mulOut := even.resized
        //            }
        //        } otherwise {
        //            when(mantissa.asUInt < midLow) {
        //                mulOut := even.resized
        //            } otherwise {
        //                mulOut := odd.resized
        //            }
        //        }

        when(srcTemp.sign) {
            when(mantissa === 0) {
                mulOut := even.resized
            } elsewhen (mulTemp(17)) {
                when(mulTemp(16)) {
                    mulOut := odd.resized
                } otherwise {
                    mulOut := even.resized
                }
            } otherwise {
                when(mantissa.asUInt > U"4'b1000") {
                    mulOut := odd.resized
                } otherwise {
                    mulOut := even.resized
                }
            }
        } otherwise {
            mulOut := srcTemp
        }

        val amendOut = Reg(SInt(16 bits))

        val list = List(S"16'b1111_1111_1111_1011", S"16'b1111_1111_1111_0001", S"16'b1111_1111_1110_0111", S"16'b1111_1111_1101_1101",
            S"16'b1111_1111_1101_0011", S"16'b1111_1111_1100_1001", S"16'b1111_1111_1011_1111", S"16'b1111_1111_1011_0101",
            S"16'b1111_1111_1010_1011", S"16'b1111_1111_1010_0001", S"16'b1111_1111_1001_0111", S"16'b1111_1111_1000_1101",
            S"16'b1111_1111_1000_0011", S"16'b1111_1111_0111_1001", S"16'b1111_1111_0110_1111", S"16'b1111_1111_0110_0101")
        val srcTempDelay = RegNext(srcTemp)
        when(srcTempDelay.sign){
            switch(srcTempDelay) {
                for (i <- 0 until 16) {
                    is(list(i)){
                        when(io.amendReg((31-i*2) downto (30-i*2))===B"2'b01"){
                            amendOut := mulOut + 1
                        } elsewhen(io.amendReg((31-i*2) downto (30-i*2))===B"2'b10"){
                            amendOut := mulOut - 1
                        } otherwise{
                            amendOut := mulOut
                        }
                    }
                }
                default{
                    amendOut := mulOut
                }
            }
        } otherwise{
            amendOut := mulOut
        }


        val addZ3Out = SInt(16 bits)
        val addZ3 = AddSub(16, 8, 16, AddSubConfig.signed, AddSubConfig.unsigned, 1, AddSubConfig.lut, this.clockDomain, AddSubConfig.add, "leakyAddZ3", genTcl)
        addZ3.io.A <> amendOut
        addZ3.io.B <> io.quanZero
        addZ3.io.S <> addZ3Out

        when(addZ3Out.sign) {
            out := 0
        } elsewhen (addZ3Out > 255) {
            out := 255
        } otherwise {
            out := addZ3Out.asUInt.resized
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
