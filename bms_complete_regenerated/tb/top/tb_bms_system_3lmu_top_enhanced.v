`timescale 1ns/1ns
module tb_bms_system_3lmu_top_enhanced;
    reg clk;
    reg rst_n;
    reg start_poll;
    reg [15:0] pack_current;

    reg lmu0_adc_start, lmu1_adc_start, lmu2_adc_start;
    reg [15:0] lmu0_adc_data, lmu1_adc_data, lmu2_adc_data;
    reg lmu0_adc_valid, lmu1_adc_valid, lmu2_adc_valid;
    reg [15:0] lmu0_pack_i, lmu1_pack_i, lmu2_pack_i;
    reg [15:0] lmu0_pack_v_avg, lmu1_pack_v_avg, lmu2_pack_v_avg;
    reg [15:0] lmu0_charge_cycles, lmu1_charge_cycles, lmu2_charge_cycles;
    reg [11:0] lmu0_temp_die, lmu1_temp_die, lmu2_temp_die;
    reg [191:0] lmu0_cell_t_bus, lmu1_cell_t_bus, lmu2_cell_t_bus;
    reg [15:0] lmu0_iso_resistance, lmu1_iso_resistance, lmu2_iso_resistance;
    reg lmu0_emi_in, lmu1_emi_in, lmu2_emi_in;
    reg spi_miso;

    wire spi_sclk, spi_mosi;
    wire [2:0] spi_cs_n;
    wire [15:0] pack_soc_avg, pack_soh_avg;
    wire global_fault;
    wire [7:0] global_fault_code;

    integer pass_count;
    integer fail_count;

    bms_system_3lmu_top_enhanced dut (
        .clk(clk), .rst_n(rst_n), .start_poll(start_poll), .pack_current(pack_current),
        .lmu0_adc_start(lmu0_adc_start), .lmu0_adc_data(lmu0_adc_data), .lmu0_adc_valid(lmu0_adc_valid), .lmu0_pack_i(lmu0_pack_i), .lmu0_pack_v_avg(lmu0_pack_v_avg), .lmu0_charge_cycles(lmu0_charge_cycles), .lmu0_temp_die(lmu0_temp_die), .lmu0_cell_t_bus(lmu0_cell_t_bus), .lmu0_iso_resistance(lmu0_iso_resistance), .lmu0_emi_in(lmu0_emi_in),
        .lmu1_adc_start(lmu1_adc_start), .lmu1_adc_data(lmu1_adc_data), .lmu1_adc_valid(lmu1_adc_valid), .lmu1_pack_i(lmu1_pack_i), .lmu1_pack_v_avg(lmu1_pack_v_avg), .lmu1_charge_cycles(lmu1_charge_cycles), .lmu1_temp_die(lmu1_temp_die), .lmu1_cell_t_bus(lmu1_cell_t_bus), .lmu1_iso_resistance(lmu1_iso_resistance), .lmu1_emi_in(lmu1_emi_in),
        .lmu2_adc_start(lmu2_adc_start), .lmu2_adc_data(lmu2_adc_data), .lmu2_adc_valid(lmu2_adc_valid), .lmu2_pack_i(lmu2_pack_i), .lmu2_pack_v_avg(lmu2_pack_v_avg), .lmu2_charge_cycles(lmu2_charge_cycles), .lmu2_temp_die(lmu2_temp_die), .lmu2_cell_t_bus(lmu2_cell_t_bus), .lmu2_iso_resistance(lmu2_iso_resistance), .lmu2_emi_in(lmu2_emi_in),
        .spi_miso(spi_miso), .spi_sclk(spi_sclk), .spi_mosi(spi_mosi), .spi_cs_n(spi_cs_n), .pack_soc_avg(pack_soc_avg), .pack_soh_avg(pack_soh_avg), .global_fault(global_fault), .global_fault_code(global_fault_code)
    );

    initial begin clk = 0; forever #5 clk = ~clk; end

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

    task pulse_lmu_adc;
        output reg start_sig;
        output reg valid_sig;
        begin
            start_sig = 1'b1;
            valid_sig = 1'b1;
            @(posedge clk);
            start_sig = 1'b0;
            valid_sig = 1'b0;
        end
    endtask

    initial begin
        $dumpfile("sim/tb_bms_system_3lmu_top_enhanced.vcd");
        $dumpvars(0, tb_bms_system_3lmu_top_enhanced);

        pass_count = 0;
        fail_count = 0;
        rst_n = 0;
        start_poll = 0;
        pack_current = 16'd120;
        spi_miso = 0;

        lmu0_adc_start = 0; lmu1_adc_start = 0; lmu2_adc_start = 0;
        lmu0_adc_valid = 0; lmu1_adc_valid = 0; lmu2_adc_valid = 0;
        lmu0_adc_data = 16'd3900; lmu1_adc_data = 16'd3850; lmu2_adc_data = 16'd3800;
        lmu0_pack_i = 16'd100; lmu1_pack_i = 16'd105; lmu2_pack_i = 16'd110;
        lmu0_pack_v_avg = 16'd3800; lmu1_pack_v_avg = 16'd3790; lmu2_pack_v_avg = 16'd3780;
        lmu0_charge_cycles = 16'd100; lmu1_charge_cycles = 16'd120; lmu2_charge_cycles = 16'd140;
        lmu0_temp_die = 12'd35; lmu1_temp_die = 12'd37; lmu2_temp_die = 12'd39;
        lmu0_cell_t_bus = {16{12'd35}}; lmu1_cell_t_bus = {16{12'd36}}; lmu2_cell_t_bus = {16{12'd37}};
        lmu0_iso_resistance = 16'd5000; lmu1_iso_resistance = 16'd5000; lmu2_iso_resistance = 16'd5000;
        lmu0_emi_in = 0; lmu1_emi_in = 0; lmu2_emi_in = 0;

        repeat(8) @(posedge clk);
        rst_n = 1;
        repeat(10) @(posedge clk);

        pulse_lmu_adc(lmu0_adc_start, lmu0_adc_valid);
        pulse_lmu_adc(lmu1_adc_start, lmu1_adc_valid);
        pulse_lmu_adc(lmu2_adc_start, lmu2_adc_valid);
        start_poll = 1'b1;
        @(posedge clk);
        start_poll = 1'b0;
        repeat(80) @(posedge clk);

        $display("INFO TOP nominal: avg_soc=%0d avg_soh=%0d global_fault=%b code=0x%0h",
                 pack_soc_avg, pack_soh_avg, global_fault, global_fault_code);
        check(pack_soc_avg !== 16'hxxxx, "Top-level pack SOC output is driven");
        check(pack_soh_avg !== 16'hxxxx, "Top-level pack SOH output is driven");
        check(global_fault !== 1'bx, "Top-level global fault output is driven");

        lmu1_iso_resistance = 16'd50;
        repeat(40) @(posedge clk);
        check(global_fault !== 1'bx, "Top-level fault path remains driven on LMU1 fault stimulus");
        check(global_fault_code !== 8'hxx, "Top-level fault code remains driven on LMU1 fault stimulus");

        lmu1_iso_resistance = 16'd5000;
        lmu2_temp_die = 12'd90;
        pack_current = 16'd320;
        start_poll = 1'b1;
        @(posedge clk);
        start_poll = 1'b0;
        repeat(80) @(posedge clk);
        check(pack_soc_avg !== 16'hxxxx, "Top-level outputs remain driven during thermal/current stress");

        $display("TOP TB SUMMARY: PASS=%0d FAIL=%0d", pass_count, fail_count);
        if (fail_count == 0) $display("TB_RESULT: PASS"); else $display("TB_RESULT: FAIL");
        #50;
        $finish;
    end
endmodule
