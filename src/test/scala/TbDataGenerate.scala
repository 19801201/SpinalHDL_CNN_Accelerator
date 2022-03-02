//import com.google.gson.JsonParser
//import conv.dataGenerate.{DataGenerate, DataGenerateConfig, PaddingConfig}
//import spinal.core.sim._
//import spinal.core.{ClockDomainConfig, FixedFrequency, HIGH, IntToBuilder, SYNC, SpinalConfig}
//
//import java.io.{File, PrintWriter}
//import scala.io.Source
//import scala.util.Random
////case class TestPaddingConfig(enPadding: Boolean, channelIn: Int, rowNumIn: Int, colNumIn: Int, zeroDara: Int, zeroNum: Int) {
////
////}
//
//class TbDataGenerate(dataGenerateConfig: DataGenerateConfig, testPaddingConfig: TestPaddingConfig) extends DataGenerate(dataGenerateConfig) {
//    def toHexString(width: Int, b: BigInt): String = {
//        var s = b.toString(16)
//        if (s.length < width) {
//            s = "0" * (width - s.length) + s
//        }
//        s
//    }
//
//    def init() = {
//        clockDomain.forkStimulus(5)
//        clockDomain.forkSimSpeedPrinter()
//        io.sData.valid #= false
//        io.sData.payload #= 0
//        for (i <- 0 until 9) {
//            io.mData(i).ready #= false
//        }
//        io.enPadding #= testPaddingConfig.enPadding
//        io.channelIn #= testPaddingConfig.channelIn
//        io.rowNumIn #= testPaddingConfig.rowNumIn
//        io.colNumIn #= testPaddingConfig.colNumIn
//        io.zeroDara #= testPaddingConfig.zeroDara
//        io.zeroNum #= testPaddingConfig.zeroNum
//        io.start #= false
//        clockDomain.waitSampling(10)
//
//    }
//
//    def in(src: String): Unit = {
//        fork {
//            for (line <- Source.fromFile(src).getLines) {
//                //                println(line)
//                io.sData.payload #= BigInt(line.trim, 16)
//                io.sData.valid #= true
//                clockDomain.waitSamplingWhere(io.sData.ready.toBoolean)
//            }
//        }
//    }
//    def assignMready={
//        fork {
//            while (!io.last.toBoolean) {
//                clockDomain.waitSampling()
//                val b = Random.nextBoolean()
//                for (i <- 0 until (9)) {
//                    io.mData(i).ready #= b
//                }
//            }
//
//        }
//    }
//
//    def out(dst_scala: String, dst: String, index: Int): Unit = {
//
//        val testFile = new PrintWriter(new File(dst_scala))
//        val dstFile = Source.fromFile(dst).getLines().toArray
//        val total = dstFile.length
//        var error = 0
//        var iter = 0
//
//
//        fork {
//            while (!io.last.toBoolean) {
//                clockDomain.waitSampling()
//                if (io.mData(index).ready.toBoolean && io.mData(index).valid.toBoolean) {
//                    io.start #= false
//                    val temp = dstFile(iter)
//                    val o = toHexString(dataGenerateConfig.COMPUTE_CHANNEL_NUM << 1, io.mData(index).payload.toBigInt)
//                    if (!temp.equals(o)) {
//                        error = error + 1
//                    }
//                    if (iter % 10000 == 0) {
//                        val errorP = error * 100.0 / total
//                        println(s"file $index total iter = $total current iter =  $iter :::  error count = $error error percentage = $errorP%")
//                    }
//                    testFile.write(o + "\r\n")
//                    iter = iter + 1
//                }
//            }
//            sleep(300)
//            testFile.close()
//            if(index == 8){
//                sleep(300)
//                simSuccess()
//            }
//
//        }
//    }
//
//    def outPadding(dst: String): Unit = {
//        val testFile = new PrintWriter(new File(dst))
//        fork {
//            while (!io.last.toBoolean) {
//                clockDomain.waitSampling()
//                if (padding.io.mData.valid.toBoolean && padding.io.mData.ready.toBoolean) {
//                    val o = toHexString(dataGenerateConfig.COMPUTE_CHANNEL_NUM << 1, padding.io.mData.payload.toBigInt)
//                    testFile.write(o + "\r\n")
//                }
//            }
//            sleep(300)
//            testFile.close()
//        }
//
//
//    }
//
//}
//
//object TbDataGenerate {
//    def main(args: Array[String]): Unit = {
//        val json = Source.fromFile("G:/SpinalStudy/simData/config.json").mkString
//        val jsonP = new JsonParser().parse(json)
//        val enPadding = jsonP.getAsJsonObject.get("paddingSim").getAsJsonObject.get("enPadding").getAsBoolean
//        val channelIn = jsonP.getAsJsonObject.get("paddingSim").getAsJsonObject.get("channelIn").getAsInt
//        val zeroDara = jsonP.getAsJsonObject.get("paddingSim").getAsJsonObject.get("zeroDara").getAsInt
//        val zeroNum = jsonP.getAsJsonObject.get("paddingSim").getAsJsonObject.get("zeroNum").getAsInt
//        val COMPUTE_CHANNEL_NUM = jsonP.getAsJsonObject.get("total").getAsJsonObject.get("COMPUTE_CHANNEL_NUM").getAsInt
//        val DATA_WIDTH = jsonP.getAsJsonObject.get("total").getAsJsonObject.get("DATA_WIDTH").getAsInt
//
//        val CHANNEL_WIDTH = jsonP.getAsJsonObject.get("total").getAsJsonObject.get("CHANNEL_WIDTH").getAsInt
//        val FEATURE_WIDTH = jsonP.getAsJsonObject.get("total").getAsJsonObject.get("FEATURE_WIDTH").getAsInt
//        val src_py = jsonP.getAsJsonObject.get("paddingSim").getAsJsonObject.get("src_py").getAsString
//        val dst_scala = jsonP.getAsJsonObject.get("paddingSim").getAsJsonObject.get("dst_scala").getAsString
//        val dst = jsonP.getAsJsonObject.get("featureGenerateSim").getAsJsonObject.get("dst_py").getAsString
//        val rowNumIn = jsonP.getAsJsonObject.get("paddingSim").getAsJsonObject.get("rowNumIn").getAsInt
//        val colNumIn = jsonP.getAsJsonObject.get("paddingSim").getAsJsonObject.get("colNumIn").getAsInt
//        val dataScala = jsonP.getAsJsonObject.get("featureGenerateSim").getAsJsonObject.get("dst_scala").getAsString
//
//        val paddingConfig = PaddingConfig(DATA_WIDTH, CHANNEL_WIDTH, COMPUTE_CHANNEL_NUM, FEATURE_WIDTH, zeroNum)
//        val testPaddingConfig = TestPaddingConfig(enPadding, channelIn, rowNumIn, colNumIn, zeroDara, zeroNum)
//
//        val dataGenerateConfig = DataGenerateConfig(DATA_WIDTH, CHANNEL_WIDTH, COMPUTE_CHANNEL_NUM, FEATURE_WIDTH, 9, 12, zeroNum)
//
//
//        val testFile = (0 until 9).map(i => dataScala + i + ".txt")
//        val dstFile = (0 until 9).map(i => dst + "d" + i + ".txt")
//
//
//        val spinalConfig = new SpinalConfig(
//            defaultClockDomainFrequency = FixedFrequency(200 MHz),
//            defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH, resetKind = SYNC)
//        )
//        SimConfig.withWave.withConfig(spinalConfig).compile(new TbDataGenerate(dataGenerateConfig, testPaddingConfig)).doSimUntilVoid { dut =>
//
//
//            dut.init
//            dut.io.start #= true
//            for (i <- 0 until 9) {
//                dut.io.mData(i).ready #= true
//            }
//            dut.in(src_py)
//            dut.assignMready
//            dut.out(testFile(0), dstFile(0),0)
//            dut.out(testFile(1), dstFile(1),1)
//            dut.out(testFile(2), dstFile(2),2)
//            dut.out(testFile(3), dstFile(3),3)
//            dut.out(testFile(4), dstFile(4),4)
//            dut.out(testFile(5), dstFile(5),5)
//            dut.out(testFile(6), dstFile(6),6)
//            dut.out(testFile(7), dstFile(7),7)
//            dut.out(testFile(8), dstFile(8),8)
//            dut.outPadding(dst_scala)
//        }
//    }
//
//}
