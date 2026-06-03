module bms_soc_soh_engine #(
    parameter [31:0] NOMINAL_CAPACITY = 32'd100000,
    parameter [15:0] OCV_FULL = 16'hCE66,
    parameter [15:0] OCV_EMPTY = 16'h8000,
    parameter [15:0] CURRENT_DEADBAND = 16'd8,
    parameter [31:0] RELAX_COUNT_MAX = 32'd100000,
    parameter [15:0] CYCLE_AGING_STEP = 16'd32
)(
    input  wire        clk,
    input  wire        rst_n,
    input  wire        en,
    input  wire [15:0] pack_i,
    input  wire [15:0] pack_v_avg,
    input  wire [15:0] charge_cycles,
    output reg  [15:0] soc_out,
    output reg  [15:0] soh_out
);
    reg signed [31:0] coulomb_acc;
    reg [31:0] relax_cnt;
    reg [15:0] ocv_soc;
    reg [31:0] soh_calc;
    reg [15:0] abs_pack_i;
    reg [31:0] cycle_loss;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            coulomb_acc <= 32'sd214748364;
            relax_cnt   <= 32'd0;
            soc_out     <= 16'h8000;
            soh_out     <= 16'hFFFF;
            ocv_soc     <= 16'h8000;
            soh_calc    <= NOMINAL_CAPACITY;
            abs_pack_i  <= 16'd0;
            cycle_loss  <= 32'd0;
        end else if (en) begin
            if (pack_i[15])
                abs_pack_i <= (~pack_i) + 16'd1;
            else
                abs_pack_i <= pack_i;

            coulomb_acc <= coulomb_acc + {{16{pack_i[15]}}, pack_i};

            if (abs_pack_i <= CURRENT_DEADBAND) begin
                if (relax_cnt < RELAX_COUNT_MAX)
                    relax_cnt <= relax_cnt + 32'd1;
            end else begin
                relax_cnt <= 32'd0;
            end

            if (pack_v_avg <= OCV_EMPTY)
                ocv_soc <= 16'd0;
            else if (pack_v_avg >= OCV_FULL)
                ocv_soc <= 16'hFFFF;
            else
                ocv_soc <= ((pack_v_avg - OCV_EMPTY) * 16'hFFFF) / (OCV_FULL - OCV_EMPTY);

            if (relax_cnt >= RELAX_COUNT_MAX)
                soc_out <= (soc_out >> 1) + (ocv_soc >> 1);
            else
                soc_out <= coulomb_acc[30:15];

            cycle_loss = charge_cycles * CYCLE_AGING_STEP;
            if (cycle_loss >= (NOMINAL_CAPACITY >> 1))
                soh_calc <= (NOMINAL_CAPACITY >> 1);
            else
                soh_calc <= NOMINAL_CAPACITY - cycle_loss;

            soh_out <= (soh_calc * 16'hFFFF) / NOMINAL_CAPACITY;
        end
    end
endmodule
