import com.google.gson._
import conv.dataGenerate.{Padding, PaddingConfig}
import spinal.core._
import spinal.core.sim._

import java.io.{File, PrintWriter}
import scala.io.Source


case class TestPaddingConfig(enPadding: Boolean, channelIn: Int, rowNumIn: Int, colNumIn: Int, zeroDara: Int, zeroNum: Int) {

}


class TestPadding(paddingConfig: PaddingConfig, testPaddingConfig: TestPaddingConfig) extends Padding(paddingConfig) {

    def toHexString(width: Int, b: BigInt): String = {
        var s = b.toString(16)
        if (s.length < width) {
            s = "0" * (width - s.length) + s
        }
        s
    }

    def init: Unit = {
        clockDomain.forkStimulus(5)
        //        clockDomain.forkSimSpeedPrinter()
        io.sData.valid #= false
        io.sData.payload #= 0
        io.mData.ready #= false
        io.start #= false
        io.enPadding #= testPaddingConfig.enPadding
        io.channelIn #= testPaddingConfig.channelIn
        io.rowNumIn #= testPaddingConfig.rowNumIn
        io.colNumIn #= testPaddingConfig.colNumIn
        io.zeroDara #= testPaddingConfig.zeroDara
        io.zeroNum #= testPaddingConfig.zeroNum
        clockDomain.waitSampling(10)
    }


    def in(src: String): Unit = {
        fork {
            for (line <- Source.fromFile(src).getLines) {
                io.sData.payload #= BigInt(line.trim, 16)
                io.sData.valid #= true
                clockDomain.waitSamplingWhere(io.sData.ready.toBoolean)
            }
        }


    }

    def out(dst_scala: String, dst: String): Unit = {

        val testFile = new PrintWriter(new File(dst_scala))
        val dstFile = Source.fromFile(dst).getLines().toArray
        val total = dstFile.length
        var error = 0
        var iter = 0
        while (!io.last.toBoolean) {
            clockDomain.waitSampling()
            //io.mData.ready.randomize()
            io.mData.ready #= true
            if (io.mData.valid.toBoolean && io.mData.ready.toBoolean) {

                io.start #= false
                val temp = dstFile(iter)
                val o = toHexString(paddingConfig.COMPUTE_CHANNEL_NUM << 1, io.mData.payload.toBigInt)

                if (!temp.equals(o)) {
                    error = error + 1
                }
                if (iter % 10000 == 0) {
                    val errorP = error * 100.0 / total
                    println(s"total iter = $total current iter =  $iter :::  error count = $error error percentage = $errorP%")
                }
                testFile.write(o + "\r\n")
                iter = iter + 1
            }
        }
        sleep(100)
        testFile.close()
        simSuccess()
    }
}

object TestPadding {


    def main(args: Array[String]): Unit = {

        val json = Source.fromFile("G:/SpinalStudy/simData/config.json").mkString
        val jsonP = new JsonParser().parse(json)
        val enPadding = jsonP.getAsJsonObject.get("paddingSim").getAsJsonObject.get("enPadding").getAsBoolean
        val channelIn = jsonP.getAsJsonObject.get("paddingSim").getAsJsonObject.get("channelIn").getAsInt
        val zeroDara = jsonP.getAsJsonObject.get("paddingSim").getAsJsonObject.get("zeroDara").getAsInt
        val zeroNum = jsonP.getAsJsonObject.get("paddingSim").getAsJsonObject.get("zeroNum").getAsInt
        val COMPUTE_CHANNEL_NUM = jsonP.getAsJsonObject.get("total").getAsJsonObject.get("COMPUTE_CHANNEL_NUM").getAsInt
        val DATA_WIDTH = jsonP.getAsJsonObject.get("total").getAsJsonObject.get("DATA_WIDTH").getAsInt
        // val PICTURE_NUM = jsonP.getAsJsonObject.get("padding").getAsJsonObject.get("PICTURE_NUM").getAsInt
        //        val PICTURE_NUM = 1
        val CHANNEL_WIDTH = jsonP.getAsJsonObject.get("total").getAsJsonObject.get("CHANNEL_WIDTH").getAsInt
        val FEATURE_WIDTH = jsonP.getAsJsonObject.get("total").getAsJsonObject.get("FEATURE_WIDTH").getAsInt
        val src_py = jsonP.getAsJsonObject.get("paddingSim").getAsJsonObject.get("src_py").getAsString
        val dst_scala = jsonP.getAsJsonObject.get("paddingSim").getAsJsonObject.get("dst_scala").getAsString
        val dst = jsonP.getAsJsonObject.get("paddingSim").getAsJsonObject.get("dst_py").getAsString
        val rowNumIn = jsonP.getAsJsonObject.get("paddingSim").getAsJsonObject.get("rowNumIn").getAsInt
        val colNumIn = jsonP.getAsJsonObject.get("paddingSim").getAsJsonObject.get("colNumIn").getAsInt


        val paddingConfig = PaddingConfig(DATA_WIDTH, CHANNEL_WIDTH, COMPUTE_CHANNEL_NUM, FEATURE_WIDTH, zeroNum)
        val testPaddingConfig = TestPaddingConfig(enPadding, channelIn, rowNumIn, colNumIn, zeroDara, zeroNum)


        val spinalConfig = new SpinalConfig(
            defaultClockDomainFrequency = FixedFrequency(200 MHz),
            defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH, resetKind = SYNC)
        )
        SimConfig.withWave.withConfig(spinalConfig).compile(new TestPadding(paddingConfig, testPaddingConfig)).doSimUntilVoid { dut =>
            dut.init
            dut.io.start #= true

            dut.in(src_py)
            dut.out(dst_scala, dst)
        }
    }
}
