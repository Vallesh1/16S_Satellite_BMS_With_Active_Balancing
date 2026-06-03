module bms_system_3lmu_top_enhanced(
    input  wire         clk,
    input  wire         rst_n,
    input  wire         start_poll,
    input  wire [15:0]  pack_current,

    input  wire         lmu0_adc_start,
    input  wire [15:0]  lmu0_adc_data,
    input  wire         lmu0_adc_valid,
    input  wire [15:0]  lmu0_pack_i,
    input  wire [15:0]  lmu0_pack_v_avg,
    input  wire [15:0]  lmu0_charge_cycles,
    input  wire [11:0]  lmu0_temp_die,
    input  wire [191:0] lmu0_cell_t_bus,
    input  wire [15:0]  lmu0_iso_resistance,
    input  wire         lmu0_emi_in,

    input  wire         lmu1_adc_start,
    input  wire [15:0]  lmu1_adc_data,
    input  wire         lmu1_adc_valid,
    input  wire [15:0]  lmu1_pack_i,
    input  wire [15:0]  lmu1_pack_v_avg,
    input  wire [15:0]  lmu1_charge_cycles,
    input  wire [11:0]  lmu1_temp_die,
    input  wire [191:0] lmu1_cell_t_bus,
    input  wire [15:0]  lmu1_iso_resistance,
    input  wire         lmu1_emi_in,

    input  wire         lmu2_adc_start,
    input  wire [15:0]  lmu2_adc_data,
    input  wire         lmu2_adc_valid,
    input  wire [15:0]  lmu2_pack_i,
    input  wire [15:0]  lmu2_pack_v_avg,
    input  wire [15:0]  lmu2_charge_cycles,
    input  wire [11:0]  lmu2_temp_die,
    input  wire [191:0] lmu2_cell_t_bus,
    input  wire [15:0]  lmu2_iso_resistance,
    input  wire         lmu2_emi_in,

    input  wire         spi_miso,
    output wire         spi_sclk,
    output wire         spi_mosi,
    output wire [2:0]   spi_cs_n,
    output wire [15:0]  pack_soc_avg,
    output wire [15:0]  pack_soh_avg,
    output wire         global_fault,
    output wire [7:0]   global_fault_code,
    output wire         current_warn,
    output wire         current_trip,
    output wire         thermal_warn,
    output wire         thermal_trip,
    output wire [15:0]  allowed_current,
    output wire [7:0]   supervisor_code
);
    wire dummy_spi_miso_0, dummy_spi_miso_1, dummy_spi_miso_2;
    wire dummy_uart_0, dummy_uart_1, dummy_uart_2;
    wire [63:0] dummy_can_0, dummy_can_1, dummy_can_2;
    wire dummy_can_valid_0, dummy_can_valid_1, dummy_can_valid_2;
    wire [15:0] dummy_active_tx0, dummy_active_rx0, dummy_passive0;
    wire [15:0] dummy_active_tx1, dummy_active_rx1, dummy_passive1;
    wire [15:0] dummy_active_tx2, dummy_active_rx2, dummy_passive2;
    wire lmu0_fault, lmu1_fault, lmu2_fault;
    wire [7:0] lmu0_fault_code, lmu1_fault_code, lmu2_fault_code;
    wire [15:0] lmu0_soc, lmu1_soc, lmu2_soc;
    wire [15:0] lmu0_soh, lmu1_soh, lmu2_soh;
    wire lmu_count_fault;
    wire [11:0] max_temp_seen;

    bms_lmu_wrapper u_lmu0 (
        .clk(clk), .rst_n(rst_n), .adc_start(lmu0_adc_start), .adc_data(lmu0_adc_data), .adc_valid(lmu0_adc_valid),
        .pack_i(lmu0_pack_i), .pack_v_avg(lmu0_pack_v_avg), .charge_cycles(lmu0_charge_cycles), .temp_die(lmu0_temp_die),
        .cell_t_bus(lmu0_cell_t_bus), .iso_resistance(lmu0_iso_resistance), .emi_in(lmu0_emi_in), .comm_sel(2'd1),
        .spi_sclk(1'b0), .spi_ss_n(1'b1), .spi_mosi(1'b0), .spi_miso(dummy_spi_miso_0), .uart_tx(dummy_uart_0),
        .can_frame(dummy_can_0), .can_valid(dummy_can_valid_0), .active_tx_sw(dummy_active_tx0), .active_rx_sw(dummy_active_rx0),
        .passive_sw(dummy_passive0), .fault_trip(lmu0_fault), .fault_code(lmu0_fault_code), .soc_out(lmu0_soc), .soh_out(lmu0_soh)
    );
    bms_lmu_wrapper u_lmu1 (
        .clk(clk), .rst_n(rst_n), .adc_start(lmu1_adc_start), .adc_data(lmu1_adc_data), .adc_valid(lmu1_adc_valid),
        .pack_i(lmu1_pack_i), .pack_v_avg(lmu1_pack_v_avg), .charge_cycles(lmu1_charge_cycles), .temp_die(lmu1_temp_die),
        .cell_t_bus(lmu1_cell_t_bus), .iso_resistance(lmu1_iso_resistance), .emi_in(lmu1_emi_in), .comm_sel(2'd1),
        .spi_sclk(1'b0), .spi_ss_n(1'b1), .spi_mosi(1'b0), .spi_miso(dummy_spi_miso_1), .uart_tx(dummy_uart_1),
        .can_frame(dummy_can_1), .can_valid(dummy_can_valid_1), .active_tx_sw(dummy_active_tx1), .active_rx_sw(dummy_active_rx1),
        .passive_sw(dummy_passive1), .fault_trip(lmu1_fault), .fault_code(lmu1_fault_code), .soc_out(lmu1_soc), .soh_out(lmu1_soh)
    );
    bms_lmu_wrapper u_lmu2 (
        .clk(clk), .rst_n(rst_n), .adc_start(lmu2_adc_start), .adc_data(lmu2_adc_data), .adc_valid(lmu2_adc_valid),
        .pack_i(lmu2_pack_i), .pack_v_avg(lmu2_pack_v_avg), .charge_cycles(lmu2_charge_cycles), .temp_die(lmu2_temp_die),
        .cell_t_bus(lmu2_cell_t_bus), .iso_resistance(lmu2_iso_resistance), .emi_in(lmu2_emi_in), .comm_sel(2'd1),
        .spi_sclk(1'b0), .spi_ss_n(1'b1), .spi_mosi(1'b0), .spi_miso(dummy_spi_miso_2), .uart_tx(dummy_uart_2),
        .can_frame(dummy_can_2), .can_valid(dummy_can_valid_2), .active_tx_sw(dummy_active_tx2), .active_rx_sw(dummy_active_rx2),
        .passive_sw(dummy_passive2), .fault_trip(lmu2_fault), .fault_code(lmu2_fault_code), .soc_out(lmu2_soc), .soh_out(lmu2_soh)
    );

    bms_master_control_unit_enhanced u_mcu (
        .clk(clk), .rst_n(rst_n), .start_poll(start_poll), .spi_miso(spi_miso), .pack_current(pack_current),
        .lmu0_temp_die(lmu0_temp_die), .lmu1_temp_die(lmu1_temp_die), .lmu2_temp_die(lmu2_temp_die),
        .lmu0_soc(lmu0_soc), .lmu1_soc(lmu1_soc), .lmu2_soc(lmu2_soc), .lmu0_soh(lmu0_soh), .lmu1_soh(lmu1_soh), .lmu2_soh(lmu2_soh),
        .lmu0_fault(lmu0_fault), .lmu1_fault(lmu1_fault), .lmu2_fault(lmu2_fault),
        .lmu0_fault_code(lmu0_fault_code), .lmu1_fault_code(lmu1_fault_code), .lmu2_fault_code(lmu2_fault_code),
        .spi_sclk(spi_sclk), .spi_mosi(spi_mosi), .spi_cs_n(spi_cs_n), .pack_soc_avg(pack_soc_avg), .pack_soh_avg(pack_soh_avg),
        .global_fault(global_fault), .global_fault_code(global_fault_code), .active_lmu_id(), .poll_busy(),
        .current_warn(current_warn), .current_trip(current_trip), .thermal_warn(thermal_warn), .thermal_trip(thermal_trip),
        .lmu_count_fault(lmu_count_fault), .allowed_current(allowed_current), .supervisor_code(supervisor_code), .max_temp_seen(max_temp_seen)
    );
endmodule
