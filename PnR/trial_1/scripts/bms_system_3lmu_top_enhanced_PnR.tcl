# ==============================================================================
#   SYNOPSYS FUSION COMPILER (FC) MASTER PnR SCRIPT
#   Target Module : bms_system_3lmu_top_enhanced (Top Chip Boundary)
#   Target Node   : SAED 14nm FinFET (0.6V / 125C SS Corner)
#   Flow          : Multi-Voltage UPF 2.1, Floorplanning, PNS, Place_Opt, Clock_Opt, Route_Opt
# ==============================================================================
# 
# ------------------------------------------------------------------------------
# 1. GLOBAL VARIABLES & PATH SETUP
# ------------------------------------------------------------------------------
# 
# Set maximum CPU core multithreading for parallel execution
set_host_options -max_cores 8
# 
# Design variables (Directory paths are left clean for user customization)
set DESIGN_NAME           "bms_system_3lmu_top_enhanced"
set WORK_DIR              "/home1/IITR_PD3/MulukuriVNath/Documents/16S_Satellite_BMS_With_Active_Balancing/PnR/trial_1/work"
set OUTPUTS_DIR           "/home1/IITR_PD3/MulukuriVNath/Documents/16S_Satellite_BMS_With_Active_Balancing/PnR/trial_1/outputs"
set SCRIPT_DIR            "/home1/IITR_PD3/MulukuriVNath/Documents/16S_Satellite_BMS_With_Active_Balancing/PnR/trial_1/scripts"
# 
# SAED 14nm NDM Reference Libraries and Technology Files
set REFERENCE_LIBRARY     "/home1/14_nmts/14_nmts/stdcell_hvt/ndm/saed14hvt_frame_only.ndm \
/home1/14_nmts/14_nmts/stdcell_slvt/ndm/saed14slvt_frame_only.ndm \
/home1/14_nmts/14_nmts/stdcell_rvt/ndm/saed14rvt_frame_only.ndm \
/home1/14_nmts/14_nmts/stdcell_lvt/ndm/saed14lvt_frame_only.ndm"
# 
set LINK_LIBRARY          "/home1/14_nmts/14_nmts/stdcell_lvt/db_ccs/saed14lvt_ff0p7vm40c.db \
/home1/14_nmts/14_nmts/stdcell_rvt/db_ccs/saed14rvt_ff0p7vm40c.db \
/home1/14_nmts/14_nmts/stdcell_rvt/db_ccs/saed14rvt_ss0p6v125c.db \
/home1/14_nmts/14_nmts/stdcell_lvt/db_ccs/saed14lvt_ss0p6v125c.db "
# 
set TECH_FILE             "/home1/14_nmts/14_nmts/tech/milkyway/saed14nm_1p9m_mw.tf"
# 
# Input Files generated during Logic Synthesis
set VERILOG_NETLIST_FILES "/home1/IITR_PD3/MulukuriVNath/Documents/16S_Satellite_BMS_With_Active_Balancing/synthesis/top/outputs/bms_system_3lmu_top_enhanced.mapped.v"
set UPF_FILE              "/home1/IITR_PD3/MulukuriVNath/Documents/16S_Satellite_BMS_With_Active_Balancing/PnR/trial_1/scripts/bms_system_3lmu_top_enhanced.golden.upf"
set UPF_SUPPLEMENTAL_FILE "/home1/IITR_PD3/MulukuriVNath/Documents/16S_Satellite_BMS_With_Active_Balancing/PnR/trial_1/scripts/bms_system_3lmu_top_enhanced.supplemental.upf"
set SDC_FILE              "/home1/IITR_PD3/MulukuriVNath/Documents/16S_Satellite_BMS_With_Active_Balancing/PnR/trial_1/scripts/bms_system_3lmu_top_enhanced.sdc
# 
# Define internal NDM design library container path
set DESIGN_LIBRARY        "${WORK_DIR}/${DESIGN_NAME}_fc_lib"
# 
# ------------------------------------------------------------------------------
# 2. DESIGN LIBRARY INITIALIZATION & NETLIST IMPORT
# ------------------------------------------------------------------------------
# 
# Enable Golden UPF Flow mode prior to library container creation
set_app_options -name mv.upf.enable_golden_upf -value true
# 
# Create Fusion Compiler design library container referencing NDM and TF files
create_lib -ref_libs $REFERENCE_LIBRARY -technology $TECH_FILE$DESIGN_LIBRARY
# 
# Read gate-level Verilog netlist and establish active top module hierarchy
read_verilog ${VERILOG_NETLIST_FILES}
current_design ${DESIGN_NAME}
link
# 
# Save initial imported database checkpoint
save_block -as ${DESIGN_NAME}/01_imported
# 
# ------------------------------------------------------------------------------
# 3. POWER INTENT (UPF 2.1) LOADING & COMMIT
# ------------------------------------------------------------------------------
# 
# Load Golden UPF power intent specification
if {[file exists [which $UPF_FILE]]} {
puts "FC-info: Loading Golden UPF file: $UPF_FILE"
load_upf $UPF_FILE

# Load Supplemental UPF file if available from synthesis output
if {[file exists [which $UPF_SUPPLEMENTAL_FILE]]} {
    puts "FC-info: Loading Supplemental UPF file: $UPF_SUPPLEMENTAL_FILE"
    load_upf -supplemental $UPF_SUPPLEMENTAL_FILE
}

# Commit multi-voltage power architecture into FC database
puts "FC-info: Committing Multi-Voltage Power Intent..."
commit_upf


} else {
puts "FC-error: UPF File ($UPF_FILE) not found!"
}
# 
# ------------------------------------------------------------------------------
# 4. VOLTAGE & TIMING CONSTRAINTS SETUP
# ------------------------------------------------------------------------------
# 
# Explicitly set operating voltages for primary VDD and switchable LMU rails
set_voltage 0.6 -object_list {VDD VDD_LMU0_SW VDD_LMU1_SW VDD_LMU2_SW}
set_voltage 0.0 -object_list {VSS}
# 
# Read StarRC TLU+ Parasitic Models for 14nm FinFET extraction
# ==============================================================================
# 1. READ STARRC TLU+ PARASITIC MODELS (MAX & MIN)
# ==============================================================================

