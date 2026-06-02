module bms_fault_processor (
    input  wire        clk,
    input  wire        rst_n,
    input  wire [15:0] cell_v [0:15],
    input  wire [11:0] temp,
    output reg         fault_out,
    output reg  [3:0]  status_o
);
    localparam OVP_LIM = 16'hCE66; // 4.225V
    localparam UVP_LIM = 16'h8000; // 2.500V
    localparam OTP_LIM = 12'h384;  // 90C
    
    integer i;
    reg ov_flag, uv_flag;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            fault_out <= 1'b0;
            status_o  <= 4'd0;
        end else begin
            ov_flag = 0;
            uv_flag = 0;
            for (i = 0; i < 16; i = i + 1) begin
                if (cell_v[i] > OVP_LIM) ov_flag = 1;
                if (cell_v[i] < UVP_LIM) uv_flag = 1;
            end
            
            if (ov_flag || uv_flag || (temp > OTP_LIM)) begin
                fault_out <= 1'b1;
                status_o  <= ov_flag ? 4'd1 : (uv_flag ? 4'd2 : 4'd3);
            end else begin
                fault_out <= 1'b0;
                status_o  <= 4'd0;
            end
        end
    end
endmodule