// ============================================================
// MODULE : bms_power_mgmt
// PURPOSE:
//   Sleep control with inactivity timer.
// ============================================================

module bms_power_mgmt (

    input  wire clk,
    input  wire rst_n,
    input  wire fault_condition,
    input  wire comm_active,

    output reg  sleep_mode
);

    reg [23:0] idle_counter;

    localparam IDLE_TIMEOUT = 24'd5000000;

    always @(posedge clk or negedge rst_n) begin

        if(!rst_n) begin

            sleep_mode  <= 1'b0;
            idle_counter <= 24'd0;

        end

        else begin

            // Reset timer if active
            if(comm_active || fault_condition) begin

                idle_counter <= 24'd0;
                sleep_mode   <= 1'b0;

            end

            else begin

                idle_counter <= idle_counter + 1'b1;

                if(idle_counter > IDLE_TIMEOUT)
                    sleep_mode <= 1'b1;

            end

        end
    end

endmodule