# Define Parasitic Model 1 (Setup / Max / Cmax)
set parasitic1 "tlup_max"
set tluplus_file($parasitic1)   "/home1/14_nmts/14_nmts/tech/star_rc/max/saed14nm_1p9m_Cmax.tluplus"
set layer_map_file($parasitic1) "/home1/14_nmts/14_nmts/tech/star_rc/saed14nm_tf_itf_tluplus.map"

# Define Parasitic Model 2 (Hold / Min / Cmin)
set parasitic2 "tlup_min"
set tluplus_file($parasitic2)   "/home1/14_nmts/14_nmts/tech/star_rc/min/saed14nm_1p9m_Cmin.tluplus"
set layer_map_file($parasitic2) "/home1/14_nmts/14_nmts/tech/star_rc/saed14nm_tf_itf_tluplus.map"

# Read both TLU+ files using an array loop
foreach p [array names tluplus_file] {
    if {[file exists [which $tluplus_file($p)]]} {
        puts "FC-info: Reading StarRC TLU+ Parasitic Tech file for $p..."
        read_parasitic_tech \
            -tlup $tluplus_file($p) \
            -layermap $layer_map_file($p) \
            -name $p
    } else {
        puts "FC-warning: TLU+ Parasitic File ($tluplus_file($p)) not found!"
    }
}

# Apply parasitic parameters linking early (hold) to min spec and late (setup) to max spec
set_parasitics_parameters \
    -early_spec $parasitic2 \
    -late_spec $parasitic1 \
    -early_temperature -40 \
    -late_temperature 125 \
    -corners {ss0p6v125c}

# ==============================================================================
# 2. READ TOP-LEVEL GOLDEN SDC CONSTRAINTS
# ==============================================================================

