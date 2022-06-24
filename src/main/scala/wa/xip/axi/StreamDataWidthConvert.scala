package wa.xip.axi

import config.Config.filePath
import org.apache.commons.io.FileUtils
import spinal.core._
import spinal.lib._

class StreamDataWidthConvert(sDataWidth: Int, mDataWidth: Int, componentName: String) extends BlackBox {
    val io = new Bundle {
        val sData = slave Stream UInt(sDataWidth bits)
        val mData = master Stream UInt(mDataWidth bits)
        val aclk = in Bool()
        val aresetn = in Bool()
    }
    noIoPrefix()
    io.sData.payload.setName("s_axis_tdata")
    io.sData.valid.setName("s_axis_tvalid")
    io.sData.ready.setName("s_axis_tready")
    io.mData.payload.setName("m_axis_tdata")
    io.mData.valid.setName("m_axis_tvalid")
    io.mData.ready.setName("m_axis_tready")
    this.mapClockDomain(clock = io.aclk, reset = io.aresetn, resetActiveLevel = LOW)
    this.setDefinitionName(componentName)
}

object StreamDataWidthConvert {
    private def genTcl(sDataWidth: Int, mDataWidth: Int, componentName: String): Unit = {
        import java.io._
        val createAddCmd = s"set dataConvert [lsearch -exact [get_ips $componentName] $componentName]\n" +
            s"if { $$dataConvert <0} {\n" +
            s"create_ip -name axis_dwidth_converter -vendor xilinx.com -library ip -version 1.1 -module_name $componentName\n" +
            s"}\n"
        FileUtils.forceMkdir(new File(filePath + File.separator + "tcl"))
        val tclHeader = new PrintWriter(new File(filePath + File.separator + "tcl" + File.separator + s"generate$componentName.tcl"))
        tclHeader.write(createAddCmd)
        val sByte = sDataWidth / 8
        val mByte = mDataWidth / 8
        tclHeader.write(s"set_property -dict [list ")
        tclHeader.write(s"CONFIG.S_TDATA_NUM_BYTES {$sByte} ")
        tclHeader.write(s"CONFIG.M_TDATA_NUM_BYTES {$mByte} ")
        tclHeader.write(s"CONFIG.HAS_MI_TKEEP {0} ")
        tclHeader.write(s"] [get_ips $componentName] \n")
//        tclHeader.write(s"set_property generate_synth_checkpoint 0 [get_files $componentName.xci] \n")
        tclHeader.close()
    }

    def apply(sDataWidth: Int, mDataWidth: Int, componentName: String, generateTcl: Boolean = false) = {
        if (generateTcl) {
            genTcl(sDataWidth, mDataWidth, componentName)
        }
        val dataWidthConvert = new StreamDataWidthConvert(sDataWidth, mDataWidth, componentName)
        dataWidthConvert
    }
}

//class TestDataWidthConvert extends Component {
//    val io = new Bundle {
//        val sData = slave Stream UInt(32 bits)
//        val mData = master Stream UInt(64 bits)
//    }
//    noIoPrefix()
//    val data = StreamDataWidthConvert(32, 64, "convData1", true)
//    data.io.sData <> io.sData
//    data.io.mData <> io.mData
//}
//
//object TestDataWidthConvert extends App {
////    val clk = ClockDomainConfig(resetActiveLevel = LOW)
////    SpinalConfig(defaultConfigForClockDomains =  clk).generateVerilog(new TestDataWidthConvert)
//    SpinalVerilog(new TestDataWidthConvert)
//}
