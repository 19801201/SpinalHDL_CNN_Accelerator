set mulExit [lsearch -exact [get_ips leakyReluMul] leakyReluMul]
if { $mulExit <0} {
create_ip -name mult_gen -vendor xilinx.com -library ip -version 12.0 -module_name leakyReluMul
}
set_property -dict [list CONFIG.PortAWidth {16} CONFIG.PortAType {signed} CONFIG.PortBWidth {16} CONFIG.PortBType {Unsigned} CONFIG.Multiplier_Construction {Use_Mults} CONFIG.OutputWidthHigh {31} CONFIG.PipeStages {3} ] [get_ips leakyReluMul] 
set_property generate_synth_checkpoint 0 [get_files leakyReluMul.xci] 