if {[file exists [which $SDC_FILE]]} {
    puts "FC-info: Sourcing Golden SDC file: $SDC_FILE"
    read_sdc $SDC_FILE
} else {
    puts "FC-error: SDC file ($SDC_FILE) not found!"
}
# 
# ------------------------------------------------------------------------------
# 5. METAL LAYER ROUTING DIRECTIONS & CELL RULES
# ------------------------------------------------------------------------------
# 
# Configure 14nm FinFET preferred routing directions across metal stack
set_attr -objects [get_layers {M2 M4 M6 M8 MRDL}] -name routing_direction -value horizontal
set_attr -objects [get_layers {M1 M3 M5 M7 M9}]   -name routing_direction -value vertical
# 
# Restrict cells prone to signal integrity issues or crosstalk noise
set_attr [get_lib_cells */AO] dont_use true
# 
# Save constrained design database checkpoint
save_block -as ${DESIGN_NAME}/02_constrained
# 
# ------------------------------------------------------------------------------
# 6. FLOORPLANNING & VOLTAGE AREA ALLOCATION
# ------------------------------------------------------------------------------
# 
# Initialize floorplan boundary at 55% utilization to leave space for UPF cells
puts "FC-info: Initializing Floorplan Area at 55% Core Utilization..."
initialize_floorplan -core_utilization 0.55 -core_offset {5.0 5.0 5.0 5.0}
# 
# Allocate physical voltage islands for switchable LMU satellite domains
puts "FC-info: Allocating Physical Voltage Areas for LMU Satellites..."
create_voltage_area -power_domain PD_LMU0 -region {{10 10} {150 150}}
create_voltage_area -power_domain PD_LMU1 -region {{170 10} {310 150}}
create_voltage_area -power_domain PD_LMU2 -region {{330 10} {470 150}}
# 
# Constrain and place top-level IO output ports on intermediate metal layers
set_block_pin_constraints -self -allowed_layers {M3 M5} -sides 2
place_pins -ports [get_ports -filter direction==out]
# 
# Constrain and place top-level IO input ports on intermediate metal layers
set_block_pin_constraints -self -allowed_layers {M4 M6} -sides 3
place_pins -ports [get_ports -filter direction==in]
# 
# Fix physical status of all placed ports
set_attr [get_ports *] physical_status fixed
# 
# ------------------------------------------------------------------------------
# 7. TAP & BOUNDARY CELL INSERTION (14nm FinFET DRC Rules)
# ------------------------------------------------------------------------------
# 
# Configure endcap rules to satisfy 14nm manufacturing layout constraints
puts "FC-info: Inserting Boundary Endcaps and Well Taps..."
set_boundary_cell_rules 

-top_boundary_cells [get_lib_cells */*CAPT2] 

-bottom_boundary_cells [get_lib_cells */*CAPB2] 

-right_boundary_cell [get_lib_cells */*CAPBIN13] 

-left_boundary_cell [get_lib_cells */*CAPBTAP6] 

-prefix ENDCAP
# 
# Instantiate targeted boundary cells across all voltage areas
compile_targeted_boundary_cells -target_objects [get_voltage_areas]
# 
# Save floorplanned design database checkpoint
save_block -as ${DESIGN_NAME}/03_floorplanned
# 
# ------------------------------------------------------------------------------
# 8. POWER NETWORK SYNTHESIS (PNS / PG PLAN)
# ------------------------------------------------------------------------------
# 
# Connect logical power and ground nets automatically
puts "FC-info: Synthesizing Global and Switched Power Grids..."
connect_pg_net -automatic
# 
# Define global upper metal power mesh pattern on M8 (Vertical) and M9 (Horizontal)
create_pg_mesh_pattern Mesh_Upper 

-layers { 

{ {horizontal_layer: M9} {width: 0.24} {spacing: interleaving} {pitch: 8.0} {offset: 2.0} {trim:true} } 

{ {vertical_layer: M8}   {width: 0.24} {spacing: interleaving} {pitch: 8.0} {offset: 2.0} {trim:true} } 

}
# 
# Apply upper power mesh strategy across core region
set_pg_strategy Strategy_Upper 

-core 

-pattern { {name: Mesh_Upper} {nets:{VDD VSS}} } 

