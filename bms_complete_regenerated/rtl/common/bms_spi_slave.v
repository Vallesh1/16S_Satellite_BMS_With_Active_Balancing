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
    reg [2:0] bit_cnt;
    reg [7:0] rx_shift;
    reg [7:0] tx_shift;

    always @(negedge ss_n or negedge rst_n) begin
        if (!rst_n)
            tx_shift <= 8'd0;
        else
            tx_shift <= tx_byte;
    end

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

    always @(negedge sclk or negedge rst_n) begin
        if (!rst_n) begin
            miso     <= 1'b0;
            tx_shift <= 8'd0;
        end else if (!ss_n) begin
            miso     <= tx_shift[7];
            tx_shift <= {tx_shift[6:0], 1'b0};
        end else begin
            miso <= 1'b0;
        end
    end
endmodule
