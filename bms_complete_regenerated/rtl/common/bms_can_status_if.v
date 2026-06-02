module bms_can_status_if(
    input  wire        clk,
    input  wire        rst_n,
    input  wire        push,
    input  wire [63:0] payload,
    output reg         frame_valid,
    output reg  [63:0] frame_data
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            frame_valid <= 1'b0;
            frame_data  <= 64'd0;
        end else begin
            frame_valid <= push;
            if (push)
                frame_data <= payload;
        end
    end
endmodule
