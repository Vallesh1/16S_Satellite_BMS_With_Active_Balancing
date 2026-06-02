module bms_current_limit_supervisor #(
    parameter [15:0] MCU_MAX_PACK_CURRENT  = 16'd300,
    parameter [15:0] MCU_WARN_PACK_CURRENT = 16'd240,
    parameter [11:0] MCU_MAX_TEMP          = 12'd80,
    parameter [11:0] MCU_WARN_TEMP         = 12'd65,
    parameter [3:0]  MCU_MAX_LMU_COUNT     = 4'd3
)(
    input  wire        clk,
    input  wire        rst_n,
    input  wire [15:0] pack_current,
    input  wire [11:0] max_temp_seen,
    input  wire [3:0]  active_lmu_count,
    input  wire        global_fault_in,
    output reg         current_warn,
    output reg         current_trip,
    output reg         thermal_warn,
    output reg         thermal_trip,
    output reg         lmu_count_fault,
    output reg [15:0]  allowed_current,
    output reg [7:0]   supervisor_code
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_warn    <= 1'b0;
            current_trip    <= 1'b0;
            thermal_warn    <= 1'b0;
            thermal_trip    <= 1'b0;
            lmu_count_fault <= 1'b0;
            allowed_current <= MCU_MAX_PACK_CURRENT;
            supervisor_code <= 8'h00;
        end else begin
            current_warn    <= (pack_current >= MCU_WARN_PACK_CURRENT);
            current_trip    <= (pack_current >= MCU_MAX_PACK_CURRENT);
            thermal_warn    <= (max_temp_seen >= MCU_WARN_TEMP);
            thermal_trip    <= (max_temp_seen >= MCU_MAX_TEMP);
            lmu_count_fault <= (active_lmu_count > MCU_MAX_LMU_COUNT);
            if (max_temp_seen >= MCU_MAX_TEMP)
                allowed_current <= MCU_MAX_PACK_CURRENT >> 2;
            else if (max_temp_seen >= MCU_WARN_TEMP)
                allowed_current <= MCU_MAX_PACK_CURRENT >> 1;
            else
                allowed_current <= MCU_MAX_PACK_CURRENT;
            if (global_fault_in)
                supervisor_code <= 8'hE1;
            else if (active_lmu_count > MCU_MAX_LMU_COUNT)
                supervisor_code <= 8'hE2;
            else if (pack_current >= MCU_MAX_PACK_CURRENT)
                supervisor_code <= 8'hE3;
            else if (max_temp_seen >= MCU_MAX_TEMP)
                supervisor_code <= 8'hE4;
            else if ((pack_current >= MCU_WARN_PACK_CURRENT) || (max_temp_seen >= MCU_WARN_TEMP))
                supervisor_code <= 8'hA1;
            else
                supervisor_code <= 8'h00;
        end
    end
endmodule
