`include "bms_uart_tx.v"
`include "bms_spi_slave.v"
`include "bms_can_status_if.v"
`include "bms_comm_hub.v"
`include "bms_adc_if.v"
`include "bms_emi_guard.v"
`include "bms_isolation_monitor.v"
`include "bms_fault_logger.v"
`include "bms_fault_processor.v"
`include "bms_power_mgmt.v"
`include "bms_soc_soh_engine.v"
`include "bms_active_balancer.v"
`include "bms_satellite_top.v"
`include "bms_lmu_wrapper.v"

module bms_lcu_wrapper(
    input  wire         clk,
    input  wire         rst_n,
    input  wire         adc_start,
    input  wire [15:0]  adc_data,
    input  wire         adc_valid,
    input  wire [15:0]  pack_i,
    input  wire [15:0]  pack_v_avg,
    input  wire [15:0]  charge_cycles,
    input  wire [11:0]  temp_die,
    input  wire [191:0] cell_t_bus,
    input  wire [15:0]  iso_resistance,
    input  wire         emi_in,
    input  wire [1:0]   comm_sel,
    input  wire         spi_sclk,
    input  wire         spi_ss_n,
    input  wire         spi_mosi,
    output wire         spi_miso,
    output wire         uart_tx,
    output wire [63:0]  can_frame,
    output wire         can_valid,
    output wire [15:0]  active_tx_sw,
    output wire [15:0]  active_rx_sw,
    output wire [15:0]  passive_sw,
    output wire         fault_trip,
    output wire [7:0]   fault_code,
    output wire [15:0]  soc_out,
    output wire [15:0]  soh_out
);
    bms_lmu_wrapper u_lmu_equivalent (
        .clk(clk), .rst_n(rst_n), .adc_start(adc_start), .adc_data(adc_data), .adc_valid(adc_valid),
        .pack_i(pack_i), .pack_v_avg(pack_v_avg), .charge_cycles(charge_cycles), .temp_die(temp_die),
        .cell_t_bus(cell_t_bus), .iso_resistance(iso_resistance), .emi_in(emi_in), .comm_sel(comm_sel),
        .spi_sclk(spi_sclk), .spi_ss_n(spi_ss_n), .spi_mosi(spi_mosi), .spi_miso(spi_miso), .uart_tx(uart_tx),
        .can_frame(can_frame), .can_valid(can_valid), .active_tx_sw(active_tx_sw), .active_rx_sw(active_rx_sw),
        .passive_sw(passive_sw), .fault_trip(fault_trip), .fault_code(fault_code), .soc_out(soc_out), .soh_out(soh_out)
    );
endmodule
