// ==============================================================================
// MODULE: bms_fault_processor
// Description: Parallel Cell Watchdog. Evaluates 16 cells simultaneously.
// Fixes Applied: Separated Combinational Logic from Sequential Logic to eliminate 
//                blocking/non-blocking synthesis conflicts and latches.
// ==============================================================================

module bms_fault_processor #(
    parameter CELL_COUNT = 16,
    parameter [15:0] OVP_LIM = 16'hCE66,
    parameter [15:0] UVP_LIM = 16'h8000,
    parameter [11:0] OTP_LIM = 12'h384,
    parameter [11:0] UTP_LIM = 12'h028,
    parameter [15:0] REDUNDANCY_DELTA = 16'd32,
    parameter [3:0]  REDUNDANCY_HITS = 4'd4
)(
    input  wire                     clk,
    input  wire                     rst_n,
    input  wire                     en,
    input  wire [CELL_COUNT*16-1:0] cell_v_bus,
    input  wire [CELL_COUNT*16-1:0] cell_v_red_bus,
    input  wire [11:0]              temp,
    input  wire                     iso_fault,
    input  wire                     emi_alert,
    output reg                      fault_out,
    output reg  [7:0]               fault_code,
    output reg  [CELL_COUNT-1:0]    ov_map,
    output reg  [CELL_COUNT-1:0]    uv_map,
    output reg                      sensor_mismatch
);

    // --- Intermediate Combinational Signals ---
    integer i;
    reg [15:0] v_main;
    reg [15:0] v_red;
    reg ov_flag;
    reg uv_flag;
    reg ot_flag;
    reg ut_flag;
    reg mismatch_flag;

    // --- Next-State Registers (To prevent latches) ---
    reg                      fault_out_nxt;
    reg  [7:0]               fault_code_nxt;
    reg  [CELL_COUNT-1:0]    ov_map_nxt;
    reg  [CELL_COUNT-1:0]    uv_map_nxt;
    reg                      sensor_mismatch_nxt;
    reg  [3:0]               mismatch_cnt;     // Current Sequential State
    reg  [3:0]               mismatch_cnt_nxt; // Combinational Next State

    // --------------------------------------------------------------------------
    // 1. Combinational Logic (Instantly calculates thresholds and faults)
    // --------------------------------------------------------------------------
    always @(*) begin
        // Default Assignments (Prevents inferred latches in synthesis)
        fault_out_nxt       = 1'b0;
        fault_code_nxt      = 8'd0;
        ov_map_nxt          = {CELL_COUNT{1'b0}};
        uv_map_nxt          = {CELL_COUNT{1'b0}};
        sensor_mismatch_nxt = 1'b0;
        mismatch_cnt_nxt    = mismatch_cnt; // Hold count by default

        ov_flag       = 1'b0;
        uv_flag       = 1'b0;
        ot_flag       = (temp > OTP_LIM);
        ut_flag       = (temp < UTP_LIM);
        mismatch_flag = 1'b0;

        // Parallel unrolled loop to inspect all cells instantly
        for (i = 0; i < CELL_COUNT; i = i + 1) begin
            v_main = cell_v_bus[(i*16) +: 16];
            v_red  = cell_v_red_bus[(i*16) +: 16];
            
            ov_map_nxt[i] = (v_main > OVP_LIM);
            uv_map_nxt[i] = (v_main < UVP_LIM);
            
            if (v_main > OVP_LIM) ov_flag = 1'b1;
            if (v_main < UVP_LIM) uv_flag = 1'b1;
            
            if ((v_main >= v_red && (v_main - v_red) > REDUNDANCY_DELTA) ||
                (v_red  >  v_main && (v_red  - v_main) > REDUNDANCY_DELTA)) begin
                mismatch_flag = 1'b1;
            end
        end

        // Sensor Redundancy Debounce Tracker
        if (mismatch_flag) begin
            if (mismatch_cnt < REDUNDANCY_HITS)
                mismatch_cnt_nxt = mismatch_cnt + 4'd1;
        end else begin
            mismatch_cnt_nxt = 4'd0;
        end

        if (mismatch_cnt_nxt >= (REDUNDANCY_HITS - 1'b1))
            sensor_mismatch_nxt = 1'b1;
        else
            sensor_mismatch_nxt = 1'b0;

        // Global Fault Combinational Generation
        fault_out_nxt = ov_flag | uv_flag | ot_flag | ut_flag | iso_fault | emi_alert | sensor_mismatch_nxt;

        // Fault Code Priority Encoder
        if (ov_flag)                 fault_code_nxt = 8'h01;
        else if (uv_flag)            fault_code_nxt = 8'h02;
        else if (ot_flag)            fault_code_nxt = 8'h03;
        else if (ut_flag)            fault_code_nxt = 8'h04;
        else if (iso_fault)          fault_code_nxt = 8'h05;
        else if (emi_alert)          fault_code_nxt = 8'h06;
        else if (sensor_mismatch_nxt)fault_code_nxt = 8'h07;
        else                         fault_code_nxt = 8'h00;
    end

    // --------------------------------------------------------------------------
    // 2. Sequential Logic (Pushes combinatorial states to physical flip-flops)
    // --------------------------------------------------------------------------
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            fault_out       <= 1'b0;
            fault_code      <= 8'd0;
            ov_map          <= {CELL_COUNT{1'b0}};
            uv_map          <= {CELL_COUNT{1'b0}};
            sensor_mismatch <= 1'b0;
            mismatch_cnt    <= 4'd0;
        end else if (!en) begin
            fault_out       <= 1'b0;
            fault_code      <= 8'd0;
            ov_map          <= {CELL_COUNT{1'b0}};
            uv_map          <= {CELL_COUNT{1'b0}};
            sensor_mismatch <= 1'b0;
            mismatch_cnt    <= 4'd0;
        end else begin
            fault_out       <= fault_out_nxt;
            fault_code      <= fault_code_nxt;
            ov_map          <= ov_map_nxt;
            uv_map          <= uv_map_nxt;
            sensor_mismatch <= sensor_mismatch_nxt;
            mismatch_cnt    <= mismatch_cnt_nxt;
        end
    end

endmodule