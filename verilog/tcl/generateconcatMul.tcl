set mulExit [lsearch -exact [get_ips concatMul] concatMul]
if { $mulExit <0} {
create_ip -name mult_gen -vendor xilinx.com -library ip -version 12.0 -module_name concatMul
}
set_property -dict [list CONFIG.PortAWidth {32} CONFIG.PortAType {signed} CONFIG.PortBWidth {32} CONFIG.PortBType {Unsigned} CONFIG.Multiplier_Construction {Use_Mults} CONFIG.Use_Custom_Output_Width {true} CONFIG.OutputWidthHigh {63} CONFIG.OutputWidthLow {31} CONFIG.PipeStages {3} ] [get_ips concatMul] 
set_property generate_synth_checkpoint 0 [get_files concatMul.xci] 
