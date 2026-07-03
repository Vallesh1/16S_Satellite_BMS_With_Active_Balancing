set_host_options -max_cores 8

######################################################################
# Global Variables & Environment Setup
######################################################################
set DESIGN_NAME bms_lmu_wrapper

set OUTPUTS_DIR "/home1/IITR_PD3/MulukuriVNath/Documents/16S_Satellite_BMS_With_Active_Balancing/Synthesis/lmu/outputs"

set SCRIPTS "/home1/IITR_PD3/MulukuriVNath/Documents/16S_Satellite_BMS_With_Active_Balancing/Synthesis/lmu/scripts"

set DESIGN_STYLE hier

set PHYSICAL_HIERARCHY_LEVEL bottom

set DC_BLOCK_ABSTRACTION_DESIGNS ""

set DDC_HIER_DESIGNS ""

set UPF_MODE golden

set UPF_FILE ${SCRIPTS}/${DESIGN_NAME}.upf

set DCRM_NDM_LIBRARY_NAME ${DESIGN_NAME}.ndm

set TECH_FILE "/home1/14_nmts/14_nmts/tech/milkyway/saed14nm_1p9m_mw.tf"

set REFERENCE_LIBRARY             "/home1/14_nmts/14_nmts/stdcell_hvt/ndm/saed14hvt_frame_only.ndm \
/home1/14_nmts/14_nmts/stdcell_slvt/ndm/saed14slvt_frame_only.ndm \
/home1/14_nmts/14_nmts/stdcell_rvt/ndm/saed14rvt_frame_only.ndm \
/home1/14_nmts/14_nmts/stdcell_lvt/ndm/saed14lvt_frame_only.ndm"


######################################################################
# RTL Variables & Search Paths
######################################################################
set rtl_path {}
set rtl_path_1 "/home1/IITR_PD3/MulukuriVNath/Documents/16S_Satellite_BMS_With_Active_Balancing/bms_complete/rtl/common"
set rtl_path_2 "/home1/IITR_PD3/MulukuriVNath/Documents/16S_Satellite_BMS_With_Active_Balancing/bms_complete/rtl/lmu"
set rtl_path_3 "/home1/IITR_PD3/MulukuriVNath/Documents/16S_Satellite_BMS_With_Active_Balancing/bms_complete/rtl/mcu"
set rtl_path_4 "/home1/IITR_PD3/MulukuriVNath/Documents/16S_Satellite_BMS_With_Active_Balancing/bms_complete/rtl/top"
set_app_var search_path " $rtl_path_1 $rtl_path_2 $rtl_path_3 $rtl_path_4 "

# Append standard paths and RTL targets to the DC search path
set_app_var search_path "$search_path $iop/include $rtl_path "

if {$DESIGN_STYLE == "hier" && $PHYSICAL_HIERARCHY_LEVEL == "top"} {
  # For a hierarchical flow, add the block-level results directories to the
  # search path to find the block-level design files.
  set HIER_DESIGNS "${DDC_HIER_DESIGNS} ${DC_BLOCK_ABSTRACTION_DESIGNS}"
  foreach design $HIER_DESIGNS {
    lappend search_path ../../${design}/outputs/
  }
}

######################################################################
# 1. READ & LINK THE DESIGN 
######################################################################
# Analyze all Verilog files (Adjust paths to match your exact directory structure)
puts "RM-info: Analyzing RTL sources..."
analyze -format verilog [list \
    rtl/common/bms_comm_hub.v \
    rtl/common/bms_spi_slave.v \
    rtl/common/bms_uart_tx.v \
    rtl/common/bms_can_status_if.v \
    rtl/lmu/bms_adc_if.v \
    rtl/lmu/bms_fault_processor.v \
    rtl/lmu/bms_soc_soh_engine.v \
    rtl/lmu/bms_active_balancer.v \
    rtl/lmu/bms_isolation_monitor.v \
    rtl/lmu/bms_emi_guard.v \
    rtl/lmu/bms_power_mgmt.v \
    rtl/lmu/bms_fault_logger.v \
    rtl/lmu/bms_satellite_top.v \
    rtl/lmu/bms_lmu_wrapper.v \
    rtl/mcu/bms_spi_master.v \
    rtl/mcu/bms_current_limit_supervisor.v \
    rtl/mcu/bms_master_control_unit_enhanced.v \
    rtl/top/bms_system_3lmu_top_enhanced.v \
]

puts "RM-info: Elaborating top level design..."
elaborate $DESIGN_NAME
current_design $DESIGN_NAME

puts "RM-info: Linking design objects in database..."
link

######################################################################
# 2. LOAD POWER INTENT (UPF)
######################################################################
# Must be executed post-link so power domains can map to physical instances
if {$UPF_MODE != "none"} {
  puts "RM-info: Loading Golden UPF..."
  load_upf $UPF_FILE
}

######################################################################
# 3. LOAD TIMING CONSTRAINTS (SDC)
######################################################################
# Now that the ports and pins exist in memory, loading the SDC will flawlessly
# apply your 14nm constraints (like get_ports clk) without SEL-004 errors.
puts "RM-info: Loading SDC Constraints..."
read_sdc constraints/sdc/bms_14nm_top_down.sdc

######################################################################
# 4. COMPILATION
######################################################################
puts "RM-info: Commencing advanced compilation..."
# Use compile_ultra for advanced 14nm optimization. 
# -gate_clock auto-inserts clock gating logic to save dynamic power.
compile_ultra -gate_clock -no_autoungroup

######################################################################
# 5. WRITE OUT COMPILED RESULTS
######################################################################
if {$DESIGN_STYLE == "hier" && $PHYSICAL_HIERARCHY_LEVEL == "top"} {
  # Remove the hierarchical designs before writing out the top-level mapped ddc design
  if {![shell_is_in_topographical_mode]} {
    if {[get_designs -quiet ${DDC_HIER_DESIGNS}] != "" } {
      remove_design -hierarchy [get_designs -quiet ${DDC_HIER_DESIGNS}]
    }
  }

  # Write out ddc mapped top-level design
  write_file -format ddc -hierarchy -output ${OUTPUTS_DIR}/${DESIGN_NAME}.mapped.ddc

} else {

  if {$DESIGN_STYLE == "flat"} {
    puts "RM-info: Writing out flat design"
  } else {
    puts "RM-info: Writing out bottom-level design"
    create_block_abstraction
  }

  # Write PG (Power/Ground) Verilog netlist if using UPF
  if {$UPF_MODE == "golden"} {
    write_file -format verilog -hierarchy -pg -output ${OUTPUTS_DIR}/${DESIGN_NAME}.mapped.pg.v
  }
  
  # Standard Verilog Netlist & DDC binary
  write_file -format verilog -hierarchy -output ${OUTPUTS_DIR}/${DESIGN_NAME}.mapped.v
  write_file -format ddc     -hierarchy -output ${OUTPUTS_DIR}/${DESIGN_NAME}.mapped.ddc
}

######################################################################
# 6. WRITE OUT SUPPLEMENTAL UPF
######################################################################
if {$UPF_MODE != "none"} {
  set save_upf_cmd "save_upf"
  if {$UPF_MODE == "golden"} {
    lappend save_upf_cmd -include_supply_exceptions
    lappend save_upf_cmd -supplemental ${OUTPUTS_DIR}/${DESIGN_NAME}.supplement.upf
  }
  eval $save_upf_cmd
}

puts "RM-info: BMS Synthesis Flow Completed Successfully."
