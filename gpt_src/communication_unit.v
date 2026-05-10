module bms_comm_unit (

    input  wire       clk,
    input  wire       rst_n,
    input  wire [7:0] tx_byte,
    input  wire       tx_en,

    output reg        tx_wire,
    output reg        tx_busy
);

    reg [3:0] bit_ptr;
    reg [9:0] shift_reg;

    always @(posedge clk or negedge rst_n) begin

        if(!rst_n) begin
            tx_wire  <= 1'b1;
            tx_busy  <= 1'b0;
            bit_ptr  <= 4'd0;
            shift_reg <= 10'h3FF;
        end

        else begin

            if(tx_en && !tx_busy) begin

                shift_reg <= {1'b1, tx_byte, 1'b0};
                bit_ptr   <= 4'd10;
                tx_busy   <= 1'b1;
            end

            else if(tx_busy) begin

                tx_wire  <= shift_reg[0];
                shift_reg <= {1'b1, shift_reg[9:1]};
                bit_ptr   <= bit_ptr - 1'b1;

                if(bit_ptr == 1) begin
                    tx_busy <= 1'b0;
                end
            end
        end
    end

endmodule