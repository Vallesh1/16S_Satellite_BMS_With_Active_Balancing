module bms_satellite_top (

    input  wire                   clk,
    input  wire                   rst_n,

    input  wire [15:0]            cell_v [0:15],
    input  wire [15:0]            pack_i,
    input  wire [11:0]            temp_die,

    input  wire                   iso_rx,
    output wire                   iso_tx,

    output wire [15:0]            active_tx_sw,
    output wire [15:0]            active_rx_sw,
    output wire [15:0]            passive_sw,

    output wire                   fault_trip
);

    wire [15:0] current_soc;
    wire [3:0]  fault_code;

    wire sleep_mode;
    wire tx_busy;

    wire comm_active;

    assign comm_active = tx_busy;

    bms_fault_processor u_fault (
        .clk(clk),
        .rst_n(rst_n),
        .cell_v(cell_v),
        .temp(temp_die),
        .fault_out(fault_trip),
        .status_o(fault_code)
    );

    bms_soc_engine u_soc (
        .clk(clk),
        .rst_n(rst_n),
        .pack_i(pack_i),
        .soc_out(current_soc)
    );

    bms_active_balancer u_balancer (
        .clk(clk),
        .rst_n(rst_n),
        .fault_condition(fault_trip),
        .cell_v(cell_v),
        .active_tx_sw(active_tx_sw),
        .active_rx_sw(active_rx_sw),
        .passive_sw(passive_sw)
    );

    bms_power_mgmt u_pwr (
        .clk(clk),
        .rst_n(rst_n),
        .fault_condition(fault_trip),
        .comm_active(comm_active),
        .sleep_mode(sleep_mode)
    );

    bms_comm_unit u_uart (
        .clk(clk),
        .rst_n(rst_n),
        .tx_byte(current_soc[7:0]),
        .tx_en(1'b1),
        .tx_wire(iso_tx),
        .tx_busy(tx_busy)
    );

endmodule