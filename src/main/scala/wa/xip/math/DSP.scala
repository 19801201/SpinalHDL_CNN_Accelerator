package wa.xip.math

import config.Config.filePath
import org.apache.commons.io.FileUtils
import spinal.core._
import spinal.lib._

class DSP(componentName: String) extends BlackBox {

    val a = in UInt (8 bits)
    val d = in UInt (8 bits)
    val b = in UInt (8 bits)
    val p = out UInt (32 bits)
    val CLK = in Bool()
    this.mapClockDomain(clock = CLK)
    //    this.setDefinitionName(componentName)
    setInlineVerilog(
        """module DSP (
              input             [7:0] a       ,
              input             [7:0] d       ,
              input             [7:0] b       ,
              output   reg      [31:0] p      ,
              input             CLK

          );

          wire  signed       [7:0]   ain;
          assign ain = $signed(a);
          wire  signed       [25:0]  din;
          wire [35:0] pout;
          wire [15:0] a1;
          wire [15:0] a2;
          assign a1 = pout[15:0];
          assign a2 = pout[33:18];
          always@(*)begin
               if(a1[15])begin
                   p[15:0] = a1;
                   p[31:16] = a2+1;
               end else begin
                   p[15:0] = a1;
                   p[31:16] = a2;
               end
          end
          assign din =  $signed({d,18'd0});""" + "\r\n          " + componentName + " " + componentName + "_inst" +
            """ (
            .CLK(CLK),  // input wire CLK
            .A(ain),      // input wire [7 : 0] A
            .B({1'b0,b}),      // input wire [8 : 0] B
            .D(din),      // input wire [25 : 0] D
            .P(pout)      // output wire [33 : 0] P
          );

endmodule
      """.stripMargin)

}

object DSP {
    def genTcl(componentName: String): Unit = {
        import java.io._
        val createDspCmd = s"set dspExit [lsearch -exact [get_ips $componentName] $componentName]\n" +
            s"if { $$dspExit <0} {\n" +
            s"create_ip -name dsp_macro -vendor xilinx.com -library ip -version 1.0 -module_name $componentName\n" +
            s"}\n" + s"set_property -dict [list CONFIG.instruction1 {(A+D)*B} CONFIG.pipeline_options {By_Tier} CONFIG.tier_3 {true} CONFIG.tier_4 {true} CONFIG.tier_6 {true} CONFIG.d_width {26} CONFIG.a_width {8} CONFIG.b_width {9} CONFIG.dreg_3 {true} CONFIG.areg_3 {true} CONFIG.areg_4 {true} CONFIG.breg_3 {true} CONFIG.breg_4 {true} CONFIG.creg_3 {false} CONFIG.creg_4 {false} CONFIG.creg_5 {false} CONFIG.mreg_5 {false} CONFIG.preg_6 {true} CONFIG.d_binarywidth {0} CONFIG.a_binarywidth {0} CONFIG.b_binarywidth {0} CONFIG.concat_width {48} CONFIG.concat_binarywidth {0} CONFIG.c_width {48} CONFIG.c_binarywidth {0} CONFIG.pcin_binarywidth {0} CONFIG.p_full_width {36} CONFIG.p_width {35} CONFIG.p_binarywidth {0}] [get_ips $componentName]"
        FileUtils.forceMkdir(new File(filePath + File.separator + "tcl"))
        val tclHeader = new PrintWriter(new File(filePath + File.separator + "tcl" + File.separator + s"generate$componentName.tcl"))
        tclHeader.write(createDspCmd)
        tclHeader.close()
    }

    def apply(componentName: String, genericTcl: Boolean = false) = {
        if (genericTcl) {
            genTcl(componentName)
        }
        val dsp = new DSP(componentName)
        dsp
    }
}

//
//class TestDSP extends Component{
//    val io = new Bundle{
//        val a = in SInt (8 bits)
//        val d = in SInt (8 bits)
//        val b = in UInt (8 bits)
//        val p = out SInt (32 bits)
//    }
//    noIoPrefix()
//    val aa =  DSP("dsp_macro_0",true)
//    io.a <> aa.a
//    io.b <> aa.b
//    io.d <> aa.d
//    io.p <> aa.p
//}
//object TestDSP extends App{
//    SpinalVerilog(new TestDSP)
//}
