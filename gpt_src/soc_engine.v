module bms_soc_engine (

    input  wire        clk,
    input  wire        rst_n,
    input  wire [15:0] pack_i,

    output reg  [15:0] soc_out
);

    reg signed [31:0] coulomb_acc;

    always @(posedge clk or negedge rst_n) begin

        if(!rst_n) begin

            coulomb_acc <= 32'sd32768;
            soc_out     <= 16'd50;
        end

        else begin

            coulomb_acc <= coulomb_acc + $signed(pack_i);

            if(coulomb_acc < 0)
                coulomb_acc <= 0;

            if(coulomb_acc > 32'sd65535)
                coulomb_acc <= 32'sd65535;

            soc_out <= coulomb_acc[15:0] / 16'd655;
        end
    end

endmodule