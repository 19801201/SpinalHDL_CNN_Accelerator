package wa.xip.math

import config.Config.{dsp2x, filePath}
import org.apache.commons.io.FileUtils
import spinal.core._
import spinal.lib._

class DSP(componentName: String, clockDomain2X: ClockDomain = null) extends BlackBox {


    val a = in UInt (8 bits)
    val d = in UInt (8 bits)
    val b = in UInt (8 bits)
    val p = if (!config.Config.dsp2x) out UInt (32 bits) else out UInt (64 bits)
    val CLK = in Bool()
    val a1 = config.Config.dsp2x generate (in UInt (8 bits))
    val d1 = config.Config.dsp2x generate (in UInt (8 bits))
    val CLK_2X = config.Config.dsp2x generate (in Bool())
    val RST_2X = config.Config.dsp2x generate (in Bool())
    this.mapClockDomain(clock = CLK)

    if (config.Config.dsp2x) {
        this.mapClockDomain(clockDomain = clockDomain2X, clock = CLK_2X, reset = RST_2X)
    }
    if (config.Config.dsp2x) {
        setInlineVerilog(
            """module DSP (
              input             [7:0] a       ,
              input             [7:0] d       ,
              input             [7:0] a1      ,
              input             [7:0] d1      ,
              input             [7:0] b       ,
              output            [63:0] p      ,
              input             CLK           ,
              input             CLK_2X        ,
              input             RST_2X


          );

          wire  signed       [7:0]   ain;
    assign ain = $signed(a);
    wire  signed       [24:0]  din;
    wire  signed       [7:0]   ain1;
    assign ain1 = $signed(a1);
    wire  signed       [24:0]  din1;
    assign din1 =  $signed({d1,16'd0});

    wire [33:0] pout;
    wire [15:0] pout1;
    wire [15:0] pout2;
    reg  [31:0] dsp2x_out;
    assign pout1 = pout[15:0];
    assign pout2 = pout[31:16];
    always@(*)begin
        if(pout1[15])begin
            dsp2x_out[15:0] = pout1;
            dsp2x_out[31:16] = pout2+1;
        end else begin
            dsp2x_out[15:0] = pout1;
            dsp2x_out[31:16] = pout2;
        end
    end
    assign din =  $signed({d,16'd0});
    reg dataIn ;
    reg dataInq ;
    reg dataInqq ;
    reg dataInqqq ;
    always@(posedge CLK_2X)begin
        if(RST_2X)begin
            dataIn <= 1'b0;
            dataInq <= dataIn;
            dataInqq <= dataInq;
            dataInqqq <= dataInqq;
        end else begin
            dataIn <= !dataIn;
            dataInq <= dataIn;
            dataInqq <= dataInq;
            dataInqqq <= dataInqq;
        end
    end
    reg [63:0] dsp_out;
    reg out_valid;
    always@(posedge CLK_2X)begin
        if(dataInqqq)begin
            dsp_out[63:32] <= dsp2x_out;
            out_valid <= 1'b1;
        end else begin
            dsp_out[31:0] <= dsp2x_out;
            out_valid <= 1'b0;
        end
    end
    wire out_validq;
    xpm_cdc_single #(
    .DEST_SYNC_FF(4), // DECIMAL; range: 2-10
    .INIT_SYNC_FF(0), // DECIMAL; 0=disable simulation init values, 1=enable simulation init values
    .SIM_ASSERT_CHK(0), // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
    .SRC_INPUT_REG(1) // DECIMAL; 0=do not register input, 1=register input
    )
    dsp2x_s (
        .dest_out(out_validq), // 1-bit output: src_in synchronized to the destination clock domain. This output is
        // registered.

        .dest_clk(CLK), // 1-bit input: Clock signal for the destination clock domain.
        .src_clk(CLK_2X), // 1-bit input: optional; required when SRC_INPUT_REG = 1
        .src_in(out_valid) // 1-bit input: Input signal to be synchronized to dest_clk domain.
    );

    wire [63:0] dsp2x_x_out;
    xpm_cdc_gray #(
    .DEST_SYNC_FF(4), // DECIMAL; range: 2-10
    .INIT_SYNC_FF(0), // DECIMAL; 0=disable simulation init values, 1=enable simulation init values
    .REG_OUTPUT(0), // DECIMAL; 0=disable registered output, 1=enable registered output
    .SIM_ASSERT_CHK(0), // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
    .SIM_LOSSLESS_GRAY_CHK(0), // DECIMAL; 0=disable lossless check, 1=enable lossless check
    .WIDTH(32) // DECIMAL; range: 2-32
    )
    dsp2x_x (
        .dest_out_bin(dsp2x_x_out[31:0]), // WIDTH-bit output: Binary input bus (src_in_bin) synchronized to
        // destination clock domain. This output is combinatorial unless REG_OUTPUT
        // is set to 1.

        .dest_clk(CLK), // 1-bit input: Destination clock.
        .src_clk(CLK_2X), // 1-bit input: Source clock.
        .src_in_bin(dsp_out[31:0]) // WIDTH-bit input: Binary input bus that will be synchronized to the
        // destination clock domain.

    );

       xpm_cdc_gray #(
          .DEST_SYNC_FF(4),          // DECIMAL; range: 2-10
          .INIT_SYNC_FF(0),          // DECIMAL; 0=disable simulation init values, 1=enable simulation init values
          .REG_OUTPUT(0),            // DECIMAL; 0=disable registered output, 1=enable registered output
          .SIM_ASSERT_CHK(0),        // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
          .SIM_LOSSLESS_GRAY_CHK(0), // DECIMAL; 0=disable lossless check, 1=enable lossless check
          .WIDTH(32)                  // DECIMAL; range: 2-32
       )
       dsp2x_x1 (
          .dest_out_bin(dsp2x_x_out[63:32]), // WIDTH-bit output: Binary input bus (src_in_bin) synchronized to
                                       // destination clock domain. This output is combinatorial unless REG_OUTPUT
                                       // is set to 1.

          .dest_clk(CLK),         // 1-bit input: Destination clock.
          .src_clk(CLK_2X),           // 1-bit input: Source clock.
          .src_in_bin(dsp_out[63:32])      // WIDTH-bit input: Binary input bus that will be synchronized to the
                                       // destination clock domain.

       );

    reg [31:0] pTemp;
    always@(posedge CLK)begin
//        if(out_validq)begin
//            pTemp = pTemp;
//        end else begin
            pTemp = dsp2x_x_out[31:0];
//        end
    end
    assign p = {dsp2x_x_out[63:32],pTemp};
    reg  signed       [7:0]   dsp_ain;
    reg  signed       [24:0]   dsp_din;
    reg  signed       [8:0]   dsp_bin;

    wire  signed       [7:0]   aout;
    wire  signed       [7:0]   bout;
    wire  signed       [24:0]  dout;
    xpm_cdc_gray #(
          .DEST_SYNC_FF(4),          // DECIMAL; range: 2-10
          .INIT_SYNC_FF(0),          // DECIMAL; 0=disable simulation init values, 1=enable simulation init values
          .REG_OUTPUT(0),            // DECIMAL; 0=disable registered output, 1=enable registered output
          .SIM_ASSERT_CHK(0),        // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
          .SIM_LOSSLESS_GRAY_CHK(0), // DECIMAL; 0=disable lossless check, 1=enable lossless check
          .WIDTH(8)                  // DECIMAL; range: 2-32
       )
       cdc_ain (
          .dest_out_bin(aout), // WIDTH-bit output: Binary input bus (src_in_bin) synchronized to
                                       // destination clock domain. This output is combinatorial unless REG_OUTPUT
                                       // is set to 1.

          .dest_clk(CLK_2X),         // 1-bit input: Destination clock.
          .src_clk(CLK),           // 1-bit input: Source clock.
          .src_in_bin(ain)      // WIDTH-bit input: Binary input bus that will be synchronized to the
                                       // destination clock domain.

       );
    xpm_cdc_gray #(
          .DEST_SYNC_FF(4),          // DECIMAL; range: 2-10
          .INIT_SYNC_FF(0),          // DECIMAL; 0=disable simulation init values, 1=enable simulation init values
          .REG_OUTPUT(0),            // DECIMAL; 0=disable registered output, 1=enable registered output
          .SIM_ASSERT_CHK(0),        // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
          .SIM_LOSSLESS_GRAY_CHK(0), // DECIMAL; 0=disable lossless check, 1=enable lossless check
          .WIDTH(8)                  // DECIMAL; range: 2-32
       )
       cdc_bin (
          .dest_out_bin(bout), // WIDTH-bit output: Binary input bus (src_in_bin) synchronized to
                                       // destination clock domain. This output is combinatorial unless REG_OUTPUT
                                       // is set to 1.

          .dest_clk(CLK_2X),         // 1-bit input: Destination clock.
          .src_clk(CLK),           // 1-bit input: Source clock.
          .src_in_bin(b)      // WIDTH-bit input: Binary input bus that will be synchronized to the
                                       // destination clock domain.

       );
  xpm_cdc_gray #(
          .DEST_SYNC_FF(4),          // DECIMAL; range: 2-10
          .INIT_SYNC_FF(0),          // DECIMAL; 0=disable simulation init values, 1=enable simulation init values
          .REG_OUTPUT(0),            // DECIMAL; 0=disable registered output, 1=enable registered output
          .SIM_ASSERT_CHK(0),        // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
          .SIM_LOSSLESS_GRAY_CHK(0), // DECIMAL; 0=disable lossless check, 1=enable lossless check
          .WIDTH(25)                  // DECIMAL; range: 2-32
       )
       cdc_din (
          .dest_out_bin(dout), // WIDTH-bit output: Binary input bus (src_in_bin) synchronized to
                                       // destination clock domain. This output is combinatorial unless REG_OUTPUT
                                       // is set to 1.

          .dest_clk(CLK_2X),         // 1-bit input: Destination clock.
          .src_clk(CLK),           // 1-bit input: Source clock.
          .src_in_bin(din)      // WIDTH-bit input: Binary input bus that will be synchronized to the
                                       // destination clock domain.

       );
    wire  signed       [7:0]   aout1;
    wire  signed       [24:0]  dout1;
    xpm_cdc_gray #(
          .DEST_SYNC_FF(4),          // DECIMAL; range: 2-10
          .INIT_SYNC_FF(0),          // DECIMAL; 0=disable simulation init values, 1=enable simulation init values
          .REG_OUTPUT(0),            // DECIMAL; 0=disable registered output, 1=enable registered output
          .SIM_ASSERT_CHK(0),        // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
          .SIM_LOSSLESS_GRAY_CHK(0), // DECIMAL; 0=disable lossless check, 1=enable lossless check
          .WIDTH(8)                  // DECIMAL; range: 2-32
       )
       cdc_ain1 (
          .dest_out_bin(aout1), // WIDTH-bit output: Binary input bus (src_in_bin) synchronized to
                                       // destination clock domain. This output is combinatorial unless REG_OUTPUT
                                       // is set to 1.

          .dest_clk(CLK_2X),         // 1-bit input: Destination clock.
          .src_clk(CLK),           // 1-bit input: Source clock.
          .src_in_bin(ain1)      // WIDTH-bit input: Binary input bus that will be synchronized to the
                                       // destination clock domain.

       );
  xpm_cdc_gray #(
          .DEST_SYNC_FF(4),          // DECIMAL; range: 2-10
          .INIT_SYNC_FF(0),          // DECIMAL; 0=disable simulation init values, 1=enable simulation init values
          .REG_OUTPUT(0),            // DECIMAL; 0=disable registered output, 1=enable registered output
          .SIM_ASSERT_CHK(0),        // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
          .SIM_LOSSLESS_GRAY_CHK(0), // DECIMAL; 0=disable lossless check, 1=enable lossless check
          .WIDTH(25)                  // DECIMAL; range: 2-32
       )
       cdc_din1 (
          .dest_out_bin(dout1), // WIDTH-bit output: Binary input bus (src_in_bin) synchronized to
                                       // destination clock domain. This output is combinatorial unless REG_OUTPUT
                                       // is set to 1.

          .dest_clk(CLK_2X),         // 1-bit input: Destination clock.
          .src_clk(CLK),           // 1-bit input: Source clock.
          .src_in_bin(din1)      // WIDTH-bit input: Binary input bus that will be synchronized to the
                                       // destination clock domain.

       );
    always @(posedge CLK_2X)begin
        if(dataIn)begin
            dsp_ain <= aout;
            dsp_bin <= {1'b0,bout};
            dsp_din <= dout;
        end else begin
            dsp_ain <= aout1;
            dsp_bin <= {1'b0,bout};
            dsp_din <= dout1;
        end
    end """ + "\r\n          " + componentName + " " + componentName + "_inst" +
                """ (
            .CLK(CLK_2X), // input wire CLK
            .A(dsp_ain), // input wire [7 : 0] A
            .B(dsp_bin), // input wire [8 : 0] B
            .D(dsp_din), // input wire [24 : 0] D
            .P(pout) // output wire [33 : 0] P
          );

endmodule
      """.stripMargin)
    } else {
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
          wire  signed       [24:0]  din;
          wire [33:0] pout;
          wire [15:0] a1;
          wire [15:0] a2;
          assign a1 = pout[15:0];
          assign a2 = pout[31:16];
          always@(*)begin
               if(a1[15])begin
                   p[15:0] = a1;
                   p[31:16] = a2+1;
               end else begin
                   p[15:0] = a1;
                   p[31:16] = a2;
               end
          end
          assign din =  $signed({d,16'd0});""" + "\r\n          " + componentName + " " + componentName + "_inst" +
                """ (
            .CLK(CLK),  // input wire CLK
            .A(ain),      // input wire [7 : 0] A
            .B({1'b0,b}),      // input wire [8 : 0] B
            .D(din),      // input wire [24 : 0] D
            .P(pout)      // output wire [33 : 0] P
          );

endmodule
      """.stripMargin)
    }

}

object DSP {
    private var genClk = true

