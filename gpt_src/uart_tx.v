// ============================================================
// MODULE : bms_uart_tx
// PURPOSE:
//   UART transmitter with baud generator.
// ============================================================

module bms_uart_tx (

    input  wire       clk,
    input  wire       rst_n,
    input  wire [7:0] tx_byte,
    input  wire       tx_start,

    output reg        tx_wire,
    output reg        tx_busy
);

    // Example:
    // 50 MHz clock
    // 115200 baud

    localparam BAUD_DIV = 434;

    reg [15:0] baud_cnt;
    reg        baud_tick;

    reg [9:0] shift_reg;
    reg [3:0] bit_ptr;

    // Baud Generator
    always @(posedge clk or negedge rst_n) begin

        if(!rst_n) begin

            baud_cnt  <= 16'd0;
            baud_tick <= 1'b0;

        end

        else begin

            if(baud_cnt >= BAUD_DIV - 1) begin

                baud_cnt  <= 16'd0;
                baud_tick <= 1'b1;

            end

            else begin

                baud_cnt  <= baud_cnt + 1'b1;
                baud_tick <= 1'b0;

            end

        end
    end

    // UART Logic
    always @(posedge clk or negedge rst_n) begin

        if(!rst_n) begin

            tx_wire   <= 1'b1;
            tx_busy   <= 1'b0;
            shift_reg <= 10'h3FF;
            bit_ptr   <= 4'd0;

        end

        else begin

            // Load Frame
            if(tx_start && !tx_busy) begin

                shift_reg <= {1'b1, tx_byte, 1'b0};
                bit_ptr   <= 4'd10;
                tx_busy   <= 1'b1;

            end

            // Shift Data
            else if(tx_busy && baud_tick) begin

                tx_wire  <= shift_reg[0];
                shift_reg <= {1'b1, shift_reg[9:1]};

                bit_ptr <= bit_ptr - 1'b1;

                if(bit_ptr == 1) begin

                    tx_busy <= 1'b0;
                    tx_wire <= 1'b1;

                end

            end

        end
    end

endmodule