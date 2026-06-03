module bms_active_balancer (
    input  wire        clk,
    input  wire        rst_n,
    input  wire [15:0] cell_v [0:15],
    output reg  [15:0] active_tx_sw,  // Switch to pull energy FROM high cell
    output reg  [15:0] active_rx_sw,  // Switch to push energy TO low cell
    output reg  [15:0] passive_sw     // Switch to dissipate heat via resistors
);
    integer i;
    reg [15:0] peak_v;
    reg [15:0] min_v;
    reg [3:0]  high_id;
    reg [3:0]  low_id;
    
    // Configurable Parameters
    localparam TOLERANCE = 16'd50;       // Voltage difference to trigger active transfer
    localparam FULL_CHARGE = 16'hC350;   // 4.0V threshold for safe heat dissipation

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            active_tx_sw <= 16'h0;
            active_rx_sw <= 16'h0;
            passive_sw   <= 16'h0;
        end else begin
            peak_v = 16'h0000;
            min_v  = 16'hFFFF; // Initialize to maximum possible for accurate Min search
            high_id = 0;
            low_id  = 0;

            // 1. Scan for BOTH the Highest and Lowest Cells
            for (i = 0; i < 16; i = i + 1) begin
                if (cell_v[i] > peak_v) begin
                    peak_v = cell_v[i];
                    high_id = i;
                end
                if (cell_v[i] < min_v) begin
                    min_v = cell_v[i];
                    low_id = i;
                end
            end

            // 2. The Active Balancing Decision Engine
            if ((peak_v - min_v) > TOLERANCE) begin
                // UNEQUAL: Cells are out of balance. Route power from high to low.
                active_tx_sw <= (1'b1 << high_id); // Turn ON discharge switch for high cell
                active_rx_sw <= (1'b1 << low_id);  // Turn ON charge switch for low cell
                passive_sw   <= 16'h0;             // Ensure no heat is wasted
            end 
            else if (peak_v > FULL_CHARGE) begin
                // EQUAL & FULL: All cells are equal AND fully charged. Dissipate heat.
                active_tx_sw <= 16'h0;
                active_rx_sw <= 16'h0;
                passive_sw   <= 16'hFFFF;          // Turn ON all bleed resistors
            end 
            else begin
                // EQUAL & NORMAL: Perfectly balanced and driving normally. Do nothing.
                active_tx_sw <= 16'h0;
                active_rx_sw <= 16'h0;
                passive_sw   <= 16'h0;
            end
        end
    end
endmodule