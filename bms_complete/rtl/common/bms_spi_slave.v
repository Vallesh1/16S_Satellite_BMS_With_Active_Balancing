// ==============================================================================
// MODULE: bms_spi_slave
// Description: SPI Mode 0 Slave interface.
// Optimized for maximum synthesis cell compatibility (EDK friendly).
// ==============================================================================

module bms_spi_slave(
    input  wire       sclk,
    input  wire       rst_n,
    input  wire       ss_n,
    input  wire       mosi,
    input  wire [7:0] tx_byte,
    output reg        miso,
    output reg  [7:0] rx_byte,
    output reg        rx_valid
);
    reg [2:0] bit_cnt;      // RX bit counter (updates on posedge)
    reg [7:0] rx_shift;
    reg [7:0] tx_shift;

    // --------------------------------------------------------------------------
    // 1. RX Data Path (Sample on posedge sclk)
    // --------------------------------------------------------------------------
    always @(posedge sclk or negedge rst_n) begin
        if (!rst_n) begin
            bit_cnt  <= 3'd0;
            rx_shift <= 8'd0;
            rx_byte  <= 8'd0;
            rx_valid <= 1'b0;
        end else if (!ss_n) begin
            rx_shift <= {rx_shift[6:0], mosi};
            
            if (bit_cnt == 3'd7) begin
                bit_cnt  <= 3'd0;
                rx_byte  <= {rx_shift[6:0], mosi};
                rx_valid <= 1'b1;
            end else begin
                bit_cnt  <= bit_cnt + 3'd1;
                rx_valid <= 1'b0;
            end
        end else begin
            bit_cnt  <= 3'd0;
            rx_valid <= 1'b0;
        end
    end

    // --------------------------------------------------------------------------
    // 2. TX Data Path (Shift on negedge sclk)
    // --------------------------------------------------------------------------
    // Clean load-on-idle structure avoids complex clock-gating cells
    always @(negedge sclk or negedge rst_n) begin
        if (!rst_n) begin
            tx_shift <= 8'd0;
        end else if (ss_n) begin
            tx_shift <= tx_byte; // Pre-load while chip select is high
        end else begin
            tx_shift <= {tx_shift[6:0], 1'b0}; // Shift out MSB first
        end
    end

    // --------------------------------------------------------------------------
    // 3. MISO Output Driver
    // --------------------------------------------------------------------------
    // Directly drives the MSB of the shift register when active.
    always @(*) begin
        if (!ss_n) begin
            miso = tx_shift[7];
        end else begin
            miso = 1'b0; // High-Z or 0 depending on bus needs (0 chosen for safety)
        end
    end

endmodule