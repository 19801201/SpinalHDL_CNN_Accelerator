import spinal.core.sim._
import spinal.core._
import conv.dataGenerate._
import shape.{MaxPoolingFix, MaxPoolingFixConfig}

import java.io.{File, PrintWriter}
import scala.io.Source

class TbMaxPoolingFix extends MaxPoolingFix(MaxPoolingFixConfig(8, 8, 640, 10)) {
    def toHexString(width: Int, b: BigInt): String = {
        var s = b.toString(16)
        if (s.length < width) {
            s = "0" * (width - s.length) + s
        }
        s
    }

    def init = {
        clockDomain.forkStimulus(5)
        io.kernelNum #= 2 //5*5的MaxPooling
        io.sData.valid #= false
        io.sData.payload #= 0
        io.mData.ready #= false
        io.start #= false
        //        io.enPadding(0) #= true
        //        io.enPadding(1) #= true
        //        io.enPadding(2) #= false
        //        io.enPadding(3) #= true
        io.channelIn #= 512
        io.rowNumIn #= 20
        io.colNumIn #= 20
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
        val dstFile = Source. fromFile(dst).getLines().toArray
        val total = dstFile.length
        var error = 0
        var iter = 0
        var i = 0
        while (i < dstFile.length) {
            clockDomain.waitSampling()
            //io.mData.ready.randomize()
            io.mData.ready #= true
            if (io.mData.valid.toBoolean && io.mData.ready.toBoolean) {
                i = i + 1
                io.start #= false
                val temp = dstFile(iter)
                val o = toHexString(8 << 1, io.mData.payload.toBigInt)

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
        if(error>0){
            println(s"error is $error\n")
        } else{
            println(s"ac\n")
        }

        sleep(100)
        testFile.close()
        simSuccess()
    }
}

object TbMaxPoolingFix extends App {
    val spinalConfig = new SpinalConfig(
        defaultClockDomainFrequency = FixedFrequency(200 MHz),
        defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH, resetKind = SYNC)
    )
    SimConfig.withWave.withConfig(spinalConfig).compile(new TbMaxPoolingFix()).doSimUntilVoid { dut =>
        dut.init
        dut.io.start #= true
        //dut.in("G:\\SpinalHDL_CNN_Accelerator\\simData\\paddingSrc.txt")
        dut.in("C:\\Users\\qingyu\\Desktop\\k44444\\raw.txt")
        dut.out("C:\\Users\\qingyu\\Desktop\\k44444\\dst.txt","C:\\Users\\qingyu\\Desktop\\k44444\\result.txt")
    }
    //C:\Users\qingyu\Desktop\
}