    def genTcl(componentName: String): Unit = {
        import java.io._
        val createDspCmd = s"set dspExit [lsearch -exact [get_ips $componentName] $componentName]\n" +
            s"if { $$dspExit <0} {\n" +
            s"create_ip -name dsp_macro -vendor xilinx.com -library ip -version 1.0 -module_name $componentName\n" +
            //            s"}\n" + s"set_property -dict [list CONFIG.instruction1 {(A+D)*B} CONFIG.pipeline_options {By_Tier} CONFIG.tier_3 {true} CONFIG.tier_4 {true} CONFIG.tier_6 {true} CONFIG.d_width {26} CONFIG.a_width {8} CONFIG.b_width {9} CONFIG.dreg_3 {true} CONFIG.areg_3 {true} CONFIG.areg_4 {true} CONFIG.breg_3 {true} CONFIG.breg_4 {true} CONFIG.creg_3 {false} CONFIG.creg_4 {false} CONFIG.creg_5 {false} CONFIG.mreg_5 {false} CONFIG.preg_6 {true} CONFIG.d_binarywidth {0} CONFIG.a_binarywidth {0} CONFIG.b_binarywidth {0} CONFIG.concat_width {48} CONFIG.concat_binarywidth {0} CONFIG.c_width {48} CONFIG.c_binarywidth {0} CONFIG.pcin_binarywidth {0} CONFIG.p_full_width {36} CONFIG.p_width {35} CONFIG.p_binarywidth {0}] [get_ips $componentName]"
            s"}\n" + s"set_property -dict [list CONFIG.instruction1 {(A+D)*B} CONFIG.pipeline_options {By_Tier} CONFIG.tier_3 {true} CONFIG.tier_4 {true} CONFIG.tier_6 {true} CONFIG.d_width {25} CONFIG.a_width {8} CONFIG.b_width {9} CONFIG.dreg_3 {true} CONFIG.areg_3 {true} CONFIG.areg_4 {true} CONFIG.breg_3 {true} CONFIG.breg_4 {true} CONFIG.creg_3 {false} CONFIG.creg_4 {false} CONFIG.creg_5 {false} CONFIG.mreg_5 {false} CONFIG.preg_6 {true} CONFIG.d_binarywidth {0} CONFIG.a_width {8} CONFIG.a_binarywidth {0} CONFIG.b_binarywidth {0} CONFIG.concat_width {48} CONFIG.concat_binarywidth {0} CONFIG.c_width {48} CONFIG.c_binarywidth {0} CONFIG.pcin_binarywidth {0} CONFIG.p_full_width {34} CONFIG.p_width {34} CONFIG.p_binarywidth {0}] [get_ips $componentName]"
        FileUtils.forceMkdir(new File(filePath + File.separator + "tcl"))
        val tclHeader = new PrintWriter(new File(filePath + File.separator + "tcl" + File.separator + s"generate$componentName.tcl"))
        tclHeader.write(createDspCmd)
        tclHeader.write("\r\n")
//        tclHeader.write(s"set_property generate_synth_checkpoint 0 [get_files $componentName.xci] \n")
        tclHeader.close()
    }

