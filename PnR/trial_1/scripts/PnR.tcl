set_host_options -max_cores 2

################################################################
##Global Variables##
################################################################
set DESIGN_NAME "fpu_add"

set REFERENCE_LIBRARY "/home1/14_nmts/14_nmts/stdcell_hvt/ndm/saed14hvt_frame_only.ndm \
/home1/14_nmts/14_nmts/stdcell_slvt/ndm/saed14slvt_frame_only.ndm \
/home1/14_nmts/14_nmts/stdcell_rvt/ndm/saed14rvt_frame_only.ndm \
/home1/14_nmts/14_nmts/stdcell_lvt/ndm/saed14lvt_frame_only.ndm"

set LINK_LIBRARY "/home1/14_nmts/14_nmts/stdcell_lvt/db_ccs/saed14lvt_ff0p7vm40c.db \
/home1/14_nmts/14_nmts/stdcell_rvt/db_ccs/saed14rvt_ff0p7vm40c.db \
/home1/14_nmts/14_nmts/stdcell_rvt/db_ccs/saed14rvt_ss0p6v125c.db \ /home1/14_nmts/14_nmts/stdcell_lvt/db_ccs/saed14lvt_ss0p6v125c.db"

set TECH_FILE "/home1/14_nmts/14_nmts/tech/milkyway/saed14nm_1p9m_mw.tf"

set VERILOG_NETLIST_FILES "/home1/IITR_PD3/MulukuriVNath/PD3_Project/fpu_add/fpu_syn/outputs/fpu_add.mapped.v"

set UPF_FILE "/home1/IITR_PD3/MulukuriVNath/PD3_Project/fpu_add/fpu_syn/scripts/fpu_add.upf"

set DESIGN_LIBRARY 	"${DESIGN_NAME}" #${LIBRARY_SUFFIX}" 
################################################################

set link_library   $LINK_LIBRARY
set target_library $LINK_LIBRARY
create_lib  -ref_libs $REFERENCE_LIBRARY -technology $TECH_FILE ../work/${DESIGN_LIBRARY}

################################################################
## Read Verilog
################################################################
read_verilog ${VERILOG_NETLIST_FILES}
current_design ${DESIGN_NAME}
link

################################################################
## Design creation : Read UPF file(s)  
################################################################
## For golden UPF flow only (if supplemental UPF is provided): enable golden UPF flow before reading UPF
if {[file exists [which $UPF_SUPPLEMENTAL_FILE]]} {set_app_options -name mv.upf.enable_golden_upf -value true}
if {[file exists [which $UPF_FILE]]} {
  load_upf $UPF_FILE
 
  ## For golden UPF flow only (if supplemental UPF is provided): read supplemental UPF file
  if {[file exists [which $UPF_SUPPLEMENTAL_FILE]]} { 
  	load_upf -supplemental $UPF_SUPPLEMENTAL_FILE
  } elseif {$UPF_SUPPLEMENTAL_FILE != ""} {
  	puts "Error: UPF_SUPPLEMENTAL_FILE($UPF_SUPPLEMENTAL_FILE) is invalid. Please correct it."
  }
  
  puts "Info: Running commit_upf"
  commit_upf
} elseif {$UPF_FILE != ""} {
	puts "Error: UPF file($UPF_FILE) is invalid. Please correct it."
}

########################################################################
## Timing and design constraints	
########################################################################
set parasitic1				"tlup_max" ;# name of parasitic tech model 1
set tluplus_file($parasitic1)           "/home1/14_nmts/14_nmts/tech/star_rc/max/saed14nm_1p9m_Cmax.tluplus" ;# TLU+ files to read for parasitic 1
set layer_map_file($parasitic1)         "/home1/14_nmts/14_nmts/tech/star_rc/saed14nm_tf_itf_tluplus.map" ;# layer mapping file between ITF and tech for parasitic 1

