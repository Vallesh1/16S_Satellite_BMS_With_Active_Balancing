# ==============================================================================
# GOLDEN SDC SPECIFICATION: Battery Management System (BMS)
# Architecture: Top-Down Hierarchical Constraint Matrix
# Target Node: 14nm FinFET 
# Top Module: bms_system_3lmu_top_enhanced
# ==============================================================================

# ------------------------------------------------------------------------------
# 1. TIMING ENVIRONMENT SETTINGS & VARIABLES
# ------------------------------------------------------------------------------
set SYS_CLK_PERIOD       10.0      ;# 100 MHz System Clock Targeted Period
set SYS_CLK_UNCERT_SETUP 0.15      ;# 150ps Clock Tree Jitter + Pre-CTS Skew Budget
set SYS_CLK_UNCERT_HOLD  0.05      ;# 50ps Hold Uncertainty Margin
set MAX_TRANSITION       0.15      ;# 150ps Slew Limit to combat wire resistance
set MAX_CAPACITANCE      0.05      ;# 50fF Gate Drive Pin Cap Limit
set IO_DELAY_MAX         3.0       ;# 30% Setup Window Budget for PCB traces
set IO_DELAY_MIN         0.2       ;# Minimum hold margin for board routing

# ------------------------------------------------------------------------------
# 2. CLOCK TREE STRUCTURE DEFINITIONS
# ------------------------------------------------------------------------------
# Define Primary Master Clock Node
create_clock -name sys_clk -period $SYS_CLK_PERIOD -waveform {0 5.0} [get_ports clk]

# Define Synchronous Divided SPI Master Clock Register Output
create_generated_clock -name spi_clk \
    -source [get_ports clk] \
    -divide_by 16 \
    [get_pins u_mcu/u_spi_master/sclk_reg/Q]

# Enforce Jitter and Margin Rules to Ensure Structural Closure
set_clock_uncertainty -setup $SYS_CLK_UNCERT_SETUP [get_clocks sys_clk]
set_clock_uncertainty -hold  $SYS_CLK_UNCERT_HOLD  [get_clocks sys_clk]
set_clock_uncertainty -setup $SYS_CLK_UNCERT_SETUP [get_clocks spi_clk]
set_clock_uncertainty -hold  $SYS_CLK_UNCERT_HOLD  [get_clocks spi_clk]

set_clock_transition 0.05 [get_clocks {sys_clk spi_clk}]

# ------------------------------------------------------------------------------
# 3. CLOCK DOMAIN CROSSING (CDC) ISOLATION
# ------------------------------------------------------------------------------
# Declares the 100MHz main clock and the divided SPI transfers as asynchronous.
# Cuts unneeded path optimization to focus cell mapping on real critical paths.
set_clock_groups -asynchronous -group [get_clocks sys_clk] -group [get_clocks spi_clk]

# ------------------------------------------------------------------------------
# 4. CHIP IO INTERFACE DELAYS
# ------------------------------------------------------------------------------
set_input_delay -clock sys_clk -max $IO_DELAY_MAX [remove_from_collection [all_inputs] [get_ports clk]]
set_input_delay -clock sys_clk -min $IO_DELAY_MIN [remove_from_collection [all_inputs] [get_ports clk]]

set_output_delay -clock sys_clk -max $IO_DELAY_MAX [all_outputs]
set_output_delay -clock sys_clk -min $IO_DELAY_MIN [all_outputs]

# ------------------------------------------------------------------------------
# 5. 14nm ELECTRICAL DESIGN RULE CONSTRAINTS (DRC)
# ------------------------------------------------------------------------------
set_max_transition $MAX_TRANSITION [current_design]
set_max_capacitance $MAX_CAPACITANCE [current_design]
set_load 5.0 [all_outputs]

# ------------------------------------------------------------------------------
# 6. AUTOMOTIVE SAFETY EXCEPTIONS & TIMING STRATEGIES
# ------------------------------------------------------------------------------
# Combinational path tightening for instant safety current throttling
set_max_delay 5.0 -from [get_ports *temp_die*]   -to [get_ports allowed_current*]
set_max_delay 5.0 -from [get_ports pack_current*] -to [get_ports allowed_current*]

# Setup and Hold window guardbands around internal Integrated Clock Gating (ICG)
set_clock_gating_check -setup 0.15 -hold 0.05 [get_cells -hierarchical *logic_clk_en*]