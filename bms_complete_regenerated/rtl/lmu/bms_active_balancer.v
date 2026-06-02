module bms_active_balancer #(
    parameter CELL_COUNT = 16,
    parameter [15:0] TOLERANCE = 16'd50,
    parameter [15:0] FULL_CHARGE = 16'hC350,
    parameter [11:0] THERMAL_LIMIT = 12'h370,
    parameter [31:0] BAL_ON_TICKS = 32'd50000,
    parameter [31:0] BAL_OFF_TICKS = 32'd10000
)(
    input  wire                     clk,
    input  wire                     rst_n,
    input  wire                     en,
    input  wire [CELL_COUNT*16-1:0] cell_v_bus,
    input  wire [CELL_COUNT*12-1:0] cell_t_bus,
    output reg  [CELL_COUNT-1:0]    active_tx_sw,
    output reg  [CELL_COUNT-1:0]    active_rx_sw,
    output reg  [CELL_COUNT-1:0]    passive_sw,
    output reg                      balance_busy,
    output reg  [3:0]               high_id_o,
    output reg  [3:0]               low_id_o
);
    integer i;
    reg [15:0] cell_v_i;
    reg [11:0] cell_t_i;
    reg [15:0] peak_v;
    reg [15:0] min_v;
    reg [3:0]  high_id;
    reg [3:0]  low_id;
    reg [31:0] dwell_cnt;
    reg        phase_on;
    reg        thermal_block;
    reg [CELL_COUNT-1:0] tx_mask;
    reg [CELL_COUNT-1:0] rx_mask;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            active_tx_sw <= {CELL_COUNT{1'b0}};
            active_rx_sw <= {CELL_COUNT{1'b0}};
            passive_sw   <= {CELL_COUNT{1'b0}};
            balance_busy <= 1'b0;
            high_id_o    <= 4'd0;
            low_id_o     <= 4'd0;
            dwell_cnt    <= 32'd0;
            phase_on     <= 1'b0;
        end else if (!en) begin
            active_tx_sw <= {CELL_COUNT{1'b0}};
            active_rx_sw <= {CELL_COUNT{1'b0}};
            passive_sw   <= {CELL_COUNT{1'b0}};
            balance_busy <= 1'b0;
            dwell_cnt    <= 32'd0;
            phase_on     <= 1'b0;
        end else begin
            peak_v        = 16'h0000;
            min_v         = 16'hFFFF;
            high_id       = 4'd0;
            low_id        = 4'd0;
            thermal_block = 1'b0;
            tx_mask       = {CELL_COUNT{1'b0}};
            rx_mask       = {CELL_COUNT{1'b0}};

            for (i = 0; i < CELL_COUNT; i = i + 1) begin
                cell_v_i = cell_v_bus[(i*16) +: 16];
                if (cell_v_i > peak_v) begin
                    peak_v  = cell_v_i;
                    high_id = i[3:0];
                end
                if (cell_v_i < min_v) begin
                    min_v  = cell_v_i;
                    low_id = i[3:0];
                end
            end

            high_id_o <= high_id;
            low_id_o  <= low_id;
            cell_t_i  = cell_t_bus[(high_id*12) +: 12];
            if (cell_t_i >= THERMAL_LIMIT)
                thermal_block = 1'b1;

            tx_mask[high_id] = 1'b1;
            rx_mask[low_id]  = 1'b1;

            if ((peak_v - min_v) > TOLERANCE) begin
                balance_busy <= 1'b1;
                if (phase_on == 1'b0) begin
                    active_tx_sw <= {CELL_COUNT{1'b0}};
                    active_rx_sw <= {CELL_COUNT{1'b0}};
                    passive_sw   <= {CELL_COUNT{1'b0}};
                    if (dwell_cnt >= (BAL_OFF_TICKS - 1)) begin
                        dwell_cnt <= 32'd0;
                        phase_on  <= 1'b1;
                    end else begin
                        dwell_cnt <= dwell_cnt + 32'd1;
                    end
                end else begin
                    if (thermal_block) begin
                        active_tx_sw <= {CELL_COUNT{1'b0}};
                        active_rx_sw <= {CELL_COUNT{1'b0}};
                        passive_sw   <= {CELL_COUNT{1'b0}};
                    end else begin
                        active_tx_sw <= tx_mask;
                        active_rx_sw <= rx_mask;
                        passive_sw   <= {CELL_COUNT{1'b0}};
                    end
                    if (dwell_cnt >= (BAL_ON_TICKS - 1)) begin
                        dwell_cnt <= 32'd0;
                        phase_on  <= 1'b0;
                    end else begin
                        dwell_cnt <= dwell_cnt + 32'd1;
                    end
                end
            end else if (peak_v > FULL_CHARGE) begin
                balance_busy <= 1'b0;
                active_tx_sw <= {CELL_COUNT{1'b0}};
                active_rx_sw <= {CELL_COUNT{1'b0}};
                passive_sw   <= {CELL_COUNT{1'b1}};
                dwell_cnt    <= 32'd0;
                phase_on     <= 1'b0;
            end else begin
                balance_busy <= 1'b0;
                active_tx_sw <= {CELL_COUNT{1'b0}};
                active_rx_sw <= {CELL_COUNT{1'b0}};
                passive_sw   <= {CELL_COUNT{1'b0}};
                dwell_cnt    <= 32'd0;
                phase_on     <= 1'b0;
            end
        end
    end
endmodule
