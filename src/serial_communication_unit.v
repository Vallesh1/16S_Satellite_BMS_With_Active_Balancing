module bms_comm_unit (
    input  wire       clk,
    input  wire       rst_n,
    input  wire [7:0] tx_byte,
    input  wire       tx_en,
    output reg        tx_wire
);
    reg [3:0] bit_ptr;
    reg [7:0] s_buffer;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            tx_wire <= 1'b1;
            bit_ptr <= 4'd0;
        end else if (tx_en && bit_ptr == 0) begin
            s_buffer <= tx_byte;
            bit_ptr  <= 4'd8;
        end else if (bit_ptr > 0) begin
            tx_wire  <= s_buffer[0];
            s_buffer <= {1'b0, s_buffer[7:1]};
            bit_ptr  <= bit_ptr - 4'd1;
        end
    end
endmodule