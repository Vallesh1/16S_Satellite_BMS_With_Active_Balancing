module bms_comm_hub(
    input  wire       clk,
    input  wire       rst_n,
    input  wire [1:0] comm_sel,
    input  wire [7:0] tx_byte,
    input  wire       tx_valid,
    input  wire       spi_sclk,
    input  wire       spi_ss_n,
    input  wire       spi_mosi,
    output wire       spi_miso,
    output wire       uart_tx,
    output wire [63:0] can_frame,
    output wire       can_valid,
    output wire       comm_active
);
    wire uart_ready;
    wire uart_busy;

    bms_uart_tx u_uart (
        .clk(clk),
        .rst_n(rst_n),
        .tx_byte(tx_byte),
        .tx_valid(tx_valid & (comm_sel == 2'd0)),
        .tx_ready(uart_ready),
        .tx_wire(uart_tx),
        .busy(uart_busy)
    );

    bms_spi_slave u_spi (
        .sclk(spi_sclk),
        .rst_n(rst_n),
        .ss_n(spi_ss_n),
        .mosi(spi_mosi),
        .tx_byte(tx_byte),
        .miso(spi_miso),
        .rx_byte(),
        .rx_valid()
    );

    bms_can_status_if u_can (
        .clk(clk),
        .rst_n(rst_n),
        .push(tx_valid & (comm_sel == 2'd2)),
        .payload({56'd0, tx_byte}),
        .frame_valid(can_valid),
        .frame_data(can_frame)
    );

    assign comm_active = uart_busy | (~spi_ss_n) | can_valid;
endmodule
