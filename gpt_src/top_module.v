// ============================================================
// MODULE : bms_satellite_top
// PURPOSE:
//   Complete Satellite BMS Integration Top Module
// ============================================================

`include"active_balancer_unit.v"
`include"fault_processor_unit.v"
`include"power_management_unit.v"
`include"soc_engine.v"
`include"uart_tx.v"
`include"tx_scheduler.v"



module bms_satellite_top (

    input  wire                   clk,
    input  wire                   rst_n,

    input  wire [15:0]            cell_v [0:15],
    input  wire signed [15:0]     pack_i,
    input  wire [11:0]            temp_die,

    output wire                   uart_tx,

    output wire [15:0]            active_tx_sw,
    output wire [15:0]            active_rx_sw,
    output wire [15:0]            passive_sw,

    output wire                   sleep_mode,
    output wire                   fault_trip
);

    // Internal Signals
    wire [7:0] soc_data;
    wire [3:0] fault_code;

    wire tx_busy;
    wire tx_trigger;

    // ========================================================
    // FAULT PROCESSOR
    // ========================================================

    bms_fault_processor u_fault (

        .clk(clk),
        .rst_n(rst_n),
        .cell_v(cell_v),
        .temp(temp_die),

        .fault_out(fault_trip),
        .status_o(fault_code)

    );

    // ========================================================
    // SOC ENGINE
    // ========================================================

    bms_soc_engine u_soc (

        .clk(clk),
        .rst_n(rst_n),
        .pack_i(pack_i),

        .soc_out(soc_data)

    );

    // ========================================================
    // ACTIVE BALANCER
    // ========================================================

    bms_active_balancer u_balancer (

        .clk(clk),
        .rst_n(rst_n),
        .fault_condition(fault_trip),
        .cell_v(cell_v),

        .active_tx_sw(active_tx_sw),
        .active_rx_sw(active_rx_sw),
        .passive_sw(passive_sw)

    );

    // ========================================================
    // POWER MANAGEMENT
    // ========================================================

    bms_power_mgmt u_power (

        .clk(clk),
        .rst_n(rst_n),
        .fault_condition(fault_trip),
        .comm_active(tx_busy),

        .sleep_mode(sleep_mode)

    );

    // ========================================================
    // UART TRANSMIT SCHEDULER
    // ========================================================

    bms_tx_scheduler u_sched (

        .clk(clk),
        .rst_n(rst_n),

        .tx_trigger(tx_trigger)

    );

    // ========================================================
    // UART TRANSMITTER
    // ========================================================

    bms_uart_tx u_uart (

        .clk(clk),
        .rst_n(rst_n),
        .tx_byte(soc_data),
        .tx_start(tx_trigger),

        .tx_wire(uart_tx),
        .tx_busy(tx_busy)

    );

endmodule