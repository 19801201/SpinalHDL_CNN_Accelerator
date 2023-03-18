import conv.compute.ConvConfig
import conv.compute.activation.LeakyRelu
import spinal.core._
import spinal.core.sim._

import java.io.{File, PrintWriter}
import scala.collection.mutable.ArrayBuffer
import scala.io.Source
import scala.util.control.Breaks.break

class TbLeakyRelu extends LeakyRelu(ConvConfig(8, 8, 4, 12, 8192, 512, 10, 2048, 1)){
  def toHexString(width: Int, b: BigInt): String = {
    var s = b.toString(16)
    if (s.length < width) {
      s = "0" * (width - s.length) + s
    }
    s
  }

  def init = {
    clockDomain.forkStimulus(5000)
    io.quanZero #= BigInt("3f",16)
    io.bias1 #= BigInt("FFC83CE4",16)
    io.bias2 #= BigInt("000960EC",16)
    io.scale1 #= BigInt("0001CBCD",16)
    io.scale2 #= BigInt("00002DFA",16)
    clockDomain.waitSampling(1)
  }

  def in(src: String): Unit = {
    fork {
      for (line <- Source.fromFile(src).getLines) {
        for(i <- 0 to 3){
          io.dataIn(i) #= BigInt(line.trim.substring(i*2,i*2+2), 16)
        }
        clockDomain.waitSampling(1)
      }
    }
  }

  def out(dst_scala: String, dst: String): Unit = {
    val testFile = new PrintWriter(new File(dst_scala))
    val dstFile = Source.fromFile(dst).getLines().toArray
    val total = dstFile.length
    var error = 0
    var iter = 0
    var i = 0
    clockDomain.waitSampling(10)
    while (i < dstFile.length) {
      clockDomain.waitSampling(1)
      i = i + 1
      val temp = dstFile(iter)
      var o = ""
      for (i <- 0 to 3){
        o += toHexString(2, io.dataOut(i).toBigInt)
      }
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
    if (error > 0) {
      println(s"error is $error\n")
    } else {
      println(s"ac\n")
    }

    sleep(1000)
    testFile.close()
    simSuccess()
  }
}

object TbLeakyRelu extends App {
  val spinalConfig = new SpinalConfig(
    defaultClockDomainFrequency = FixedFrequency(200 MHz),
    defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH, resetKind = SYNC)
  )
  SimConfig.withXSimSourcesPaths(ArrayBuffer("src/test/ip"), ArrayBuffer(""))
    .withXSim.withWave.withConfig(spinalConfig).compile(new TbLeakyRelu()).doSimUntilVoid { dut =>
    dut.init

    dut.in("src/test/coe/before_leakyrelu_test.coe")

    dut.out("src/test/coe/result.txt", "src/test/coe/leakyrelu_test.coe")
  }

//  var j = 0;
//  for (line <- Source.fromFile("C:\\Users\\86136\\Desktop\\SpinalHDL_CNN_Accelerator\\src\\test\\coe\\leakyrelu_test.coe").getLines) {
//    for (i <- 0 to 3) {
//      println(BigInt(line.trim.substring(i * 2, i * 2 + 2), 16))
//    }
//    j = j + 1
//    if (j == 3){
//      break
//    }
//  }
}
