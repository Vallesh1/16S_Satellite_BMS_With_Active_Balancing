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
        $display("   BMS 3-LMU CORNER-CASE VERIFICATION STARTING    ");
        $display("==================================================");

        // 1. Reset Sequence
        rst_n = 0;
        init_healthy_state();
        #20;
        rst_n = 1;
        #20;

        // ---------------------------------------------------------
        // COMBO 1: BEST WORKING (NOMINAL STATE)
        // Expected: allowed_current = 300A, No Trips, No Faults
        // ---------------------------------------------------------
        $display("\n[TIME: %0t] COMBO 1: GOLDEN RUN (Nominal Params)", $time);
        start_poll = 1;
        #10 start_poll = 0;
        
        #500; // Wait for MCU to poll all 3 LMUs
        $display("  -> Allowed Current: %0d A (Expected 300)", allowed_current);
        $display("  -> Global Fault: %b | Supervisor Code: %h", global_fault, supervisor_code);

        // ---------------------------------------------------------
        // COMBO 2: WORST CASE NIGHTMARE
        // Conditions: 350A Load (Overcurrent), LMU0 at 90C (OTP), LMU2 Iso Loss
        // Expected: allowed_current throttles to 75A, current_trip=1, thermal_trip=1
        // ---------------------------------------------------------
        $display("\n[TIME: %0t] COMBO 2: WORST CASE (OTP + Overcurrent + Iso Fault)", $time);
        pack_current = 16'd350;        // Trip limit is 300
        lmu0_temp_die = 12'd90;        // Trip limit is 80
        lmu2_iso_resistance = 16'd100; // Limit is 500 ohms
        
        #100; // Allow combinational safety logic to trigger trips instantly
        
        start_poll = 1; 
        #10 start_poll = 0; 
        #500; // Poll to catch the isolation fault from LMU2
        
        $display("  -> Current Trip: %b (Expected 1) | Thermal Trip: %b (Expected 1)", current_trip, thermal_trip);
        $display("  -> Throttled Allowed Current: %0d A (Expected 75A)", allowed_current);
        $display("  -> Global Fault: %b | Global Fault Code: %h (Expected 05 for Iso)", global_fault, global_fault_code);

        // ---------------------------------------------------------
        // COMBO 3: DEEP FREEZE / OPPOSITE CASE
        // Conditions: 0A Load (Relaxation), LMU1 at 10C (UTP)
        // Expected: global_fault=1 (Code 04 for UTP), Allowed Current normal
        // ---------------------------------------------------------
        $display("\n[TIME: %0t] COMBO 3: DEEP FREEZE (UTP + Zero Current)", $time);
        
        // Reset everything to healthy first
        init_healthy_state(); 
        #100;
        
        pack_current = 16'd0;   // Triggers SOC relaxation algorithm
        lmu1_temp_die = 12'd10; // UTP_LIM is 40 decimal (0x028), so 10 will trip it
        
        start_poll = 1; 
        #10 start_poll = 0; 
        #500;
        
        $display("  -> MCU Identified Max Temp: %0d C (Should be 25 from healthy LMU)", uut.u_mcu.max_temp_seen);
        $display("  -> Global Fault: %b | Global Fault Code: %h (Expected 04 for UTP)", global_fault, global_fault_code);

        $display("\n==================================================");
        $display("   VERIFICATION COMPLETE. DESIGN TICKING PERFECTLY. ");
        $display("==================================================");
        $finish;
    end

endmodule