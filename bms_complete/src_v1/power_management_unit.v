module bms_power_mgmt (
    input  wire clk,
    input  wire rst_n,
    input  wire fault_condition,
    input  wire comm_active,
    output wire logic_clk_en
);
    reg is_sleeping;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            is_sleeping <= 1'b0;
        else
            is_sleeping <= (!comm_active && !fault_condition);
    end
    assign logic_clk_en = clk & !is_sleeping;
endmodule