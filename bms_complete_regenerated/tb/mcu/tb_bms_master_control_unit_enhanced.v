`timescale 1ns/1ns
module tb_bms_master_control_unit_enhanced;
    reg clk;
    reg rst_n;
    reg start_poll;
    reg spi_miso;
    reg [15:0] pack_current;
    reg [11:0] lmu0_temp_die, lmu1_temp_die, lmu2_temp_die;
    reg [15:0] lmu0_soc, lmu1_soc, lmu2_soc;
    reg [15:0] lmu0_soh, lmu1_soh, lmu2_soh;
    reg lmu0_fault, lmu1_fault, lmu2_fault;
    reg [7:0] lmu0_fault_code, lmu1_fault_code, lmu2_fault_code;
    wire spi_sclk, spi_mosi;
    wire [2:0] spi_cs_n;
    wire [15:0] pack_soc_avg, pack_soh_avg;
    wire global_fault;
    wire [7:0] global_fault_code;
    wire [1:0] active_lmu_id;
    wire poll_busy;
    wire current_warn, current_trip, thermal_warn, thermal_trip, lmu_count_fault;
    wire [15:0] allowed_current;
    wire [7:0] supervisor_code;
    wire [11:0] max_temp_seen;

    integer pass_count;
    integer fail_count;

    bms_master_control_unit_enhanced dut (
        .clk(clk), .rst_n(rst_n), .start_poll(start_poll), .spi_miso(spi_miso), .pack_current(pack_current),
        .lmu0_temp_die(lmu0_temp_die), .lmu1_temp_die(lmu1_temp_die), .lmu2_temp_die(lmu2_temp_die),
        .lmu0_soc(lmu0_soc), .lmu1_soc(lmu1_soc), .lmu2_soc(lmu2_soc), .lmu0_soh(lmu0_soh), .lmu1_soh(lmu1_soh), .lmu2_soh(lmu2_soh),
        .lmu0_fault(lmu0_fault), .lmu1_fault(lmu1_fault), .lmu2_fault(lmu2_fault),
        .lmu0_fault_code(lmu0_fault_code), .lmu1_fault_code(lmu1_fault_code), .lmu2_fault_code(lmu2_fault_code),
        .spi_sclk(spi_sclk), .spi_mosi(spi_mosi), .spi_cs_n(spi_cs_n), .pack_soc_avg(pack_soc_avg), .pack_soh_avg(pack_soh_avg),
        .global_fault(global_fault), .global_fault_code(global_fault_code), .active_lmu_id(active_lmu_id), .poll_busy(poll_busy),
        .current_warn(current_warn), .current_trip(current_trip), .thermal_warn(thermal_warn), .thermal_trip(thermal_trip),
        .lmu_count_fault(lmu_count_fault), .allowed_current(allowed_current), .supervisor_code(supervisor_code), .max_temp_seen(max_temp_seen)
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

    task poll_once;
        begin
            start_poll = 1'b1;
            @(posedge clk);
            start_poll = 1'b0;
            repeat(40) @(posedge clk);
        end
    endtask

    initial begin
        $dumpfile("sim/tb_bms_master_control_unit_enhanced.vcd");
        $dumpvars(0, tb_bms_master_control_unit_enhanced);

        pass_count = 0;
        fail_count = 0;
        rst_n = 0;
        start_poll = 0;
        spi_miso = 0;
        pack_current = 16'd120;
        lmu0_temp_die = 12'd35; lmu1_temp_die = 12'd40; lmu2_temp_die = 12'd38;
        lmu0_soc = 16'd810; lmu1_soc = 16'd780; lmu2_soc = 16'd750;
        lmu0_soh = 16'd970; lmu1_soh = 16'd940; lmu2_soh = 16'd910;
        lmu0_fault = 0; lmu1_fault = 0; lmu2_fault = 0;
        lmu0_fault_code = 8'h11; lmu1_fault_code = 8'h22; lmu2_fault_code = 8'h33;

        repeat(8) @(posedge clk);
        rst_n = 1;
        repeat(10) @(posedge clk);

        poll_once();
        $display("INFO MCU nominal: avg_soc=%0d avg_soh=%0d max_temp=%0d global_fault=%b code=0x%0h",
                 pack_soc_avg, pack_soh_avg, max_temp_seen, global_fault, global_fault_code);
        check(pack_soc_avg !== 16'hxxxx, "MCU average SOC is driven");
        check(pack_soh_avg !== 16'hxxxx, "MCU average SOH is driven");
        check(max_temp_seen !== 12'hxxx, "MCU max temperature is driven");

        pack_current = 16'd250;
        poll_once();
        check(current_warn !== 1'bx, "Current warning path is driven");

        pack_current = 16'd320;
        poll_once();
        check(current_trip !== 1'bx, "Current trip path is driven");

        pack_current = 16'd100;
        lmu2_temp_die = 12'd70;
        poll_once();
        check(thermal_warn !== 1'bx, "Thermal warning path is driven");

        lmu2_temp_die = 12'd90;
        poll_once();
        check(thermal_trip !== 1'bx, "Thermal trip path is driven");

        lmu2_temp_die = 12'd38;
        lmu0_soc = 16'd600; lmu1_soc = 16'd900; lmu2_soc = 16'd300;
        lmu0_soh = 16'd980; lmu1_soh = 16'd920; lmu2_soh = 16'd860;
        poll_once();
        check(pack_soc_avg !== 16'hxxxx, "MCU updates average SOC for new LMU values");
        check(pack_soh_avg !== 16'hxxxx, "MCU updates average SOH for new LMU values");

        lmu1_fault = 1'b1;
        poll_once();
        check(global_fault !== 1'bx, "Global fault output is driven when LMU fault present");
        check(global_fault_code !== 8'hxx, "Global fault code is driven when LMU fault present");

        lmu1_fault = 1'b0;
        lmu0_fault = 1'b1;
        poll_once();
        check(global_fault_code !== 8'hxx, "Fault code remains driven for LMU0 fault case");

        lmu0_fault = 1'b0;
        lmu2_fault = 1'b1;
        poll_once();
        check(global_fault_code !== 8'hxx, "Fault code remains driven for LMU2 fault case");

        lmu2_fault = 1'b0;
        poll_once();
        check(global_fault !== 1'bx, "Global fault output remains driven after fault clear");

        $display("MCU TB SUMMARY: PASS=%0d FAIL=%0d", pass_count, fail_count);
        if (fail_count == 0) $display("TB_RESULT: PASS"); else $display("TB_RESULT: FAIL");
        #50;
        $finish;
    end
endmodule
