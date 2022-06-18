set addSubExit [lsearch -exact [get_ips biasAdd] biasAdd]
if { $addSubExit <0} {
create_ip -name c_addsub -vendor xilinx.com -library ip -version 12.0 -module_name biasAdd
}
set_property -dict [list CONFIG.A_Width {32} CONFIG.A_Type {signed} CONFIG.B_Width {32} CONFIG.B_Type {Unsigned} CONFIG.CE {false} CONFIG.Add_Mode {Add} CONFIG.Implementation {Fabric} CONFIG.Out_Width {32} CONFIG.Latency {1} ] [get_ips biasAdd] 
set_property generate_synth_checkpoint 0 [get_files biasAdd.xci] 
