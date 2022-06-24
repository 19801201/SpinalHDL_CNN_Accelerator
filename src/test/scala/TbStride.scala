import spinal.core._
import spinal.core.sim._
import conv.compute._
import spinal.lib._
import spinal.lib.fsm._
object TbStride extends App {
    SimConfig.withWave.compile(new Stride(ConvConfig(8, 8, 8, 12, 8192, 512, 416, 2048, 1))).doSim {
        dut =>
            dut.clockDomain.forkStimulus(5)
            dut.clockDomain.waitSampling(10)
            dut.io.rowNumIn #= 416
            dut.io.colNumIn #= 416
            dut.io.channelOut #= 64
            dut.io.enStride #= false
            dut.io.sData.valid #= false
            dut.io.mData.ready #= false
            dut.io.start #= false
            dut.clockDomain.waitSampling(10)
            dut.io.mData.ready #= true
            dut.io.start #= true
            dut.clockDomain.waitSampling()
            dut.io.start #= false
            for (i <- 0 until (416 * 416)*8 if !dut.io.complete.toBoolean) {
                dut.io.sData.valid #= true
                dut.io.sData.payload #= i


                dut.clockDomain.waitSamplingWhere(dut.io.sData.valid.toBoolean && dut.io.sData.ready.toBoolean)
                if(i == 5){
                    dut.io.mData.ready #= false
                    dut.clockDomain.waitSampling(10)
                    dut.io.mData.ready #= true
                }
                println(i)
            }
            dut.io.sData.valid #= false
            dut.clockDomain.waitSampling(1000)
    }
}
