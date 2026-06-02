module bms_adc_if #(
    parameter CELL_COUNT = 16,
    parameter ADC_WIDTH = 16
)(
    input  wire                      clk,
    input  wire                      rst_n,
    input  wire                      start,
    input  wire [ADC_WIDTH-1:0]      adc_data,
    input  wire                      adc_valid,
    output reg                       adc_busy,
    output reg  [4:0]                sample_idx,
    output reg  [CELL_COUNT*16-1:0]  cell_v_bus,
    output reg  [CELL_COUNT*16-1:0]  cell_v_red_bus,
    output reg                       frame_done
);
    reg bank_sel;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            adc_busy       <= 1'b0;
            sample_idx     <= 5'd0;
            cell_v_bus     <= {(CELL_COUNT*16){1'b0}};
            cell_v_red_bus <= {(CELL_COUNT*16){1'b0}};
            frame_done     <= 1'b0;
            bank_sel       <= 1'b0;
        end else begin
            frame_done <= 1'b0;
            if (start && !adc_busy) begin
                adc_busy   <= 1'b1;
                sample_idx <= 5'd0;
                bank_sel   <= 1'b0;
            end else if (adc_busy && adc_valid) begin
                if (!bank_sel)
                    cell_v_bus[(sample_idx*16) +: 16] <= adc_data;
                else
                    cell_v_red_bus[(sample_idx*16) +: 16] <= adc_data;

                if (sample_idx == (CELL_COUNT - 1)) begin
                    if (!bank_sel) begin
                        sample_idx <= 5'd0;
                        bank_sel   <= 1'b1;
                    end else begin
                        adc_busy   <= 1'b0;
                        frame_done <= 1'b1;
                    end
                end else begin
                    sample_idx <= sample_idx + 5'd1;
                end
            end
        end
    end
endmodule
