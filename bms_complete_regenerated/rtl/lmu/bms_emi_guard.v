module bms_emi_guard #(
    parameter FILTER_LEN = 4
)(
    input  wire clk,
    input  wire rst_n,
    input  wire emi_in,
    output reg  emi_alert
);
    reg [FILTER_LEN-1:0] hist;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            hist      <= {FILTER_LEN{1'b0}};
            emi_alert <= 1'b0;
        end else begin
            hist      <= {hist[FILTER_LEN-2:0], emi_in};
            emi_alert <= &hist;
        end
    end
endmodule
