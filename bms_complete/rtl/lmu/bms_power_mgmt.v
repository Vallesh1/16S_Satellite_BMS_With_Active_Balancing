module bms_power_mgmt(
    input  wire clk,
    input  wire rst_n,
    input  wire fault_condition,
    input  wire comm_active,
    input  wire adc_busy,
    output reg  logic_clk_en,
    output reg  sleep_mode
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            logic_clk_en <= 1'b1;
            sleep_mode   <= 1'b0;
        end else begin
            sleep_mode   <= (~comm_active) & (~fault_condition) & (~adc_busy);
            logic_clk_en <= comm_active | fault_condition | adc_busy;
        end
    end
endmodule
