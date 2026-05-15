// ============================================================
// MODULE : bms_fault_processor
// PURPOSE:
//   Detect OV, UV, and OT faults safely.
// ============================================================

module bms_fault_processor (

    input  wire        clk,
    input  wire        rst_n,
    input  wire [15:0] cell_v [0:15],
    input  wire [11:0] temp,

    output reg         fault_out,
    output reg  [3:0]  status_o
);

    integer i;

    reg ov_detect;
    reg uv_detect;

    // Thresholds
    localparam [15:0] OVP_LIM = 16'd4200;
    localparam [15:0] UVP_LIM = 16'd3000;
    localparam [11:0] OTP_LIM = 12'd85;

    always @(posedge clk or negedge rst_n) begin

        if(!rst_n) begin

            fault_out <= 1'b0;
            status_o  <= 4'd0;

        end

        else begin

            ov_detect = 1'b0;
            uv_detect = 1'b0;

            // Scan all cells
            for(i = 0; i < 16; i = i + 1) begin

                if(cell_v[i] > OVP_LIM)
                    ov_detect = 1'b1;

                if(cell_v[i] < UVP_LIM)
                    uv_detect = 1'b1;

            end

            // Default
            fault_out <= 1'b0;
            status_o  <= 4'd0;

            // Priority Fault Logic
            if(ov_detect) begin

                fault_out <= 1'b1;
                status_o  <= 4'd1;

            end

            else if(uv_detect) begin

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