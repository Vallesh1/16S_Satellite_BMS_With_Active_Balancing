# ==============================================================================
# GOLDEN SDC SPECIFICATION: Battery Management System (BMS)
# Architecture: Bottom-Up Block Level Constraint Matrix
# Target Node: 14nm FinFET 
# Target Module: bms_master_control_unit_enhanced (MCU Spine)
# ==============================================================================

# ------------------------------------------------------------------------------
# 1. TIMING ENVIRONMENT SETTINGS & VARIABLES
# ------------------------------------------------------------------------------
set SYS_CLK_PERIOD       10.0      ;# 100 MHz System Clock Targeted Period
set SYS_CLK_UNCERT_SETUP 0.15      ;# 150ps Clock Tree Jitter + Pre-CTS Skew Budget
set SYS_CLK_UNCERT_HOLD  0.05      ;# 50ps Hold Uncertainty Margin
set MAX_TRANSITION       0.15      ;# 150ps Slew Limit to combat wire resistance
set MAX_CAPACITANCE      0.05      ;# 50fF Gate Drive Pin Cap Limit
set IO_DELAY_MAX         3.0       ;# 30% Setup Window Budget for external traces
set IO_DELAY_MIN         0.2       ;# Minimum hold margin for block routing

# ------------------------------------------------------------------------------
# 2. CLOCK TREE STRUCTURE DEFINITIONS
# ------------------------------------------------------------------------------
# Define Primary Master Clock Node at the MCU input port
create_clock -name sys_clk -period $SYS_CLK_PERIOD -waveform {0 5.0} [get_ports clk]

# At the MCU boundary, the SPI clock is GENERATED internally by the SPI Master instance.
# We must trace it directly to the flip-flop output pin generating the division.
create_generated_clock -name spi_clk \
    -source [get_ports clk] \
    -divide_by 16 \
    [get_pins u_spi_master/sclk_reg/Q]

# Enforce Jitter and Margin Rules to Ensure Structural Closure
set_clock_uncertainty -setup $SYS_CLK_UNCERT_SETUP [get_clocks sys_clk]
set_clock_uncertainty -hold  $SYS_CLK_UNCERT_HOLD  [get_clocks sys_clk]
set_clock_uncertainty -setup $SYS_CLK_UNCERT_SETUP [get_clocks spi_clk]
set_clock_uncertainty -hold  $SYS_CLK_UNCERT_HOLD  [get_clocks spi_clk]

set_clock_transition 0.05 [get_clocks {sys_clk spi_clk}]

# ------------------------------------------------------------------------------
# 3. CLOCK DOMAIN CROSSING (CDC) ISOLATION
# ------------------------------------------------------------------------------
# Declares the 100MHz main clock and the generated SPI clock as asynchronous.
set_clock_groups -asynchronous -group [get_clocks sys_clk] -group [get_clocks spi_clk]

# ------------------------------------------------------------------------------
# 4. CHIP IO INTERFACE DELAYS (Block Boundary)
# ------------------------------------------------------------------------------
# Constrain all inputs except the main clock
set_input_delay -clock sys_clk -max $IO_DELAY_MAX [remove_from_collection [all_inputs] [get_ports clk]]
set_input_delay -clock sys_clk -min $IO_DELAY_MIN [remove_from_collection [all_inputs] [get_ports clk]]

# Constrain all outputs leaving the MCU macro
set_output_delay -clock sys_clk -max $IO_DELAY_MAX [all_outputs]
set_output_delay -clock sys_clk -min $IO_DELAY_MIN [all_outputs]

# ------------------------------------------------------------------------------
# 5. 14nm ELECTRICAL DESIGN RULE CONSTRAINTS (DRC)
# ------------------------------------------------------------------------------
set_max_transition $MAX_TRANSITION [current_design]
set_max_capacitance $MAX_CAPACITANCE [current_design]
set_load 5.0 [all_outputs]

# ------------------------------------------------------------------------------
# 6. ARCHITECTURE-SPECIFIC EXCEPTIONS & TIMING STRATEGIES
# ------------------------------------------------------------------------------
# SAFETY CRITICAL: Combinational path tightening for instant current throttling.
# Ensures the dynamic derating logic synthesizes using fast, low-Vt standard cells.
# Note: 'max_temp_seen' is an internal register/output, so it is inherently constrained 
# by the clock period. 'pack_current' is a direct input, so we explicitly constrain its feedthrough path.
set_max_delay 5.0 -from [get_ports pack_current*] -to [get_ports allowed_current*]