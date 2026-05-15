// ============================================================
// MODULE : bms_soc_engine
// PURPOSE:
//   Improved SOC estimation using saturation arithmetic,
//   signed current accumulation, and lightweight scaling.
// ============================================================

module bms_soc_engine (

    input  wire               clk,
    input  wire               rst_n,
    input  wire signed [15:0] pack_i,

    output reg  [7:0]         soc_out
);

    // Internal Coulomb Counter
    reg signed [31:0] coulomb_acc;

    // Battery Capacity Model
    localparam signed MAX_CAPACITY = 32'sd1048576;
    localparam signed MIN_CAPACITY = 32'sd0;
    localparam signed INIT_CAPACITY = 32'sd524288;

    reg signed [31:0] next_acc;

    always @(posedge clk or negedge rst_n) begin

        if(!rst_n) begin

            coulomb_acc <= INIT_CAPACITY;
            soc_out     <= 8'd50;

        end

        else begin

            // Current accumulation
            next_acc = coulomb_acc + pack_i;

            // Saturation protection
            if(next_acc > MAX_CAPACITY)
                next_acc = MAX_CAPACITY;

            else if(next_acc < MIN_CAPACITY)
                next_acc = MIN_CAPACITY;

            coulomb_acc <= next_acc;

            // SOC Scaling (0-100%)
            soc_out <= (next_acc * 100) / MAX_CAPACITY;

        end
    end

endmodule