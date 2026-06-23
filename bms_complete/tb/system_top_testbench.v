`timescale 1ns / 1ps

module tb_bms_system_3lmu_top_enhanced();

    // ---------------------------------------------------------
    // Clock and Reset Signals
    // ---------------------------------------------------------
    reg clk;
    reg rst_n;
    reg start_poll;
    reg [15:0] pack_current;

    // ---------------------------------------------------------
    // LMU 0 Inputs
    // ---------------------------------------------------------
    reg         lmu0_adc_start;
    reg [15:0]  lmu0_adc_data;
    reg         lmu0_adc_valid;
    reg [15:0]  lmu0_pack_i;
    reg [15:0]  lmu0_pack_v_avg;
    reg [15:0]  lmu0_charge_cycles;
    reg [11:0]  lmu0_temp_die;
    reg [191:0] lmu0_cell_t_bus;
    reg [15:0]  lmu0_iso_resistance;
    reg         lmu0_emi_in;

    // ---------------------------------------------------------
    // LMU 1 Inputs
    // ---------------------------------------------------------
    reg         lmu1_adc_start;
    reg [15:0]  lmu1_adc_data;
    reg         lmu1_adc_valid;
    reg [15:0]  lmu1_pack_i;
    reg [15:0]  lmu1_pack_v_avg;
    reg [15:0]  lmu1_charge_cycles;
    reg [11:0]  lmu1_temp_die;
    reg [191:0] lmu1_cell_t_bus;
    reg [15:0]  lmu1_iso_resistance;
    reg         lmu1_emi_in;

    // ---------------------------------------------------------
    // LMU 2 Inputs
    // ---------------------------------------------------------
    reg         lmu2_adc_start;
    reg [15:0]  lmu2_adc_data;
    reg         lmu2_adc_valid;
    reg [15:0]  lmu2_pack_i;
    reg [15:0]  lmu2_pack_v_avg;
    reg [15:0]  lmu2_charge_cycles;
    reg [11:0]  lmu2_temp_die;
    reg [191:0] lmu2_cell_t_bus;
    reg [15:0]  lmu2_iso_resistance;
    reg         lmu2_emi_in;

    // ---------------------------------------------------------
    // SPI Master IO (External facing)
    // ---------------------------------------------------------
    reg         spi_miso;
    wire        spi_sclk;
    wire        spi_mosi;
    wire [2:0]  spi_cs_n;

    // ---------------------------------------------------------
    // System Outputs (MCU -> Vehicle Control Unit)
    // ---------------------------------------------------------
    wire [15:0] pack_soc_avg;
    wire [15:0] pack_soh_avg;
    wire        global_fault;
    wire [7:0]  global_fault_code;
    wire        current_warn;
    wire        current_trip;
    wire        thermal_warn;
    wire        thermal_trip;
    wire [15:0] allowed_current;
    wire [7:0]  supervisor_code;

    // ---------------------------------------------------------
    // DUT Instantiation
    // ---------------------------------------------------------
    bms_system_3lmu_top_enhanced uut (
        .clk(clk),
        .rst_n(rst_n),
        .start_poll(start_poll),
        .pack_current(pack_current),

        .lmu0_adc_start(lmu0_adc_start), .lmu0_adc_data(lmu0_adc_data), .lmu0_adc_valid(lmu0_adc_valid),
        .lmu0_pack_i(lmu0_pack_i), .lmu0_pack_v_avg(lmu0_pack_v_avg), .lmu0_charge_cycles(lmu0_charge_cycles),
        .lmu0_temp_die(lmu0_temp_die), .lmu0_cell_t_bus(lmu0_cell_t_bus), .lmu0_iso_resistance(lmu0_iso_resistance), .lmu0_emi_in(lmu0_emi_in),

        .lmu1_adc_start(lmu1_adc_start), .lmu1_adc_data(lmu1_adc_data), .lmu1_adc_valid(lmu1_adc_valid),
        .lmu1_pack_i(lmu1_pack_i), .lmu1_pack_v_avg(lmu1_pack_v_avg), .lmu1_charge_cycles(lmu1_charge_cycles),
        .lmu1_temp_die(lmu1_temp_die), .lmu1_cell_t_bus(lmu1_cell_t_bus), .lmu1_iso_resistance(lmu1_iso_resistance), .lmu1_emi_in(lmu1_emi_in),

        .lmu2_adc_start(lmu2_adc_start), .lmu2_adc_data(lmu2_adc_data), .lmu2_adc_valid(lmu2_adc_valid),
        .lmu2_pack_i(lmu2_pack_i), .lmu2_pack_v_avg(lmu2_pack_v_avg), .lmu2_charge_cycles(lmu2_charge_cycles),
        .lmu2_temp_die(lmu2_temp_die), .lmu2_cell_t_bus(lmu2_cell_t_bus), .lmu2_iso_resistance(lmu2_iso_resistance), .lmu2_emi_in(lmu2_emi_in),

        .spi_miso(spi_miso),
        .spi_sclk(spi_sclk),
        .spi_mosi(spi_mosi),
        .spi_cs_n(spi_cs_n),
        .pack_soc_avg(pack_soc_avg),
        .pack_soh_avg(pack_soh_avg),
        .global_fault(global_fault),
        .global_fault_code(global_fault_code),
        .current_warn(current_warn),
        .current_trip(current_trip),
        .thermal_warn(thermal_warn),
        .thermal_trip(thermal_trip),
        .allowed_current(allowed_current),
        .supervisor_code(supervisor_code)
    );

    // ---------------------------------------------------------
    // Clock Generation (100MHz)
    // ---------------------------------------------------------
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // ---------------------------------------------------------
    // Helper Task: Initialize all LMUs to healthy state
    // ---------------------------------------------------------
    task init_healthy_state;
        begin
            pack_current = 16'd50;  // 50A load
            start_poll = 0;
            spi_miso = 0;

            // LMU0 Defaults
            lmu0_adc_start = 0; lmu0_adc_data = 16'h0000; lmu0_adc_valid = 0;
            lmu0_pack_i = 16'd50; lmu0_pack_v_avg = 16'hA000; lmu0_charge_cycles = 16'd100;
            lmu0_temp_die = 12'd25; lmu0_cell_t_bus = 192'd0; lmu0_iso_resistance = 16'd1000; lmu0_emi_in = 0;

            // LMU1 Defaults
            lmu1_adc_start = 0; lmu1_adc_data = 16'h0000; lmu1_adc_valid = 0;
            lmu1_pack_i = 16'd50; lmu1_pack_v_avg = 16'hA000; lmu1_charge_cycles = 16'd105;
            lmu1_temp_die = 12'd26; lmu1_cell_t_bus = 192'd0; lmu1_iso_resistance = 16'd1000; lmu1_emi_in = 0;

            // LMU2 Defaults
            lmu2_adc_start = 0; lmu2_adc_data = 16'h0000; lmu2_adc_valid = 0;
            lmu2_pack_i = 16'd50; lmu2_pack_v_avg = 16'hA000; lmu2_charge_cycles = 16'd110;
            lmu2_temp_die = 12'd24; lmu2_cell_t_bus = 192'd0; lmu2_iso_resistance = 16'd1000; lmu2_emi_in = 0;
        end
    endtask

    // ---------------------------------------------------------
    // Main Test Sequence
    // ---------------------------------------------------------
    initial begin
        // Setup VCD dump for waveform analysis
        $dumpfile("tb_bms_system_3lmu_top_enhanced.vcd");
        $dumpvars(0, tb_bms_system_3lmu_top_enhanced);

        $display("==================================================");
        $display("   BMS 3-LMU TOP LEVEL VERIFICATION STARTING      ");
        $display("==================================================");

        // 1. Reset Sequence
        rst_n = 0;
        init_healthy_state();
        #20;
        rst_n = 1;
        #20;

        // ---------------------------------------------------------
        // SCENARIO 1: Normal Operation
        // ---------------------------------------------------------
        $display("[TIME: %0t] SCENARIO 1: Normal State Polling", $time);
        start_poll = 1;
        #10 start_poll = 0;
        
        // Wait for FSM to complete polling
        #500; 
        $display("  -> Allowed Current: %0d A (Expected 300)", allowed_current);
        $display("  -> Thermal Trip: %b, Current Trip: %b", thermal_trip, current_trip);
        $display("  -> Global Fault Code: %h", global_fault_code);

        // ---------------------------------------------------------
        // SCENARIO 2: Thermal Runaway on LMU1
        // ---------------------------------------------------------
        $display("\n[TIME: %0t] SCENARIO 2: Thermal Trip on LMU1 (85C)", $time);
        lmu1_temp_die = 12'd85; // MCU_MAX_TEMP is 80
        start_poll = 1;
        #10 start_poll = 0;
        
        #500;
        $display("  -> MCU Identified Max Temp: %0d C", uut.u_mcu.max_temp_seen);
        $display("  -> Thermal Trip Status: %b (Expected 1)", thermal_trip);
        $display("  -> Throttled Allowed Current: %0d A (Expected 75A -> 300>>2)", allowed_current);
        $display("  -> Supervisor Code: %h (Expected E4)", supervisor_code);

        // Reset thermal state
        lmu1_temp_die = 12'd26; 
        start_poll = 1; #10 start_poll = 0; #500;

        // ---------------------------------------------------------
        // SCENARIO 3: Overcurrent Runaway
        // ---------------------------------------------------------
        $display("\n[TIME: %0t] SCENARIO 3: Hard Acceleration Overcurrent", $time);
        pack_current = 16'd320; // MCU_MAX_PACK_CURRENT is 300
        
        #50; // purely combinational safety logic, no poll needed
        $display("  -> Current Trip Status: %b (Expected 1)", current_trip);
        $display("  -> Supervisor Code: %h (Expected E3)", supervisor_code);
        
        // Reset current state
        pack_current = 16'd50; 
        #50;

        // ---------------------------------------------------------
        // SCENARIO 4: Isolation Fault on LMU2
        // ---------------------------------------------------------
        $display("\n[TIME: %0t] SCENARIO 4: Isolation Loss on LMU2", $time);
        lmu2_iso_resistance = 16'd200; // ISO_LIM is 500
        
        // Allow LMU logic to register fault
        #100;
        
        start_poll = 1;
        #10 start_poll = 0;
        
        #500;
        $display("  -> Global Fault Status: %b (Expected 1)", global_fault);
        $display("  -> Global Fault Code: %h (Expected 05 - ISO Fault)", global_fault_code);

        $display("\n==================================================");
        $display("   VERIFICATION COMPLETE. DUMPING VCD.            ");
        $display("==================================================");
        $finish;
    end

endmodule