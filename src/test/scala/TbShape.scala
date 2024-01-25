import spinal.core.sim._
import spinal.core._
import shape._
import TbCfg.Rom

import java.io.{File, PrintWriter}
import scala.collection.mutable.ArrayBuffer
import scala.io.Source
import scala.util.Random

import scala.collection.mutable.ArrayBuffer
case class TbShape() extends Shape(ShapeConfig(8, 8, 640, 12, 4096)){
    def toHexString(width: Int, b: BigInt): String = {
        var s = b.toString(16)
        if (s.length < width) {
            s = "0" * (width - s.length) + s
        }
        s
    }

    def init = {
        clockDomain.forkStimulus(5000)
        io.sData(0).valid #= false
        io.sData(1).valid #= false
        io.sData(0).payload #= 0
        io.sData(1).payload #= 0
        io.control #= 0
        io.introut #= false
        io.instruction(0) #= BigInt("080500A0" , 16)
        io.instruction(1) #= BigInt("00000020" , 16)
        io.instruction(2) #= BigInt("00013D90" , 16)
        io.instruction(3) #= BigInt("00014A12" , 16)
        io.instruction(4) #= BigInt("FFD15116" , 16)
        io.instruction(5) #= BigInt("FFBC0000" , 16)
        io.mData.ready #= false
        clockDomain.waitSampling(10)
        io.control #= 5
    }

    def in(src1: String, src2: String): Unit = {
        val random = new Random()
        fork {
            for (line <- Source.fromFile(src1).getLines) {
                io.sData(0).payload  #= BigInt(line.trim, 16)
                io.sData(0).valid    #= true
                clockDomain.waitSamplingWhere(io.sData(0).valid.toBoolean && io.sData(0).ready.toBoolean)
                io.sData(0).valid    #= false
                val randomInt = random.nextInt(25)
                if(randomInt < 4)  clockDomain.waitSampling(randomInt)
            }
//            // 完成信号
//            clockDomain.waitSamplingWhere(io.state.toBigInt == 15)
//            println("完成第一轮")
//            io.control #= 15    // 清中断
//            clockDomain.waitSamplingWhere(io.state.toBigInt == 0)
//            io.control #= 6     // 开启下一轮
//            for (line <- Source.fromFile(src).getLines) {
//                io.sData(0).payload #= BigInt(line.trim, 16)
//                io.sData(0).valid #= true
//                clockDomain.waitSamplingWhere(io.sData(0).valid.toBoolean && io.sData(0).ready.toBoolean)
//                io.sData(0).valid #= false
//                val randomInt = random.nextInt(25)
//                if (randomInt < 4) clockDomain.waitSampling(randomInt)
//            }
        }

        fork {
            for (line <- Source.fromFile(src2).getLines) {
                io.sData(1).payload #= BigInt(line.trim, 16)
                io.sData(1).valid #= true
                clockDomain.waitSamplingWhere(io.sData(1).valid.toBoolean && io.sData(1).ready.toBoolean)
                io.sData(1).valid #= false
//                val randomInt = random.nextInt(25)
//                if (randomInt < 4) clockDomain.waitSampling(randomInt)
            }
        }
    }

    def out(dst_scala: String, dst: String): Unit = {
        clockDomain.waitSampling()
        val testFile = new PrintWriter(new File(dst_scala))
        val dstFile = Source.fromFile(dst).getLines().toArray
        val total = dstFile.length
        var error = 0
        var iter = 0
        var i = 0
        while (i < dstFile.length) {
            clockDomain.waitSampling()
            io.mData.ready.randomize()
            if (io.mData.valid.toBoolean && io.mData.ready.toBoolean) {
                val temp = dstFile(iter)
                val o = toHexString(16, io.mData.payload.toBigInt)
                i = i + 1
                if (!temp.equals(o)) {
                    error = error + 1
//                    println("i:" + i)
                }
                if (iter % 1000 == 999) {
                    val errorP = error * 100.0 / total
                    println(s"total iter = $total current iter =  $iter :::  error count = $error error percentage = $errorP%")
                }
                testFile.write(o + "\r\n")
                iter = iter + 1
            }
//            if (io.w_en.toBoolean) {
//                val temp = dstFile(iter)
//                val o = toHexString(16, io.w_data.toBigInt)
//                i = i + 1
//                if (!temp.equals(o)) {
//                    error = error + 1
//                    println("i:" + i)
//                }
//                if (iter % 100 == 99) {
//                    val errorP = error * 100.0 / total
//                    println(s"total iter = $total current iter =  $iter :::  error count = $error error percentage = $errorP%")
//                }
//                testFile.write(o + "\r\n")
//                iter = iter + 1
//            }
        }
        if (error > 0) {
            println(s"error is $error\n")
        } else {
            println(s"ac\n")
        }

        clockDomain.waitSampling(1000)
        testFile.close()
        simSuccess()
    }
}


object TbShape extends App {
    val spinalConfig = new SpinalConfig(
        defaultClockDomainFrequency = FixedFrequency(200 MHz),
        defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH, resetKind = SYNC)
    )
    //SimConfig.withXSim.withWave.withConfig(spinalConfig).compile(new TbMaxPooling()).doSimUntilVoid { dut =>
    SimConfig.withXilinxDevice("xc7vx690tffg1157-2").withXSimSourcesPaths(ArrayBuffer("src/test/ip"), ArrayBuffer("")).withWave.withXSim.withConfig(spinalConfig).compile(new TbShape()).doSimUntilVoid { dut =>
        dut.init
        dut.clockDomain.waitSampling(100)
        val path = "src/test/sim_data"

        dut.in(path + "\\add_1.coe", path + "\\add_2.coe")
        dut.out(path + "\\sim_o.txt",path + "\\add_output.coe")
    }
}
