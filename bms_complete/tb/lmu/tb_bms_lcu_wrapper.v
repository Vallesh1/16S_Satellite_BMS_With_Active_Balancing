`timescale 1ns/1ps
module tb_bms_lcu_wrapper;
    reg clk, rst_n, adc_start, adc_valid, emi_in, spi_sclk, spi_ss_n, spi_mosi;
    reg [15:0] adc_data, pack_i, pack_v_avg, charge_cycles, iso_resistance;
    reg [11:0] temp_die;
    reg [191:0] cell_t_bus;
    reg [1:0] comm_sel;
    wire spi_miso, uart_tx, can_valid, fault_trip;
    wire [63:0] can_frame;
    wire [15:0] active_tx_sw, active_rx_sw, passive_sw, soc_out, soh_out;
    wire [7:0] fault_code;
    integer pass_count, fail_count;

    bms_lcu_wrapper dut (
        .clk(clk), .rst_n(rst_n), .adc_start(adc_start), .adc_data(adc_data), .adc_valid(adc_valid), .pack_i(pack_i),
        .pack_v_avg(pack_v_avg), .charge_cycles(charge_cycles), .temp_die(temp_die), .cell_t_bus(cell_t_bus),
        .iso_resistance(iso_resistance), .emi_in(emi_in), .comm_sel(comm_sel), .spi_sclk(spi_sclk), .spi_ss_n(spi_ss_n),
        .spi_mosi(spi_mosi), .spi_miso(spi_miso), .uart_tx(uart_tx), .can_frame(can_frame), .can_valid(can_valid),
        .active_tx_sw(active_tx_sw), .active_rx_sw(active_rx_sw), .passive_sw(passive_sw), .fault_trip(fault_trip),
        .fault_code(fault_code), .soc_out(soc_out), .soh_out(soh_out)
    );

    initial begin clk=0; forever #5 clk=~clk; end
    task check; input cond; input [255:0] msg; begin if(cond) begin pass_count=pass_count+1; $display("PASS: %0s",msg); end else begin fail_count=fail_count+1; $display("FAIL: %0s",msg); end end endtask

    initial begin
        $dumpfile("tb_bms_lcu_wrapper.vcd");
        $dumpvars(0,tb_bms_lcu_wrapper);
        pass_count=0; fail_count=0;
        rst_n=0; adc_start=0; adc_valid=0; emi_in=0; spi_sclk=0; spi_ss_n=1; spi_mosi=0;
        adc_data=0; pack_i=120; pack_v_avg=3700; charge_cycles=100; iso_resistance=900; temp_die=35; cell_t_bus={16{12'd30}}; comm_sel=2'd1;
        repeat(5) @(posedge clk); rst_n=1; repeat(5) @(posedge clk);
        adc_start=1; adc_data=3850; adc_valid=1; @(posedge clk); adc_start=0; adc_valid=0; repeat(10) @(posedge clk);
        check(!fault_trip,"LCU healthy condition keeps fault low");
        check(soc_out>0,"LCU generates SOC");
        check(soh_out>0,"LCU generates SOH");
        iso_resistance=80; repeat(10) @(posedge clk);
        check(fault_trip,"LCU detects isolation fault");
        check(fault_code!=0,"LCU reports fault code");
        emi_in=1; repeat(10) @(posedge clk);
        check(fault_trip,"LCU keeps fault asserted on EMI event");
        $display("LCU TB SUMMARY PASS=%0d FAIL=%0d",pass_count,fail_count);
        #20; $finish;
    end
endmodule
