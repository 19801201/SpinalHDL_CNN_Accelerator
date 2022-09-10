import spinal.core.sim._
import spinal.core._
import shape._
import TbCfg.Rom
object TbMaxPooling extends App {
        SimConfig.withWave.compile(new MaxPooling(MaxPoolingConfig(8,8,100,10,1024))).doSim{
            dut=>
                dut.clockDomain.forkStimulus(5)
                dut.clockDomain.waitSampling(10)
                dut.io.sData.valid #= false
                dut.io.sData.payload #= 0
                dut.io.mData.ready #= false
                dut.io.colNumIn #= 100
                dut.io.rowNumIn #= 100
                dut.io.channelIn #= 32
                dut.io.start #= false
                dut.clockDomain.waitSampling(10)
                dut.io.mData.ready #= true
                dut.io.start #= true
                dut.clockDomain.waitSampling()
                dut.io.start #= false
                for (i <- 0 until 100*100*4) {
                    dut.io.sData.valid #= true
                    dut.io.sData.payload #= i
                    dut.clockDomain.waitSamplingWhere(dut.io.sData.valid.toBoolean && dut.io.sData.ready.toBoolean)
    //                if(i == 5){
    //                    dut.io.mData.ready #= false
    //                    dut.clockDomain.waitSampling(10)
    //                    dut.io.mData.ready #= true
    //                }
                    println(i)

                }
                dut.io.sData.valid #= false
                dut.clockDomain.waitSampling(10)
        }
}
