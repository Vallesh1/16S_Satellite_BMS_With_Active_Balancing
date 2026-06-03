module bms_spi_master #(
    parameter [7:0] CLK_DIV = 8'd8,
    parameter [1:0] CPOL    = 2'd0,
    parameter [1:0] CPHA    = 2'd0
)(
    input  wire       clk,
    input  wire       rst_n,
    input  wire       start,
    input  wire [1:0] slave_sel,
    input  wire [7:0] tx_byte,
    input  wire       miso,
    output reg        busy,
    output reg        done,
    output reg  [7:0] rx_byte,
    output reg        sclk,
    output reg        mosi,
    output reg  [2:0] cs_n
);
    reg [7:0] clk_cnt;
    reg [3:0] bit_cnt;
    reg [7:0] tx_shift;
    reg [7:0] rx_shift;
    reg [1:0] state;

    localparam ST_IDLE  = 2'd0;
    localparam ST_SHIFT = 2'd1;
    localparam ST_DONE  = 2'd2;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            clk_cnt  <= 8'd0;
            bit_cnt  <= 4'd0;
            tx_shift <= 8'd0;
            rx_shift <= 8'd0;
            state    <= ST_IDLE;
            busy     <= 1'b0;
            done     <= 1'b0;
            rx_byte  <= 8'd0;
            sclk     <= 1'b0;
            mosi     <= 1'b0;
            cs_n     <= 3'b111;
        end else begin
            case (state)
                ST_IDLE: begin
                    clk_cnt <= 8'd0;
                    bit_cnt <= 4'd0;
                    done    <= 1'b0;
                    busy    <= 1'b0;
                    sclk    <= CPOL[0];
                    cs_n    <= 3'b111;
                    if (start) begin
                        busy     <= 1'b1;
                        tx_shift <= tx_byte;
                        rx_shift <= 8'd0;
                        mosi     <= tx_byte[7];
                        case (slave_sel)
                            2'd0: cs_n <= 3'b110;
                            2'd1: cs_n <= 3'b101;
                            2'd2: cs_n <= 3'b011;
                            default: cs_n <= 3'b111;
                        endcase
                        state <= ST_SHIFT;
                    end
                end
                ST_SHIFT: begin
                    if (clk_cnt == (CLK_DIV - 1'b1)) begin
                        clk_cnt <= 8'd0;
                        sclk    <= ~sclk;
                        if (sclk == CPOL[0]) begin
                            rx_shift <= {rx_shift[6:0], miso};
                            if (bit_cnt == 4'd7) begin
                                rx_byte <= {rx_shift[6:0], miso};
                                state   <= ST_DONE;
                            end else begin
                                bit_cnt  <= bit_cnt + 4'd1;
                                tx_shift <= {tx_shift[6:0], 1'b0};
                                mosi     <= tx_shift[6];
                            end
                        end
                    end else begin
                        clk_cnt <= clk_cnt + 8'd1;
                    end
                end
                default: begin
                    cs_n <= 3'b111;
                    sclk <= CPOL[0];
                    busy <= 1'b0;
                    done <= 1'b1;
                    state <= ST_IDLE;
                end
            endcase
        end
    end
endmodule
