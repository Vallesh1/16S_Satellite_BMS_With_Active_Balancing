# ==============================================================================
# GOLDEN SDC SPECIFICATION: Battery Management System (BMS)
# Architecture: Top-Down Hierarchical Constraint
# Target Node: 14nm FinFET (e.g., TSMC 16/14nm, GF 14LPP)
# Top Module: bms_system_3lmu_top_enhanced
# ==============================================================================

# ------------------------------------------------------------------------------
# 1. ENVIRONMENT SETTINGS & VARIABLES (Highly Reusable)
# ------------------------------------------------------------------------------
# Set units to match standard 14nm library characterization
set_units -time ns -resistance kOhm -capacitance pF -voltage V -current mA

# Reusable System Variables
set SYS_CLK_PERIOD       10.0      ;# 100 MHz System Clock
set SYS_CLK_UNCERT_SETUP 0.15      ;# 150ps Setup Uncertainty (14nm Jitter + Skew budget)
set SYS_CLK_UNCERT_HOLD  0.05      ;# 50ps Hold Uncertainty 
set MAX_TRANSITION       0.15      ;# 150ps Max Slew Rate for 14nm
set MAX_CAPACITANCE      0.05      ;# 50fF Max Pin Capacitance
set IO_DELAY_MAX         3.0       ;# 30% of clock period for board trace delay
set IO_DELAY_MIN         0.2       ;# Minimum contamination delay from sensors

# ------------------------------------------------------------------------------
# 2. CLOCK DEFINITIONS
# ------------------------------------------------------------------------------
# Define the Primary Master Clock (100MHz)
create_clock -name sys_clk -period $SYS_CLK_PERIOD -waveform {0 5.0} [get_ports clk]

# Define the Generated SPI Clock (Divided by 16 in the MCU's SPI Master)
create_generated_clock -name spi_clk \
    -source [get_ports clk] \
    -divide_by 16 \
    [get_pins u_mcu/u_spi_master/sclk_reg/Q]

# Apply Clock Uncertainties (Critical for 14nm setup/hold fixing)
set_clock_uncertainty -setup $SYS_CLK_UNCERT_SETUP [get_clocks sys_clk]
set_clock_uncertainty -hold  $SYS_CLK_UNCERT_HOLD  [get_clocks sys_clk]
set_clock_uncertainty -setup $SYS_CLK_UNCERT_SETUP [get_clocks spi_clk]
set_clock_uncertainty -hold  $SYS_CLK_UNCERT_HOLD  [get_clocks spi_clk]

# Define Clock Transition (Ideal network assumption pre-CTS, but constrained)
set_clock_transition 0.05 [get_clocks {sys_clk spi_clk}]

# ------------------------------------------------------------------------------
# 3. CLOCK DOMAIN CROSSINGS (CDC)
# ------------------------------------------------------------------------------
# The BMS Comm Hub (UART/CAN) and SPI Master operate on disjoint frequencies.
# We must instruct the timing engine not to optimize paths between these domains,
# preventing metastability-driven timing violations.
set_clock_groups -asynchronous \
    -group [get_clocks sys_clk] \
    -group [get_clocks spi_clk]

# ------------------------------------------------------------------------------
# 4. I/O TIMING CONSTRAINTS
# ------------------------------------------------------------------------------
# Define the virtual delay outside the chip boundary for Setup (Max) and Hold (Min)

# All Inputs (Analog sensor data, pack_current, etc.)
set_input_delay -clock sys_clk -max $IO_DELAY_MAX [remove_from_collection [all_inputs] [get_ports clk]]
set_input_delay -clock sys_clk -min $IO_DELAY_MIN [remove_from_collection [all_inputs] [get_ports clk]]

# All Outputs (allowed_current, global_fault_code, etc.)
set_output_delay -clock sys_clk -max $IO_DELAY_MAX [all_outputs]
set_output_delay -clock sys_clk -min $IO_DELAY_MIN [all_outputs]

# ------------------------------------------------------------------------------
# 5. 14nm DESIGN RULE CONSTRAINTS (DRC)
# ------------------------------------------------------------------------------
# In 14nm, thick wires have low resistance but high coupling capacitance.
# We restrict the max transition (slew) to ensure signal integrity.
set_max_transition $MAX_TRANSITION [current_design]

# Restrict the maximum load capacitance a single gate can drive.
set_max_capacitance $MAX_CAPACITANCE [current_design]

# Set the environmental load on the output pads (e.g., 5pF for off-chip routing)
set_load 5.0 [all_outputs]

# ------------------------------------------------------------------------------
# 6. ARCHITECTURE-SPECIFIC EXCEPTIONS (Safety & Power)
# ------------------------------------------------------------------------------

# A. Safety Derating Combinational Paths
# The Current Limit Supervisor is combinational logic mapping temperatures to
# the allowed current limits. It must propagate instantly (within 5ns).
set_max_delay 5.0 -from [get_ports *temp_die*]   -to [get_ports allowed_current*]
set_max_delay 5.0 -from [get_ports pack_current*] -to [get_ports allowed_current*]

# B. Clock Gating Checks for Power Management
# The bms_power_mgmt module generates an Integrated Clock Gating (ICG) enable.
# We must enforce setup/hold checks to ensure 'logic_clk_en' does not glitch 
# and clip the clock pulses going into the LMU cores.
set_clock_gating_check -setup 0.15 -hold 0.05 [get_cells -hierarchical *logic_clk_en*]

# C. Multi-Cycle Paths (Datapath Optimization)
# The SOC/SOH engine contains 32-bit multipliers for OCV calculation. 
# Assuming they are architected to take 2 clock cycles to complete:
# set_multicycle_path -setup 2 -from [get_cells *u_soc_soh_engine/*] -to [get_cells *u_soc_soh_engine/*]
# set_multicycle_path -hold 1  -from [get_cells *u_soc_soh_engine/*] -to [get_cells *u_soc_soh_engine/*]

# ==============================================================================
# END OF SDC
# ==============================================================================