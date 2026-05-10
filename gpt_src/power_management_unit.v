module bms_power_mgmt (

    input  wire clk,
    input  wire rst_n,
    input  wire fault_condition,
    input  wire comm_active,

    output reg  sleep_mode
);

    always @(posedge clk or negedge rst_n) begin

        if(!rst_n)
            sleep_mode <= 1'b0;

        else begin

            if(!comm_active && !fault_condition)
                sleep_mode <= 1'b1;

            else
                sleep_mode <= 1'b0;
        end
    end

endmodule