set parasitic2				"tlup_min" ;# name of parasitic tech model 2
set tluplus_file($parasitic2)           "/home1/14_nmts/14_nmts/tech/star_rc/min/saed14nm_1p9m_Cmin.tluplus" ;# TLU+ files to read for parasitic 2
set layer_map_file($parasitic2)         "/home1/14_nmts/14_nmts/tech/star_rc/saed14nm_tf_itf_tluplus.map" ;# layer mapping file between ITF and tech for parasitic 2
########################################
## Read parasitic files
########################################

foreach p [array name tluplus_file] {  
	puts "Info: read_parasitic_tech -tlup $tluplus_file($p) -layermap $layer_map_file($p) -name $p"
	read_parasitic_tech -tlup $tluplus_file($p) -layermap $layer_map_file($p) -name $p
}

create_clock -period 1.666 -name MAIN [get_ports rclk]
set ip [remove_from_collection [all_inputs] rclk]
set_input_delay 0.75 -clock MAIN $ip
set_output_delay -clock MAIN 0.75 [get_ports [all_outputs]]
set_load -pin_load 0.004 [get_ports [all_outputs]]
set_max_fanout 200 [current_design]
set_max_transition 0.1 [current_design]
set_max_capacitance 100 [current_design]

set_parasitics_parameters \
	-early_spec tlup_max \
	-late_spec tlup_max \
	-early_temperature 125 \
	-late_temperature 125 \
	-corners {ss0p6v125c}

set_voltage 0.6 -object_list VDD
set_voltage 0 -object_list VSS
set_operating_conditions -max ss0p6v125c -min ff0p7vm40c 

########################################################################
##  Metal Layer Directions
########################################################################
define_user_attribute -type string -name routing_direction  -classes routing_rule
set_attr -objects [get_layers {M2 M4 M6 M8 MRDL}] -name routing_direction -value horizontal
set_attr -objects [get_layers {M1 M5 M7 M9}] -name routing_direction -value vertical



