#Set the context to "dft" with the sub-context to scan
set_context dft -scan

#Read the cell library files
read_cell_library adk.tcelllib

#Read the synthesized design
read_verilog bms_master_control_unit_enhanced.v


#Elaborate the design top
set_current_design bms_master_control_unit_enhanced -show_elaboration_warnings
 
#Set the design level to chip
set_design_level sub_block

#Define the clocks
analyze_control_signals -auto 

#Specify the configuration
set_test_logic -set on -reset on -clock on

#Run the DRC
check_design_rules

#Set a chain constraint for scan chain
set_scan_insertion_options -port_index_start_value 1 -single_clock_edge_chains ON -si_timing any_edge -so_timing any_edge

add_scan_mode unwrapped -chain_count 1

#Distribute the scan elements to chains
analyze_scan_chains

#Modify the Netlist
insert_test_logic 

#Review the report files
report_scan_cells 

report_test_logic

#Write the modified stitched netlist
write_design -output_file bms_master_control_unit_enhanced_scan_stitched.v -replace

#Create the ATPG set up files
write_atpg_setup bms_master_control_unit_enhanced_atpg -replace
