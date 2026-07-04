#Set the context to DFT Scan mode
set_context dft -scan

#Read the cell library files
read_cell_library adk.tcelllib

#Read the synthesized design
read_verilog design/RISC8.v

#Set the current design for elaboration process
set_current_design cpu
add_black_boxes -auto

#Identify and define control signals
analyze_control_signals -auto_fix

#Run DRC
check_design_rules

#Set the scan chains count to 2
set_scan_insertion_options -chain_count 2
add_scan_mode unwrapped -chain_count 2

#Insert the scan logic
analyze_scan_chains
insert_test_logic

#Report scan chains and new test logic  
report_scan_chains
report_test_logic

#Write the scan inserted netlist
write_design -output_file netlist/RISC8_scan.v -replace

#Write out atpg dofile and testproc file
write_atpg_setup atpg -replace

exit




