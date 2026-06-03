module bms_isolation_monitor #(
    parameter [15:0] ISO_LIM = 16'd500
)(
    input  wire        clk,
    input  wire        rst_n,
    input  wire [15:0] iso_resistance,
    output reg         iso_fault,
    output reg  [15:0] iso_margin
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            iso_fault  <= 1'b0;
            iso_margin <= 16'd0;
        end else begin
            iso_fault  <= (iso_resistance < ISO_LIM);
            if (iso_resistance < ISO_LIM)
                iso_margin <= 16'd0;
            else
                iso_margin <= iso_resistance - ISO_LIM;
        end
    end
endmodule
