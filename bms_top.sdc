==============================================================================

GOLDEN SDC SPECIFICATION: Battery Management System (BMS)

Target Module: bms_system_3lmu_top_enhanced (Absolute Chip Boundary)

Target Node  : 14nm FinFET (100MHz Target Frequency)

==============================================================================

------------------------------------------------------------------------------

1. TIMING ENVIRONMENT SETTINGS & VARIABLES

------------------------------------------------------------------------------

Define 100MHz main clock targeted period

set SYS_CLK_PERIOD       10.0

Set pre-CTS setup uncertainty for jitter and clock tree skew budget

set SYS_CLK_UNCERT_SETUP 0.15

Set hold time uncertainty margin

set SYS_CLK_UNCERT_HOLD  0.05

Limit max slew transition to mitigate 14nm wire resistance

set MAX_TRANSITION       0.15

Limit gate drive pin load capacitance

set MAX_CAPACITANCE      0.05

Budget 30% setup window for external trace delays

set IO_DELAY_MAX         3.0

Define minimum hold delay margin for board trace routing

set IO_DELAY_MIN         0.2

------------------------------------------------------------------------------

2. MASTER CLOCK & GENERATED CLOCK DEFINITIONS

------------------------------------------------------------------------------

Define primary system clock at the top-level chip port

create_clock -name sys_clk -period $SYS_CLK_PERIOD -waveform {0 5.0} [get_ports clk]

Define internally generated SPI master clock divided by 16 inside u_mcu

create_generated_clock -name spi_clk 

-source [get_ports clk] 

-divide_by 16 

[get_pins u_mcu/u_spi_master/sclk_reg/Q]

Apply setup and hold uncertainties to sys_clk and spi_clk

set_clock_uncertainty -setup $SYS_CLK_UNCERT_SETUP [get_clocks {sys_clk spi_clk}]
set_clock_uncertainty -hold  $SYS_CLK_UNCERT_HOLD  [get_clocks {sys_clk spi_clk}]

Enforce clock transition slew limit

set_clock_transition 0.05 [get_clocks {sys_clk spi_clk}]

------------------------------------------------------------------------------

3. CLOCK DOMAIN CROSSING (CDC) ISOLATION

------------------------------------------------------------------------------

Declare main system clock and SPI clock domains as mutually asynchronous

set_clock_groups -asynchronous -group [get_clocks sys_clk] -group [get_clocks spi_clk]

------------------------------------------------------------------------------

4. CHIP IO INTERFACE DELAYS

------------------------------------------------------------------------------

Constrain input delay maximum setup window for non-clock input ports

set_input_delay -clock sys_clk -max $IO_DELAY_MAX [remove_from_collection [all_inputs] [get_ports clk]]

Constrain input delay minimum hold margin for non-clock input ports

set_input_delay -clock sys_clk -min $IO_DELAY_MIN [remove_from_collection [all_inputs] [get_ports clk]]

Constrain output delay maximum setup window for output ports leaving die

set_output_delay -clock sys_clk -max $IO_DELAY_MAX [all_outputs]

Constrain output delay minimum hold margin for output ports leaving die

set_output_delay -clock sys_clk -min $IO_DELAY_MIN [all_outputs]

------------------------------------------------------------------------------

5. ELECTRICAL DRC & AUTOMOTIVE SAFETY EXCEPTIONS

------------------------------------------------------------------------------

Apply max transition constraint across entire design

set_max_transition $MAX_TRANSITION [current_design]

Apply max capacitance constraint across entire design

set_max_capacitance $MAX_CAPACITANCE [current_design]

Set standard output pin load capacitance

set_load 5.0 [all_outputs]

Apply combinational path tightening for instant safety current throttling logic

set_max_delay 5.0 -from [get_ports {pack_current lmu0_temp_die lmu1_temp_die lmu2_temp_die}] -to [get_ports allowed_current]

Set setup and hold checks for Integrated Clock Gating (ICG) cells

set_clock_gating_check -setup 0.15 -hold 0.05 [get_cells -hierarchical logic_clk_en]