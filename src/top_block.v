// =========================================================
// TOP MODULE: 16s SATELLITE BMS (ACTIVE TRANSFER EDITION)
// =========================================================
module bms_satellite_top (
    input  wire                   clk,        
    input  wire                   rst_n,      
    
    // Analog Front-End Interface
    input  wire [15:0]            cell_v [0:15], 
    input  wire [15:0]            pack_i,
    input  wire [11:0]            temp_die,

    // Communication Interface
    input  wire                   iso_rx,     
    output wire                   iso_tx,     

    // Hardware Outputs (UPDATED FOR ACTIVE BALANCING)
    output wire [15:0]            active_tx_sw, // Connects high cell to transfer bus
    output wire [15:0]            active_rx_sw, // Connects low cell to transfer bus
    output wire [15:0]            passive_sw,   // Connects cells to heat dissipation resistors
    output wire                   fault_trip  
);

    // Internal Global Wires
    wire [15:0] current_soc;
    wire [3:0]  fault_code;
    wire        clk_gated;
    wire        comm_active;
    wire        comm_active = ~iso_rx;

    // Instantiate Block 1: Safety Guard
    bms_fault_processor u_dfp (
        .clk        (clk_gated),
        .rst_n      (rst_n),
        .cell_v     (cell_v),
        .temp       (temp_die),
        .fault_out  (fault_trip),
        .status_o   (fault_code)
    );

    // Instantiate Block 2: Math Engine
    bms_soc_engine u_hae_soc (
        .clk        (clk_gated),
        .rst_n      (rst_n),
        .pack_i     (pack_i),
        .soc_out    (current_soc)
    );

    // Instantiate Block 3: TRUE Active Balancer
    bms_active_balancer u_abal (
        .clk          (clk_gated),
        .rst_n        (rst_n),
        .cell_v       (cell_v),
        .active_tx_sw (active_tx_sw),
        .active_rx_sw (active_rx_sw),
        .passive_sw   (passive_sw)
    );

    // Instantiate Block 4: Power Strategist
    bms_power_mgmt u_pmgmt (
        .clk             (clk),
        .rst_n           (rst_n),
        .fault_condition (fault_trip),
        .comm_active     (comm_active),
        .logic_clk_en    (clk_gated)
    );

    // Instantiate Block 5: Radio Unit
    bms_comm_unit u_dcomm (
        .clk        (clk),
        .rst_n      (rst_n),
        .tx_byte    (current_soc[15:8]), 
        .tx_en      (1'b1),               
        .tx_wire    (iso_tx)
    );

endmodule
