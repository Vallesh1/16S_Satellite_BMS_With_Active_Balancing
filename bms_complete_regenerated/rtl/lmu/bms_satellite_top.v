module bms_satellite_top #(
    parameter CELL_COUNT = 16
)(
    input  wire                     clk,
    input  wire                     rst_n,
    input  wire                     adc_start,
    input  wire [15:0]              adc_data,
    input  wire                     adc_valid,
    input  wire [15:0]              pack_i,
    input  wire [15:0]              pack_v_avg,
    input  wire [15:0]              charge_cycles,
    input  wire [11:0]              temp_die,
    input  wire [CELL_COUNT*12-1:0] cell_t_bus,
    input  wire [15:0]              iso_resistance,
    input  wire                     emi_in,
    input  wire [1:0]               comm_sel,
    input  wire                     spi_sclk,
    input  wire                     spi_ss_n,
    input  wire                     spi_mosi,
    output wire                     spi_miso,
    output wire                     uart_tx,
    output wire [63:0]              can_frame,
    output wire                     can_valid,
    output wire [CELL_COUNT-1:0]    active_tx_sw,
    output wire [CELL_COUNT-1:0]    active_rx_sw,
    output wire [CELL_COUNT-1:0]    passive_sw,
    output wire                     fault_trip,
    output wire [7:0]               fault_code,
    output wire [15:0]              soc_out,
    output wire [15:0]              soh_out
);
    wire logic_clk_en;
    wire sleep_mode;
    wire adc_busy;
    wire adc_frame_done;
    wire [4:0] sample_idx;
    wire [CELL_COUNT*16-1:0] cell_v_bus;
    wire [CELL_COUNT*16-1:0] cell_v_red_bus;
    wire emi_alert;
    wire iso_fault;
    wire [15:0] iso_margin;
    wire [CELL_COUNT-1:0] ov_map;
    wire [CELL_COUNT-1:0] uv_map;
    wire sensor_mismatch;
    wire comm_active;
    wire balance_busy;
    wire [3:0] high_id;
    wire [3:0] low_id;
    reg [15:0] timestamp;
    reg fault_trip_d;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            timestamp <= 16'd0;
        else
            timestamp <= timestamp + 16'd1;
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            fault_trip_d <= 1'b0;
        else
            fault_trip_d <= fault_trip;
    end

    bms_adc_if u_adc (
        .clk(clk),
        .rst_n(rst_n),
        .start(adc_start),
        .adc_data(adc_data),
        .adc_valid(adc_valid),
        .adc_busy(adc_busy),
        .sample_idx(sample_idx),
        .cell_v_bus(cell_v_bus),
        .cell_v_red_bus(cell_v_red_bus),
        .frame_done(adc_frame_done)
    );

    bms_emi_guard u_emi (
        .clk(clk),
        .rst_n(rst_n),
        .emi_in(emi_in),
        .emi_alert(emi_alert)
    );

    bms_isolation_monitor u_iso (
        .clk(clk),
        .rst_n(rst_n),
        .iso_resistance(iso_resistance),
        .iso_fault(iso_fault),
        .iso_margin(iso_margin)
    );

    bms_fault_processor u_fault (
        .clk(clk),
        .rst_n(rst_n),
        .en(logic_clk_en),
        .cell_v_bus(cell_v_bus),
        .cell_v_red_bus(cell_v_red_bus),
        .temp(temp_die),
        .iso_fault(iso_fault),
        .emi_alert(emi_alert),
        .fault_out(fault_trip),
        .fault_code(fault_code),
        .ov_map(ov_map),
        .uv_map(uv_map),
        .sensor_mismatch(sensor_mismatch)
    );

    bms_soc_soh_engine u_soc_soh (
        .clk(clk),
        .rst_n(rst_n),
        .en(logic_clk_en),
        .pack_i(pack_i),
        .pack_v_avg(pack_v_avg),
        .charge_cycles(charge_cycles),
        .soc_out(soc_out),
        .soh_out(soh_out)
    );

    bms_active_balancer u_bal (
        .clk(clk),
        .rst_n(rst_n),
        .en(logic_clk_en & (~fault_trip)),
        .cell_v_bus(cell_v_bus),
        .cell_t_bus(cell_t_bus),
        .active_tx_sw(active_tx_sw),
        .active_rx_sw(active_rx_sw),
        .passive_sw(passive_sw),
        .balance_busy(balance_busy),
        .high_id_o(high_id),
        .low_id_o(low_id)
    );

    bms_power_mgmt u_pwr (
        .clk(clk),
        .rst_n(rst_n),
        .fault_condition(fault_trip),
        .comm_active(comm_active),
        .adc_busy(adc_busy),
        .logic_clk_en(logic_clk_en),
        .sleep_mode(sleep_mode)
    );

    bms_comm_hub u_comm (
        .clk(clk),
        .rst_n(rst_n),
        .comm_sel(comm_sel),
        .tx_byte(soc_out[15:8]),
        .tx_valid(adc_frame_done),
        .spi_sclk(spi_sclk),
        .spi_ss_n(spi_ss_n),
        .spi_mosi(spi_mosi),
        .spi_miso(spi_miso),
        .uart_tx(uart_tx),
        .can_frame(can_frame),
        .can_valid(can_valid),
        .comm_active(comm_active)
    );

    bms_fault_logger u_log (
        .clk(clk),
        .rst_n(rst_n),
        .log_en(fault_trip & (~fault_trip_d)),
        .fault_code(fault_code),
        .timestamp(timestamp),
        .wr_ptr(),
        .overflow()
    );
endmodule
