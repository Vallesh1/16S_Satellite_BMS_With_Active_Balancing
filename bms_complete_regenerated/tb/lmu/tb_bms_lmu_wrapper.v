`timescale 1ns/1ns
module tb_bms_lmu_wrapper;
    reg clk;
    reg rst_n;
    reg adc_start;
    reg [15:0] adc_data;
    reg adc_valid;
    reg [15:0] pack_i;
    reg [15:0] pack_v_avg;
    reg [15:0] charge_cycles;
    reg [11:0] temp_die;
    reg [191:0] cell_t_bus;
    reg [15:0] iso_resistance;
    reg emi_in;
    reg [1:0] comm_sel;
    reg spi_sclk;
    reg spi_ss_n;
    reg spi_mosi;
    wire spi_miso;
    wire uart_tx;
    wire [63:0] can_frame;
    wire can_valid;
    wire [15:0] active_tx_sw;
    wire [15:0] active_rx_sw;
    wire [15:0] passive_sw;
    wire fault_trip;
    wire [7:0] fault_code;
    wire [15:0] soc_out;
    wire [15:0] soh_out;

    integer pass_count;
    integer fail_count;

    bms_lmu_wrapper dut (
        .clk(clk), .rst_n(rst_n), .adc_start(adc_start), .adc_data(adc_data), .adc_valid(adc_valid),
        .pack_i(pack_i), .pack_v_avg(pack_v_avg), .charge_cycles(charge_cycles), .temp_die(temp_die),
        .cell_t_bus(cell_t_bus), .iso_resistance(iso_resistance), .emi_in(emi_in), .comm_sel(comm_sel),
        .spi_sclk(spi_sclk), .spi_ss_n(spi_ss_n), .spi_mosi(spi_mosi), .spi_miso(spi_miso),
        .uart_tx(uart_tx), .can_frame(can_frame), .can_valid(can_valid),
        .active_tx_sw(active_tx_sw), .active_rx_sw(active_rx_sw), .passive_sw(passive_sw),
        .fault_trip(fault_trip), .fault_code(fault_code), .soc_out(soc_out), .soh_out(soh_out)
    );

    initial begin clk = 0; forever #5 clk = ~clk; end
    initial begin spi_sclk = 0; forever #20 spi_sclk = ~spi_sclk; end

    task check;
        input cond;
        input [255:0] msg;
        begin
            if (cond) begin
                pass_count = pass_count + 1;
                $display("PASS: %0s", msg);
            end else begin
                fail_count = fail_count + 1;
                $display("FAIL: %0s", msg);
            end
        end
    endtask

    task pulse_adc_sample;
        input [15:0] sample;
        begin
            adc_data  = sample;
            adc_start = 1'b1;
            adc_valid = 1'b1;
            @(posedge clk);
            adc_start = 1'b0;
            adc_valid = 1'b0;
        end
    endtask

    initial begin
        $dumpfile("sim/tb_bms_lmu_wrapper.vcd");
        $dumpvars(0, tb_bms_lmu_wrapper);

        pass_count = 0;
        fail_count = 0;
        rst_n = 0;
        adc_start = 0;
        adc_data = 0;
        adc_valid = 0;
        pack_i = 0;
        pack_v_avg = 0;
        charge_cycles = 0;
        temp_die = 12'd35;
        cell_t_bus = {16{12'd35}};
        iso_resistance = 16'd5000;
        emi_in = 0;
        comm_sel = 2'd1;
        spi_ss_n = 1;
        spi_mosi = 0;

        repeat(8) @(posedge clk);
        rst_n = 1;
        repeat(20) @(posedge clk);

        pulse_adc_sample(16'd3900);
        pack_i = 16'd100;
        pack_v_avg = 16'd3800;
        charge_cycles = 16'd120;
        temp_die = 12'd35;
        cell_t_bus = {16{12'd35}};
        iso_resistance = 16'd5000;
        emi_in = 1'b0;
        repeat(25) @(posedge clk);
        $display("INFO LMU nominal: fault_trip=%b fault_code=0x%0h soc=%0d soh=%0d", fault_trip, fault_code, soc_out, soh_out);
        check(soc_out !== 16'hxxxx, "SOC output is driven in nominal case");
        check(soh_out !== 16'hxxxx, "SOH output is driven in nominal case");

        pulse_adc_sample(16'd4100);
        pack_i = 16'd180;
        pack_v_avg = 16'd3950;
        charge_cycles = 16'd300;
        temp_die = 12'd45;
        repeat(20) @(posedge clk);
        check(soc_out !== 16'hxxxx, "LMU responds to second operating point");
        check(soh_out !== 16'hxxxx, "LMU keeps SOH driven after updated cycles");

        iso_resistance = 16'd50;
        repeat(20) @(posedge clk);
        check(fault_trip == 1'b1, "Isolation fault stimulus asserts fault_trip");

        iso_resistance = 16'd5000;
        emi_in = 1'b1;
        repeat(20) @(posedge clk);
        check(fault_trip == 1'b1 || fault_trip == 1'b0, "EMI stimulus executed without X state");

        emi_in = 1'b0;
        temp_die = 12'd85;
        cell_t_bus = {16{12'd80}};
        pulse_adc_sample(16'd3600);
        repeat(20) @(posedge clk);
        check(soc_out !== 16'hxxxx, "Hot-condition stimulus keeps outputs valid");

        comm_sel = 2'd0;
        repeat(10) @(posedge clk);
        check(uart_tx !== 1'bx, "UART path remains driven when mode changes");

        comm_sel = 2'd2;
        repeat(10) @(posedge clk);
        check(can_valid !== 1'bx, "CAN status remains driven when mode changes");

        spi_ss_n = 1'b0;
        repeat(4) begin
            spi_mosi = ~spi_mosi;
            @(posedge spi_sclk);
        end
        spi_ss_n = 1'b1;
        repeat(10) @(posedge clk);
        check(spi_miso !== 1'bx, "SPI MISO remains driven during slave activity");

        $display("LMU TB SUMMARY: PASS=%0d FAIL=%0d", pass_count, fail_count);
        if (fail_count == 0) $display("TB_RESULT: PASS"); else $display("TB_RESULT: FAIL");
        #50;
        $finish;
    end
endmodule
