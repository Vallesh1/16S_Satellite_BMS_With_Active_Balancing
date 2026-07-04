#Set the context to DFT edt mode
set_context dft -edt
 
#Read the scan chain netlist
read_verilog netlist/RISC8_scan.v

#Read the cell library files
read_cell_library adk.tcelllib

#Set the current design for elaboration process
set_current_design cpu
 
add_black_boxes -auto
#Read the ATPG setup
dofile atpg.dofile

#Used to run the TCL procedure from the atpg.do
tessent_scan_setup

#Specify parameters for EDT logic
set_edt_options -channels 1

#Report EDT channels & pins
report_edt_pins

#Run DRC
check_design_rules

#Report configuration of EDT logic
report_edt_configurations


#Write the EDT modified RTL
write_edt_files results/edt -verilog -replace