## Lib cell usage restrictions (set_lib_cell_purpose)
#source ../scripts/set_lib_cell_purpose.tcl
set_attr [get_lib_cells */*AO*] dont_use true

set_app_var simplified_verification_mode true
# Define the verification setup file for Formality
set_svf ${OUTPUTS_DIR}/${DESIGN_NAME}.mapped.svf

save_block -as fpu_add/init_design

################################################################

#FLOORPLAN

initialize_floorplan -core_utilization 0.50 -core_offset {1}

set_block_pin_constraints -self -allowed_layers {M3 M5} -sides 2
place_pins -ports [get_ports -filter direction==out]
set_block_pin_constraints -self -allowed_layers {M4 M6} -sides 3
place_pins -ports [get_ports -filter direction==in]

set_attr  [get_ports *] physical_status fixed

#Track
remove_track -layer M1
create_track -layer M1 -coord  1.111 -space 0.037
report_track

################################################################
## connect_pg_net
################################################################
connect_pg_net -automatic

################################################################
## fix macros
################################################################
set_attr [get_cells -physical_context -filter design_type==macro] physical_status fixed

#################################################################
## Boundary and Tap cells
#################################################################
set_boundary_cell_rules \
	-top_boundary_cells [get_lib_cells */*CAPT2] \
	-bottom_boundary_cells [get_lib_cells */*CAPB2] \
	-right_boundary_cell [get_lib_cells */*CAPBIN13] \
	-left_boundary_cell [get_lib_cells */*CAPBTAP6] \
	-prefix ENDCAP

compile_targeted_boundary_cells -target_objects [get_voltage_areas]

#create_tap_cells -lib_cell saed14lvt_ff0p7vm40c/SAEDLVT14_CAPTTAP6 -distance 30 -skip_fixed_cells

check_legality -cells [get_cells bound*]
check_legality -cells [get_cells tap*]

#################################################################
### Save
#################################################################
save_block -as fpd

################################################################

##POWERPLAN

set_attr [get_lib_cells */*TIE*] dont_touch false
set_lib_cell_purpose -include optimization [get_lib_cells */*TIE*]
#################################################################
### Create PG Rails
#################################################################
create_pg_mesh_pattern Mesh_Upper \
	-layers { \
		{ {horizontal_layer: M9} {width: 0.12} {spacing: interleaving} {pitch: 4.8} {offset: 1.6} {trim:true} } \
		{ {vertical_layer: M8} {width: 0.12} {spacing: interleaving} {pitch: 4.8} {offset: 1.6} {trim:true} } \
		}

set_pg_strategy Strategy_Upper \
	-core \
	-pattern { {name: Mesh_Upper} {nets:{VDD VSS}} } \
	-extension { {{stop:design_boundary_and_generate_pin}}}

compile_pg -strategies { Strategy_Upper }
create_pg_vias -nets {VDD VSS} -from_layers M5 -to_layers M9 -drc no_check
#################################################################
### Create Std Cell Rails
#################################################################
create_pg_std_cell_conn_pattern Stdcell -rail_width 0.094 -layers M1
set_pg_strategy StdCell_strat -pattern {{name: Stdcell} {nets: "VDD VSS"}} -core
compile_pg -strategies StdCell_strat
create_pg_vias -nets {VDD VSS} -from_layers M1 -to_layers M8 -drc no_check
#################################################################
### Verification
#################################################################
check_pg_connectivity
check_pg_drc
#################################################################
### Save
#################################################################
save_block -as ppd
################################################################


set_app_options -name place.coarse.max_density -value 0.6
set_app_options -name place.coarse.continue_on_missing_scandef -value true
############################################
## IO Buffers
############################################
catch {add_buffer [get_nets -of [get_ports]] [get_lib_cells */*SAEDRVT*BUF_20] }
magnet_placement [get_ports *]
set_attr [get_cells eco_cell*] physical_status fixed
############################################
#### Placement
############################################
create_placement -congestion
check_legality -verbose
legalize_placement

set_attr [get_lib_cells *lvt*/*] threshold_voltage_group LVT
set_threshold_voltage_group_type -type low_vt LVT
set_multi_vth_constraint -low_vt_percentage 8 -cost cell_count

place_opt -to final_opto
connect_pg_net
save_block -as pd
################################################################

#CTS
set_app_options -name cts.common.user_instance_name_prefix -value clock_opt_cts_
set_app_options -name opt.common.user_instance_name_prefix -value clock_opt_cts_opt_
set_app_options -name cts.common.max_fanout -value 32
##########################################################################################
## Clock_opt CTS flow
##########################################################################################
#clock_opt -from build_clock -to build_clock
#clock_opt -from route_clock -to route_clock
clock_opt
connect_pg_net

set_app_options -name route.detail.timing_driven -value true
set_app_options -name route.track.timing_driven -value true 
set_app_options -name route.track.crosstalk_driven -value true
set_app_options -name route.global.timing_driven -value true
set_app_options -name route.common.global_min_layer_mode -value allow_pin_connection
set_app_options -name route.common.global_max_layer_mode -value soft
set_app_options -name time.si_enable_analysis -value true 
set_app_options -name time.enable_si_timing_windows -value true
set_app_options -name time.enable_ccs_rcv_cap -value true
set_ignored_layers -max_routing_layer M8 -min_routing_layer M2
##########################################################################################
## Routing CTS flow
##########################################################################################
#Either do these seperately 
#route_global
#route_track
#route_detail
#OR
route_auto
##########################################################################################
## Incremental route_detail for fixing routing DRCs
##########################################################################################
#route_detail -incremental true -initial_drc_from_input true
#The below is for the student to understand how much QoR is improved by route_opt
report_qor -summary
route_opt
connect_pg_net
save_block -as route
################################################################
