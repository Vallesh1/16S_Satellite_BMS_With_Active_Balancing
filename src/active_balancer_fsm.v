module bms_active_balancer (
    input  wire        clk,
    input  wire        rst_n,
    input  wire [15:0] cell_v [0:15],
    output reg  [15:0] bal_sw
);
    integer i;
    reg [15:0] peak_v;
    reg [3:0]  target_id;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            bal_sw <= 16'h0;
        end else begin
            peak_v = 16'h0;
            for (i = 0; i < 16; i = i + 1) begin
                if (cell_v[i] > peak_v) begin
                    peak_v = cell_v[i];
                    target_id = i;
                end
            end
            // One-hot encoding for the balance switch
            bal_sw <= (1'b1 << target_id);
        end
    end
endmodule