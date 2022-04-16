package wa.xip.memory.ip.BlockRam

import spinal.core._

object Bram {
    def apply[T <: Data](dataType: TDramDataType[T], TDRamConfig: TDRamConfig, clockDomainA: ClockDomain, clockDomainB: ClockDomain, componentName: String, genTclScript: Boolean, filePath: String = ".") = {
        val mem = TDRam(dataType, TDRamConfig, clockDomainA, clockDomainB, componentName, genTclScript)
        mem
    }
}