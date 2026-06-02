module bms_uart_tx #(
    parameter [15:0] CLKS_PER_BIT = 16
)(
    input  wire       clk,
    input  wire       rst_n,
    input  wire [7:0] tx_byte,
    input  wire       tx_valid,
    output reg        tx_ready,
    output reg        tx_wire,
    output reg        busy
);
    reg [1:0] state;
    reg [3:0] bit_idx;
    reg [7:0] shreg;
    reg [15:0] baud_cnt;

    localparam ST_IDLE  = 2'd0;
    localparam ST_START = 2'd1;
    localparam ST_DATA  = 2'd2;
    localparam ST_STOP  = 2'd3;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state    <= ST_IDLE;
            bit_idx  <= 4'd0;
            shreg    <= 8'd0;
            baud_cnt <= 16'd0;
            tx_ready <= 1'b1;
            tx_wire  <= 1'b1;
            busy     <= 1'b0;
        end else begin
            case (state)
                ST_IDLE: begin
                    tx_wire  <= 1'b1;
                    tx_ready <= 1'b1;
                    busy     <= 1'b0;
                    bit_idx  <= 4'd0;
                    baud_cnt <= 16'd0;
                    if (tx_valid) begin
                        shreg    <= tx_byte;
                        tx_ready <= 1'b0;
                        busy     <= 1'b1;
                        state    <= ST_START;
                    end
                end
                ST_START: begin
                    tx_wire <= 1'b0;
                    if (baud_cnt == (CLKS_PER_BIT - 1'b1)) begin
                        baud_cnt <= 16'd0;
                        state    <= ST_DATA;
                    end else begin
                        baud_cnt <= baud_cnt + 16'd1;
                    end
                end
                ST_DATA: begin
                    tx_wire <= shreg[0];
                    if (baud_cnt == (CLKS_PER_BIT - 1'b1)) begin
                        baud_cnt <= 16'd0;
                        shreg    <= {1'b0, shreg[7:1]};
                        if (bit_idx == 4'd7)
                            state <= ST_STOP;
                        else
                            bit_idx <= bit_idx + 4'd1;
                    end else begin
                        baud_cnt <= baud_cnt + 16'd1;
                    end
                end
                default: begin
                    tx_wire <= 1'b1;
                    if (baud_cnt == (CLKS_PER_BIT - 1'b1)) begin
                        baud_cnt <= 16'd0;
                        state    <= ST_IDLE;
                    end else begin
                        baud_cnt <= baud_cnt + 16'd1;
                    end
                end
            endcase
        end
    end
endmodule
