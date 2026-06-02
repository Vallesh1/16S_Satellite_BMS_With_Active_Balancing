module bms_fault_logger #(
    parameter DEPTH = 16
)(
    input  wire       clk,
    input  wire       rst_n,
    input  wire       log_en,
    input  wire [7:0] fault_code,
    input  wire [15:0] timestamp,
    output reg  [3:0] wr_ptr,
    output reg        overflow
);
    reg [23:0] fault_mem [0:DEPTH-1];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wr_ptr   <= 4'd0;
            overflow <= 1'b0;
        end else if (log_en) begin
            fault_mem[wr_ptr] <= {timestamp, fault_code};
            if (wr_ptr == (DEPTH - 1)) begin
                wr_ptr   <= 4'd0;
                overflow <= 1'b1;
            end else begin
                wr_ptr <= wr_ptr + 4'd1;
            end
        end
    end
endmodule
