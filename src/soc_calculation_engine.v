module bms_soc_engine (
    input  wire        clk,
    input  wire        rst_n,
    input  wire [15:0] pack_i,
    output wire [15:0] soc_out
);
    reg [31:0] coulomb_acc;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            coulomb_acc <= 32'h0000_8000; // Init at 50%
        else
            // Sign-extend current and add to accumulator
            coulomb_acc <= coulomb_acc + {{16{pack_i[15]}}, pack_i};
    end
    assign soc_out = coulomb_acc[31:16];
endmodule