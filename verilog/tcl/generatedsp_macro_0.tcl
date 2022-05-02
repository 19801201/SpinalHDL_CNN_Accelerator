set dspExit [lsearch -exact [get_ips dsp_macro_0] dsp_macro_0]
if { $dspExit <0} {
create_ip -name dsp_macro -vendor xilinx.com -library ip -version 1.0 -module_name dsp_macro_0
}
set_property -dict [list CONFIG.instruction1 {(A+D)*B} CONFIG.pipeline_options {By_Tier} CONFIG.tier_3 {true} CONFIG.tier_4 {true} CONFIG.tier_6 {true} CONFIG.d_width {25} CONFIG.a_width {8} CONFIG.b_width {9} CONFIG.dreg_3 {true} CONFIG.areg_3 {true} CONFIG.areg_4 {true} CONFIG.breg_3 {true} CONFIG.breg_4 {true} CONFIG.creg_3 {false} CONFIG.creg_4 {false} CONFIG.creg_5 {false} CONFIG.mreg_5 {false} CONFIG.preg_6 {true} CONFIG.d_binarywidth {0} CONFIG.a_width {8} CONFIG.a_binarywidth {0} CONFIG.b_binarywidth {0} CONFIG.concat_width {48} CONFIG.concat_binarywidth {0} CONFIG.c_width {48} CONFIG.c_binarywidth {0} CONFIG.pcin_binarywidth {0} CONFIG.p_full_width {34} CONFIG.p_width {34} CONFIG.p_binarywidth {0}] [get_ips dsp_macro_0]
set_property generate_synth_checkpoint 0 [get_files dsp_macro_0.xci] 
