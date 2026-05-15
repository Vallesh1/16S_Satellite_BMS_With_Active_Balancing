// ============================================================
// MODULE : bms_tx_scheduler
// PURPOSE:
//   Generates periodic UART transmit trigger.
// ============================================================

module bms_tx_scheduler (

    input  wire clk,
    input  wire rst_n,

    output reg  tx_trigger
);

    reg [23:0] tx_counter;

    localparam TX_PERIOD = 24'd1000000;

    always @(posedge clk or negedge rst_n) begin

        if(!rst_n) begin

            tx_counter <= 24'd0;
            tx_trigger <= 1'b0;

        end

        else begin

            if(tx_counter >= TX_PERIOD) begin

                tx_counter <= 24'd0;
                tx_trigger <= 1'b1;

            end

            else begin

                tx_counter <= tx_counter + 1'b1;
                tx_trigger <= 1'b0;

            end

        end
    end

endmodule