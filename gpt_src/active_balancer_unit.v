module bms_active_balancer (
    input  wire        clk,
    input  wire        rst_n,
    input  wire        fault_condition,
    input  wire [15:0] cell_v [0:15],

    output reg  [15:0] active_tx_sw,
    output reg  [15:0] active_rx_sw,
    output reg  [15:0] passive_sw
);

    integer i;

    reg [15:0] max_v;
    reg [15:0] min_v;

    reg [3:0] max_id;
    reg [3:0] min_id;

    localparam BALANCE_THR = 16'd50;
    localparam FULL_LIMIT  = 16'hA410;

    always @(posedge clk or negedge rst_n) begin

        if (!rst_n) begin
            active_tx_sw <= 16'd0;
            active_rx_sw <= 16'd0;
            passive_sw   <= 16'd0;
        end

        else begin

            max_v = 16'd0;
            min_v = 16'hFFFF;

            max_id = 0;
            min_id = 0;

            for(i = 0; i < 16; i = i + 1) begin

                if(cell_v[i] > max_v) begin
                    max_v  = cell_v[i];
                    max_id = i;
                end

                if(cell_v[i] < min_v) begin
                    min_v  = cell_v[i];
                    min_id = i;
                end
            end

            active_tx_sw <= 16'd0;
            active_rx_sw <= 16'd0;
            passive_sw   <= 16'd0;

            if(!fault_condition) begin

                if((max_v - min_v) > BALANCE_THR) begin

                    active_tx_sw <= (16'h0001 << max_id);
                    active_rx_sw <= (16'h0001 << min_id);

                end

                else if(max_v > FULL_LIMIT) begin

                    passive_sw <= (16'h0001 << max_id);

                end
            end
        end
    end

endmodule