-extension { {{stop:design_boundary_and_generate_pin}}}
# 
# Compile upper metal power grid mesh
compile_pg -strategies { Strategy_Upper }
# 
# Create standard cell followpin rails on layer M1
create_pg_std_cell_conn_pattern Stdcell_Rails -rail_width 0.094 -layers M1
set_pg_strategy StdCell_Global -pattern {{name: Stdcell_Rails} {nets: "VDD VSS"}} -core
compile_pg -strategies StdCell_Global
# 
# Synthesize via arrays connecting upper M8 mesh down to M1 followpin rails
create_pg_vias -nets {VDD VSS} -from_layers M1 -to_layers M8 -drc no_check
# 
# Perform power grid connectivity and DRC verification checks
check_pg_connectivity
check_pg_drc
# 
# Save powerplanned design database checkpoint
save_block -as ${DESIGN_NAME}/04_powerplanned
# 
# ------------------------------------------------------------------------------
# 9. CONGESTION-DRIVEN PLACEMENT & MULTI-VTH OPTIMIZATION
# ------------------------------------------------------------------------------
# 
# Configure coarse placement density app options
puts "FC-info: Executing Coarse Placement & Optimization (place_opt)..."
set_app_options -name place.coarse.max_density -value 0.60
set_app_options -name place.coarse.continue_on_missing_scandef -value true
# 
# Set Multi-Vth cell rules to balance leakage power versus setup timing
set_attr [get_lib_cells lvt/*] threshold_voltage_group LVT
set_threshold_voltage_group_type -type low_vt LVT
set_multi_vth_constraint -low_vt_percentage 10 -cost cell_count
# 
# Perform coarse placement and verify layout legality
create_placement -congestion
check_legality -verbose
legalize_placement
# 
# Run unified placement optimization engine
place_opt -to final_opto
connect_pg_net
# 
# Save placement checkpoint
save_block -as ${DESIGN_NAME}/05_placement
# 
# ------------------------------------------------------------------------------
# 10. CLOCK TREE SYNTHESIS (CTS / clock_opt)
# ------------------------------------------------------------------------------
# 
# Set clock tree synthesis application options
puts "FC-info: Building Clock Trees for sys_clk & spi_clk (clock_opt)..."
set_app_options -name cts.common.user_instance_name_prefix -value cts_
set_app_options -name opt.common.user_instance_name_prefix -value cts_opt_
set_app_options -name cts.common.max_fanout -value 32
# 
# Execute unified clock tree synthesis and clock domain optimization
clock_opt
connect_pg_net
# 
# Save CTS checkpoint
save_block -as ${DESIGN_NAME}/06_cts
# 
# ------------------------------------------------------------------------------
# 11. GLOBAL & DETAIL ROUTING & POST-ROUTE OPTIMIZATION
# ------------------------------------------------------------------------------
# 
# Set signal integrity, crosstalk, and timing-driven auto-routing app options
puts "FC-info: Executing Auto-Routing and Crosstalk Optimization..."
set_app_options -name route.detail.timing_driven -value true
set_app_options -name route.track.timing_driven -value true
set_app_options -name route.track.crosstalk_driven -value true
set_app_options -name route.global.timing_driven -value true
set_app_options -name time.si_enable_analysis -value true
set_app_options -name time.enable_ccs_rcv_cap -value true
# 
# Restrict signal routing layer stack between M2 and M8
set_ignored_layers -max_routing_layer M8 -min_routing_layer M2
# 
# Execute global, track, and detail auto-routing
route_auto
# 
# Run post-route timing closure and DRC optimization
puts "FC-info: Running Post-Route Optimization (route_opt)..."
route_opt
# 
# Re-connect power/ground nets and report QoR summary
connect_pg_net
report_qor -summary
# 
# Save final routed checkpoint
save_block -as ${DESIGN_NAME}/07_routed
# 
# ------------------------------------------------------------------------------
# 12. STREAM-OUT GDSII & NETLIST GENERATION
# ------------------------------------------------------------------------------
# 
# Export physical layout GDSII stream file
puts "FC-info: Streaming out Final GDSII and Sign-Off Netlist..."
write_gds -design ${DESIGN_NAME} 

-layer_map "" 

${OUTPUTS_DIR}/${DESIGN_NAME}.gds
# 
# Export post-route Verilog netlist containing explicit PG pins
write_verilog -pg -hierarchy ${OUTPUTS_DIR}/${DESIGN_NAME}.pg.v
# 
puts "FC-info: BMS Top-Level Physical Design Flow Completed Successfully!"