    def apply(componentName: String, myClockDomain: ClockDomain = null, genericTcl: Boolean = false) = {
        if (genericTcl) {
            genTcl(componentName)
        }
        val dsp = new DSP(componentName, clockDomain2X = myClockDomain)
        dsp
    }
}

//class TestDSP extends Component {
//    val io = new Bundle {
//        val a = in UInt (8 bits)
//        val d = in UInt (8 bits)
//        val b = in UInt (8 bits)
//        val p = out UInt (32 bits)
//    }
//    noIoPrefix()
//    val a1 = config.Config.dsp2x generate (in UInt (8 bits))
//    val d1 = config.Config.dsp2x generate (in UInt (8 bits))
//
//    val aa = DSP("dsp_macro_0", genericTcl = true)
//    io.a <> aa.a
//    io.b <> aa.b
//    io.d <> aa.d
//    io.p <> aa.p
//    if (config.Config.dsp2x) {
//        a1 <> aa.a1
//        d1 <> aa.d1
//    }
//
//}
//
//class top extends Component {
//    val io = new Bundle {
//        val a = in UInt (8 bits)
//        val d = in UInt (8 bits)
//        val b = in UInt (8 bits)
//        val p = out UInt (32 bits)
//    }
//    noIoPrefix()
//    val a1 = config.Config.dsp2x generate (in UInt (8 bits))
//    val d1 = config.Config.dsp2x generate (in UInt (8 bits))
//    val aa = new TestDSP
//    io.a <> aa.io.a
//    io.b <> aa.io.b
//    io.d <> aa.io.d
//    io.p <> aa.io.p
//    if (config.Config.dsp2x) {
//        a1 <> aa.a1
//        d1 <> aa.d1
//
//    }
//}
//
//object TestDSP extends App {
//    SpinalVerilog(new top)
//}
