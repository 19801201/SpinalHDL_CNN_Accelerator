package wa.xip.memory.ip.BlockRam

import spinal.core._

case class TDRamConfig(AWriteWidth: Int, AWriteDepth: Int, AReadWidth: Int, BWriteWidth: Int, BReadWidth: Int) {
    val AReadDepth: Int = AWriteDepth * AWriteWidth / AReadWidth
    val BWriteDepth: Int = AWriteDepth * AWriteWidth / AReadWidth
    val BReadDepth: Int = AWriteDepth * AWriteWidth / AReadWidth
    val AWriteDepthWidth: Int = log2Up(AWriteDepth)
    val AReadDepthWidth: Int = log2Up(AReadDepth)
    val BWriteDepthWidth: Int = log2Up(BWriteDepth)
    val BReadDepthWidth: Int = log2Up(BReadDepth)
    val portADepthWidth: Int = if (AWriteDepthWidth >= AReadDepthWidth) AWriteDepthWidth else AReadDepthWidth
    val portBDepthWidth: Int = if (BWriteDepthWidth >= BReadDepthWidth) BWriteDepthWidth else BReadDepthWidth
}



class TDRam[T <: Data](dataType: TDramDataType[T], TDRamConfig: TDRamConfig, clockDomainA: ClockDomain, clockDomainB: ClockDomain, componentName: String) extends BlackBox {
    val io = new Bundle {
        val clka = in Bool()
        val ena = in Bool()
        val wea = in Bool()
        val addra = in UInt (TDRamConfig.portADepthWidth bits)
        val dina = in(cloneOf(dataType.dinAType))
        val douta = out(cloneOf(dataType.dOutAType))
        val clkb = in Bool()
        val enb = in Bool()
        val web = in Bool()
        val addrb = in UInt (TDRamConfig.portBDepthWidth bits)
        val dinb = in(cloneOf(dataType.dinBType))
        val doutb = out(cloneOf(dataType.dOutBType))
    }
    noIoPrefix()
    this.setDefinitionName(componentName)
    mapClockDomain(clockDomainA, io.clka)
    mapClockDomain(clockDomainB, io.clkb)
}

object TDRam {
    private def genTcl(TDRamConfig: TDRamConfig, componentName: String): Unit = {
        import java.io._
        val createCmd = s"set TDRamExit [lsearch -exact [get_ips $componentName] $componentName]\n" +
            s"if { $$TDRamExit <0} {\n" +
            s"create_ip -name blk_mem_gen -vendor xilinx.com -library ip -version 8.4 -module_name $componentName\n" +
            s"}\n"
        val tclHeader = new PrintWriter(new File(s"generate$componentName.tcl"))
        tclHeader.write(createCmd)
        tclHeader.write(s"set_property -dict [list ")
        tclHeader.write(s"CONFIG.Memory_Type {True_Dual_Port_RAM} ")
        tclHeader.write(s"CONFIG.Write_Width_A {${TDRamConfig.AWriteWidth}} ")
        tclHeader.write(s"CONFIG.Write_Depth_A {${TDRamConfig.AWriteDepth}} ")
        tclHeader.write(s"CONFIG.Read_Width_A {${TDRamConfig.AReadWidth}} ")
        tclHeader.write(s"CONFIG.Write_Width_B {${TDRamConfig.BWriteWidth}} ")
        tclHeader.write(s"CONFIG.Read_Width_B {${TDRamConfig.BReadWidth}} ")
        tclHeader.write(s"CONFIG.Enable_B {Use_ENB_Pin} ")
        tclHeader.write(s"CONFIG.Register_PortA_Output_of_Memory_Primitives {false} ")
        tclHeader.write(s"CONFIG.Register_PortB_Output_of_Memory_Primitives {false} ")
        tclHeader.write(s"CONFIG.Port_B_Clock {100} ")
        tclHeader.write(s"CONFIG.Port_B_Write_Rate {50} ")
        tclHeader.write(s"CONFIG.Port_B_Write_Rate {100} ")
        tclHeader.write(s"] [get_ips $componentName] \n")
        tclHeader.close()
    }

    def apply[T <: Data](dataType: TDramDataType[T], TDRamConfig: TDRamConfig, clockDomainA: ClockDomain, clockDomainB: ClockDomain, componentName: String, genTclScript: Boolean) = {
        val mem = new TDRam(dataType, TDRamConfig, clockDomainA, clockDomainB, componentName)
        if (genTclScript) {
            genTcl(TDRamConfig, componentName)
        }
        mem
    }
}

//class testTDRam extends Component {
//    val io = new Bundle {
//        //        val clka = in Bool()
//        val ena = in Bool()
//        val wea = in Bool()
//        val addra = in UInt (10 bits)
//        val dina = in UInt (8 bits)
//        val douta = out UInt (16 bits)
//        //        val clkb = in Bool()
//        val enb = in Bool()
//        val web = in Bool()
//        val addrb = in UInt (9 bits)
//        val dinb = in UInt (16 bits)
//        val doutb = out UInt (16 bits)
//    }
//    noIoPrefix()
//    val dataType = BramDataType(UInt(8 bits), UInt(16 bits), UInt(16 bits), UInt(16 bits))
//    val mem = TDRam(dataType, TDRamConfig = TDRamConfig(8, 1024, 16, 16, 16), clockDomainA = this.clockDomain, clockDomainB = this.clockDomain, componentName = "a", true)
//    mem.io.ena <> io.ena
//    mem.io.wea <> io.wea
//    mem.io.addra <> io.addra
//    mem.io.dina <> io.dina
//    mem.io.douta <> io.douta
//    mem.io.enb <> io.enb
//    mem.io.web <> io.web
//    mem.io.addrb <> io.addrb
//    mem.io.dinb <> io.dinb
//    mem.io.doutb <> io.doutb
//}
//
//object testTDRam extends App {
//    SpinalVerilog(new testTDRam)
//}
