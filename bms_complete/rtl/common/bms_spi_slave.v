// ==============================================================================
// MODULE: bms_spi_slave
// Description: SPI Mode 0 Slave interface.
// Optimized for 14nmts & older EDK libraries to prevent generic \**SEQGEN** 
// mapping and unwanted integrated clock-gating cells.
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
    reg [2:0] bit_cnt;      // RX bit counter
    reg [7:0] rx_shift;
    reg [7:0] tx_shift;

    // Explicitly invert the clock. This allows the synthesis tool to treat the 
    // TX path as a standard 'posedge' structural network on an inverted tree,
    // bypassing the generic SEQGEN mapping bug on negedge blocks.
    wire sclk_n = ~sclk;

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
    // 2. TX Data Path (Driven via the inverted clock wire)
    // --------------------------------------------------------------------------
    always @(posedge sclk_n or negedge rst_n) begin
        if (!rst_n) begin
            tx_shift <= 8'd0;
        end else begin
            if (ss_n) begin
                tx_shift <= tx_byte; // Pre-load while chip select is high
            end else begin
                tx_shift <= {tx_shift[6:0], 1'b0}; // Shift out MSB
            end
        end
    end

    // --------------------------------------------------------------------------
    // 3. MISO Output Driver
    // --------------------------------------------------------------------------
    always @(*) begin
        if (!ss_n) begin
            miso = tx_shift[7];
        end else begin
            miso = 1'b0; 
        end
    end

endmodule