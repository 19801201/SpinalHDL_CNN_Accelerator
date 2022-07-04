import spinal.core.sim._
import spinal.core._
import shape._
object TbShape extends App {
    SimConfig.withWave.compile(new Shape(ShapeConfig(8,8,416,10,1024))).doSim{
        dut=>
            dut.clockDomain.forkStimulus(5)
            dut.clockDomain.waitSampling(10)
            dut.io.instruction(0) #= 537198752
            dut.io.instruction(1) #= 0
            dut.io.instruction(2) #= 0
            dut.io.instruction(3) #= 0
            dut.io.instruction(4) #= 0
            dut.io.instruction(5) #= 0
            dut.io.sData(0).payload #= 0
            dut.io.sData(0).valid #= false
            dut.io.sData(1).payload #= 0
            dut.io.sData(1).valid #= false
            dut.io.mData.ready #= false
            dut.io.control #= 0
            dut.clockDomain.waitSampling(10)
            dut.io.mData.ready #= true
            dut.io.control #= 1
            dut.clockDomain.waitSampling()
            dut.io.control #= 0
            for (i <- 0 until 409600) {
                dut.io.sData(0).valid #= true
                dut.io.sData(0).payload #= i
                dut.clockDomain.waitSamplingWhere(dut.io.sData(0).valid.toBoolean && dut.io.sData(0).ready.toBoolean)
//                if(i == 5){
//                    dut.io.mData.ready #= false
//                    dut.clockDomain.waitSampling(10)
//                    dut.io.mData.ready #= true
//                }
                println(i)

            }
            dut.io.sData(0).valid #= false
            dut.clockDomain.waitSampling(10)
    }
}
