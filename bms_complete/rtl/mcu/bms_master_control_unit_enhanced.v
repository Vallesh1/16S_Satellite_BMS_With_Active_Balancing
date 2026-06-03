module bms_master_control_unit_enhanced(
    input  wire        clk,
    input  wire        rst_n,
    input  wire        start_poll,
    input  wire        spi_miso,
    input  wire [15:0] pack_current,
    input  wire [11:0] lmu0_temp_die,
    input  wire [11:0] lmu1_temp_die,
    input  wire [11:0] lmu2_temp_die,
    input  wire [15:0] lmu0_soc,
    input  wire [15:0] lmu1_soc,
    input  wire [15:0] lmu2_soc,
    input  wire [15:0] lmu0_soh,
    input  wire [15:0] lmu1_soh,
    input  wire [15:0] lmu2_soh,
    input  wire        lmu0_fault,
    input  wire        lmu1_fault,
    input  wire        lmu2_fault,
    input  wire [7:0]  lmu0_fault_code,
    input  wire [7:0]  lmu1_fault_code,
    input  wire [7:0]  lmu2_fault_code,
    output wire        spi_sclk,
    output wire        spi_mosi,
    output wire [2:0]  spi_cs_n,
    output reg  [15:0] pack_soc_avg,
    output reg  [15:0] pack_soh_avg,
    output reg         global_fault,
    output reg  [7:0]  global_fault_code,
    output reg  [1:0]  active_lmu_id,
    output reg         poll_busy,
    output wire        current_warn,
    output wire        current_trip,
    output wire        thermal_warn,
    output wire        thermal_trip,
    output wire        lmu_count_fault,
    output wire [15:0] allowed_current,
    output wire [7:0]  supervisor_code,
    output reg  [11:0] max_temp_seen
);
    reg        spi_start;
    reg [1:0]  spi_slave_sel;
    reg [7:0]  spi_tx_byte;
    wire       spi_busy;
    wire       spi_done;
    wire [7:0] spi_rx_byte;
    reg [2:0]  state;
    wire [3:0] active_lmu_count;

    assign active_lmu_count = 4'd3;

    localparam ST_IDLE  = 3'd0;
    localparam ST_LMU0  = 3'd1;
    localparam ST_LMU1  = 3'd2;
    localparam ST_LMU2  = 3'd3;
    localparam ST_EVAL  = 3'd4;

    bms_spi_master u_spi_master (
        .clk(clk), .rst_n(rst_n), .start(spi_start), .slave_sel(spi_slave_sel), .tx_byte(spi_tx_byte), .miso(spi_miso),
        .busy(spi_busy), .done(spi_done), .rx_byte(spi_rx_byte), .sclk(spi_sclk), .mosi(spi_mosi), .cs_n(spi_cs_n)
    );

    bms_current_limit_supervisor u_curr_sup (
        .clk(clk), .rst_n(rst_n), .pack_current(pack_current), .max_temp_seen(max_temp_seen), .active_lmu_count(active_lmu_count),
        .global_fault_in(global_fault), .current_warn(current_warn), .current_trip(current_trip), .thermal_warn(thermal_warn),
        .thermal_trip(thermal_trip), .lmu_count_fault(lmu_count_fault), .allowed_current(allowed_current), .supervisor_code(supervisor_code)
    );

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            spi_start         <= 1'b0;
            spi_slave_sel     <= 2'd0;
            spi_tx_byte       <= 8'h00;
            pack_soc_avg      <= 16'd0;
            pack_soh_avg      <= 16'd0;
            global_fault      <= 1'b0;
            global_fault_code <= 8'd0;
            active_lmu_id     <= 2'd0;
            poll_busy         <= 1'b0;
            max_temp_seen     <= 12'd0;
            state             <= ST_IDLE;
        end else begin
            spi_start <= 1'b0;
            case (state)
                ST_IDLE: begin
                    poll_busy <= 1'b0;
                    if (start_poll) begin
                        poll_busy     <= 1'b1;
                        active_lmu_id <= 2'd0;
                        spi_slave_sel <= 2'd0;
                        spi_tx_byte   <= 8'hB0;
                        spi_start     <= 1'b1;
                        state         <= ST_LMU0;
                    end
                end
                ST_LMU0: begin
                    if (spi_done) begin
                        active_lmu_id <= 2'd1;
                        spi_slave_sel <= 2'd1;
                        spi_tx_byte   <= 8'hB1;
                        spi_start     <= 1'b1;
                        state         <= ST_LMU1;
                    end
                end
                ST_LMU1: begin
                    if (spi_done) begin
                        active_lmu_id <= 2'd2;
                        spi_slave_sel <= 2'd2;
                        spi_tx_byte   <= 8'hB2;
                        spi_start     <= 1'b1;
                        state         <= ST_LMU2;
                    end
                end
                ST_LMU2: begin
                    if (spi_done)
                        state <= ST_EVAL;
                end
                default: begin
                    pack_soc_avg <= (lmu0_soc + lmu1_soc + lmu2_soc) / 3'd3;
                    pack_soh_avg <= (lmu0_soh + lmu1_soh + lmu2_soh) / 3'd3;
                    if ((lmu0_temp_die >= lmu1_temp_die) && (lmu0_temp_die >= lmu2_temp_die))
                        max_temp_seen <= lmu0_temp_die;
                    else if (lmu1_temp_die >= lmu2_temp_die)
                        max_temp_seen <= lmu1_temp_die;
                    else
                        max_temp_seen <= lmu2_temp_die;

                    global_fault <= lmu0_fault | lmu1_fault | lmu2_fault;
                    if (lmu0_fault)
                        global_fault_code <= lmu0_fault_code;
                    else if (lmu1_fault)
                        global_fault_code <= lmu1_fault_code;
                    else if (lmu2_fault)
                        global_fault_code <= lmu2_fault_code;
                    else
                        global_fault_code <= 8'h00;
                    poll_busy <= 1'b0;
                    state <= ST_IDLE;
                end
            endcase
        end
    end
endmodule
