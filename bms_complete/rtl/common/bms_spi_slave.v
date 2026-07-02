// ==============================================================================
// MODULE: bms_spi_slave
// Description: SPI Mode 0 Slave interface. 
// Fixes Applied: Resolved ELAB-366 multi-driver error on 'tx_shift' by unifying 
//                the load and shift operations into a single synchronous block.
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
    reg [2:0] tx_bit_cnt;   // TX bit counter (updates on negedge)
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
            rx_valid <= 1'b0;
            if (bit_cnt == 3'd7) begin
                bit_cnt  <= 3'd0;
                rx_byte  <= {rx_shift[6:0], mosi};
                rx_valid <= 1'b1;
            end else begin
                bit_cnt <= bit_cnt + 3'd1;
            end
        end else begin
            bit_cnt  <= 3'd0;
            rx_valid <= 1'b0;
        end
    end

    // --------------------------------------------------------------------------
    // 2. TX Data Path (Shift on negedge sclk)
    // --------------------------------------------------------------------------
    always @(negedge sclk or negedge rst_n) begin
        if (!rst_n) begin
            tx_shift   <= 8'd0;
            tx_bit_cnt <= 3'd0;
        end else if (!ss_n) begin
            // If it is the first shift edge, load the remaining 7 bits.
            if (tx_bit_cnt == 3'd0) begin
                tx_shift <= {tx_byte[6:0], 1'b0};
            end else begin
                tx_shift <= {tx_shift[6:0], 1'b0};
            end
            
            // Natural rollover from 7 back to 0 prepares it for the next transaction
            tx_bit_cnt <= tx_bit_cnt + 3'd1;
        end else begin
            // Reset the counter when chip select is inactive (high)
            tx_bit_cnt <= 3'd0;
        end
    end

    // --------------------------------------------------------------------------
    // 3. MISO Combinational Output Driver
    // --------------------------------------------------------------------------
    // Ensures the MSB (tx_byte[7]) is available instantly when ss_n goes low, 
    // satisfying SPI Mode 0 setup times before the first posedge sclk.
    always @(*) begin
        if (!ss_n) begin
            if (tx_bit_cnt == 3'd0)
                miso = tx_byte[7];   // Push first bit out immediately
            else
                miso = tx_shift[7];  // Push subsequently shifted bits
        end else begin
            miso = 1'b0;             // Idle state
        end
    end

endmodule