import config.Config
import spinal.core._
import spinal.core.sim._
import spinal.lib._
import spinal.lib.bus.amba4.axilite.sim._
import spinal.lib.bus.amba4.axilite._
import instruction.Instruction
object TbInstruction extends App{
    SimConfig.withWave.compile(new Instruction(Config.instructionAddr, Config.instructionType)).doSim{
        dut=>
            dut.clockDomain.forkStimulus(5)
            dut.clockDomain.waitSampling(10)
            val simAxiLite = AxiLite4Driver(dut.io.regSData,dut.clockDomain)
            dut.clockDomain.waitSampling()
            simAxiLite.write(0x4,1)
            dut.clockDomain.waitSampling(1)
            simAxiLite.write(0x28,32)
            dut.clockDomain.waitSampling(1)
            simAxiLite.write(0x2c,128)
            dut.clockDomain.waitSampling(1)
            simAxiLite.write(0x30,32)
            dut.clockDomain.waitSampling(1)
            simAxiLite.write(0x34,128)
            dut.clockDomain.waitSampling(1)
    }
}
