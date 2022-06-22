package wa.xip.debug

import config.Config.filePath
import org.apache.commons.io.FileUtils
import spinal.core._

class Ila(probeWidth: List[Int], componentName: String) extends BlackBox {

    val io = new Bundle {
        val clk = in Bool()
        (0 until probeWidth.size).foreach(i => {
            val probe = in UInt (probeWidth(i) bits) setName (s"probe$i")
        })
    }
    noIoPrefix()
    mapClockDomain(clock = io.clk)
}

object Ila {
    private def genTcl(probeWidth: List[Int], componentName: String, sampleDepth: Int = 1024) = {
        import java.io._
        val createIlaCmd = s"set ilaExit [lsearch -exact [get_ips $componentName] $componentName]\n" +
            s"if { $$ilaExit <0} {\n" +
            s"create_ip -name ila -vendor xilinx.com -library ip -version 6.2 -module_name $componentName\n" +
            s"}\n"
        FileUtils.forceMkdir(new File(filePath + File.separator + "tcl"))
        val tclHeader = new PrintWriter(new File(filePath + File.separator + "tcl" + File.separator + s"generate$componentName.tcl"))
        tclHeader.write(createIlaCmd)
        tclHeader.write(s"set_property -dict [list ")
        tclHeader.write(s"set_property CONFIG.C_NUM_OF_PROBES ${probeWidth.size} ")
        tclHeader.write(s"set_property CONFIG.C_EN_STRG_QUAL {1} ")
        tclHeader.write(s"set_property CONFIG.C_ADV_TRIGGER {true} ")
        tclHeader.write(s"set_property CONFIG.C_DATA_DEPTH $sampleDepth ")
        for (probeIndex <- 0 until probeWidth.size) {
            tclHeader.write(s"set_property CONFIG.C_PROBE${probeIndex}_WIDTH {${probeWidth(probeIndex)}} ")
        }
        tclHeader.write(s"] [get_ips $componentName] \n")
        tclHeader.write(s"set_property generate_synth_checkpoint 0 [get_files $componentName.xci] \n")
        tclHeader.close()
    }
    def apply(probeWidth: List[Int], componentName: String, sampleDepth: Int = 1024) ={
        genTcl(probeWidth, componentName, sampleDepth)
        val ila = new Ila(probeWidth, componentName)
        ila
    }
}
