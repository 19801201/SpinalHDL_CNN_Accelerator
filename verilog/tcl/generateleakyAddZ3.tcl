set addSubExit [lsearch -exact [get_ips leakyAddZ3] leakyAddZ3]
if { $addSubExit <0} {
create_ip -name c_addsub -vendor xilinx.com -library ip -version 12.0 -module_name leakyAddZ3
}
set_property -dict [list CONFIG.A_Width {16} CONFIG.A_Type {signed} CONFIG.B_Width {8} CONFIG.B_Type {Unsigned} CONFIG.CE {false} CONFIG.Add_Mode {Add} CONFIG.Implementation {Fabric} CONFIG.Out_Width {16} CONFIG.Latency {1} ] [get_ips leakyAddZ3] 
set_property generate_synth_checkpoint 0 [get_files leakyAddZ3.xci] 
