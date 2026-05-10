module bms_fault_processor (

    input  wire        clk,
    input  wire        rst_n,
    input  wire [15:0] cell_v [0:15],
    input  wire [11:0] temp,

    output reg         fault_out,
    output reg  [3:0]  status_o
);

    integer i;

    reg ov_flag;
    reg uv_flag;

    localparam OVP_LIM = 16'hCE66;
    localparam UVP_LIM = 16'h8000;
    localparam OTP_LIM = 12'h384;

    always @(posedge clk or negedge rst_n) begin

        if(!rst_n) begin
            fault_out <= 1'b0;
            status_o  <= 4'd0;
        end

        else begin

            ov_flag = 1'b0;
            uv_flag = 1'b0;

            for(i = 0; i < 16; i = i + 1) begin

                if(cell_v[i] > OVP_LIM)
                    ov_flag = 1'b1;

                if(cell_v[i] < UVP_LIM)
                    uv_flag = 1'b1;
            end

            fault_out <= 1'b0;
            status_o  <= 4'd0;

            if(ov_flag) begin
                fault_out <= 1'b1;
                status_o  <= 4'd1;
            end

            else if(uv_flag) begin
                fault_out <= 1'b1;
                status_o  <= 4'd2;
            end

            else if(temp > OTP_LIM) begin
                fault_out <= 1'b1;
                status_o  <= 4'd3;
            end
        end
    end

endmodule