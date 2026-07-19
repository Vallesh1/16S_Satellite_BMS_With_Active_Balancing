/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : T-2022.03-SP4
// Date      : Sat Jul 18 22:04:39 2026
/////////////////////////////////////////////////////////////



    module bms_master_control_unit_enhanced_SNPS_CLOCK_GATE_HIGH_bms_spi_master_0 ( 
        CLK, EN, ENCLK, TE );
  input CLK, EN, TE;
  output ENCLK;


  SAEDRVT14_CKGTPLT_V5_1 latch ( .CK(CLK), .EN(EN), .SE(TE), .Q(ENCLK) );
endmodule



    module bms_master_control_unit_enhanced_SNPS_CLOCK_GATE_HIGH_bms_spi_master_3 ( 
        CLK, EN, ENCLK, TE );
  input CLK, EN, TE;
  output ENCLK;


  SAEDRVT14_CKGTPLT_V5_1 latch ( .CK(CLK), .EN(EN), .SE(TE), .Q(ENCLK) );
endmodule



    module bms_master_control_unit_enhanced_SNPS_CLOCK_GATE_HIGH_bms_spi_master_2 ( 
        CLK, EN, ENCLK, TE );
  input CLK, EN, TE;
  output ENCLK;


  SAEDRVT14_CKGTPLT_V5_1 latch ( .CK(CLK), .EN(EN), .SE(TE), .Q(ENCLK) );
endmodule



    module bms_master_control_unit_enhanced_SNPS_CLOCK_GATE_HIGH_bms_spi_master_1 ( 
        CLK, EN, ENCLK, TE );
  input CLK, EN, TE;
  output ENCLK;


  SAEDRVT14_CKGTPLT_V5_1 latch ( .CK(CLK), .EN(EN), .SE(TE), .Q(ENCLK) );
endmodule


module bms_master_control_unit_enhanced_bms_spi_master_DW01_inc_J1_0_0 ( A, 
        SUM );
  input [7:0] A;
  output [7:0] SUM;
  wire   n27, n28, n29, n30, n31, n32;

  SAEDRVT14_ADDH_0P5 U11 ( .A(n27), .B(A[2]), .CO(n28), .S(SUM[2]) );
  SAEDRVT14_ADDH_0P5 U12 ( .A(A[0]), .B(A[1]), .CO(n27), .S(SUM[1]) );
  SAEDRVT14_ADDH_0P5 U13 ( .A(n28), .B(A[3]), .CO(n29), .S(SUM[3]) );
  SAEDRVT14_ADDH_0P5 U14 ( .A(n29), .B(A[4]), .CO(n30), .S(SUM[4]) );
  SAEDRVT14_ADDH_0P5 U15 ( .A(n30), .B(A[5]), .CO(n31), .S(SUM[5]) );
  SAEDRVT14_ADDH_0P5 U16 ( .A(n31), .B(A[6]), .CO(n32), .S(SUM[6]) );
  SAEDRVT14_EO2_V1_0P75 U17 ( .A1(n32), .A2(A[7]), .X(SUM[7]) );
endmodule


module bms_master_control_unit_enhanced_bms_spi_master_0 ( clk, rst_n, start, 
        slave_sel, tx_byte, miso, busy, done, rx_byte, sclk, mosi, cs_n );
  input [1:0] slave_sel;
  input [7:0] tx_byte;
  output [7:0] rx_byte;
  output [2:0] cs_n;
  input clk, rst_n, start, miso;
  output busy, done, sclk, mosi;
  wire   n72, n73, n74, N52, N53, N54, N55, N56, N57, N58, N84, N85, N86, N87,
         N88, N89, N90, N91, N93, N95, N97, N99, N104, N105, N106, N107, N108,
         N109, N110, N120, N130, N142, N146, N147, N149, N151, N152, N153,
         N167, net921, net927, net932, net937, n22, n28, n30, n1, n3, n5, n7,
         n8, n9, n10, n11, n12, n13, n14, n15, n16, n17, n18, n19, n20, n21,
         n23, n24, n25, n26, n27, n29, n31, n32, n33, n34, n35, n36, n37, n38,
         n39, n40, n41, n42, n43, n44, n45, n46, n47, n48, n49, n50, n51, n52,
         n53, n54, n55, n56, n57, n58, n59, n60, n61, n62, n63, n64, n65, n66,
         n67, n68, n69, n70, n71, SYNOPSYS_UNCONNECTED_1;
  wire   [1:0] state;
  wire   [3:0] bit_cnt;
  wire   [6:0] tx_shift;
  wire   [7:0] clk_cnt;

  bms_master_control_unit_enhanced_SNPS_CLOCK_GATE_HIGH_bms_spi_master_0 clk_gate_tx_shift_reg ( 
        .CLK(clk), .EN(N130), .ENCLK(net921), .TE(n71) );
  bms_master_control_unit_enhanced_SNPS_CLOCK_GATE_HIGH_bms_spi_master_3 clk_gate_clk_cnt_reg ( 
        .CLK(clk), .EN(n37), .ENCLK(net927), .TE(n71) );
  bms_master_control_unit_enhanced_SNPS_CLOCK_GATE_HIGH_bms_spi_master_2 clk_gate_bit_cnt_reg ( 
        .CLK(clk), .EN(N142), .ENCLK(net932), .TE(n71) );
  bms_master_control_unit_enhanced_SNPS_CLOCK_GATE_HIGH_bms_spi_master_1 clk_gate_cs_n_reg ( 
        .CLK(clk), .EN(n49), .ENCLK(net937), .TE(n71) );
  SAEDRVT14_BUF_PS_1P5 B_3 ( .A(sclk) );
  bms_master_control_unit_enhanced_bms_spi_master_DW01_inc_J1_0_0 add_x_2 ( 
        .A(clk_cnt), .SUM({N58, N57, N56, N55, N54, N53, N52, 
        SYNOPSYS_UNCONNECTED_1}) );
  SAEDRVT14_MUX2_U_0P5 U4 ( .D0(sclk), .D1(N146), .S(N147), .X(n28) );
  SAEDRVT14_FSDPRBQ_V2LP_2 sclk_reg ( .D(n28), .SI(n71), .SE(n71), .CK(clk), 
        .RD(n40), .Q(sclk) );
  SAEDRVT14_INV_0P5 I_4 ( .A(sclk), .X(N167) );
  SAEDRVT14_FSDPRBQ_V2LP_2 state_reg_1_ ( .D(n22), .SI(n71), .SE(n71), .CK(clk), .RD(n24), .Q(state[1]) );
  SAEDRVT14_FSDPRBQ_V2LP_2 mosi_reg ( .D(N120), .SI(n71), .SE(n71), .CK(net921), .RD(n40), .Q(mosi) );
  SAEDRVT14_FSDPRBQ_V2LP_2 clk_cnt_reg_0_ ( .D(N84), .SI(n71), .SE(n71), .CK(
        net927), .RD(n41), .Q(clk_cnt[0]) );
  SAEDRVT14_FSDPRBQ_V2LP_2 bit_cnt_reg_1_ ( .D(N95), .SI(n71), .SE(n71), .CK(
        net932), .RD(n24), .Q(bit_cnt[1]) );
  SAEDRVT14_FSDPRBQ_V2LP_2 clk_cnt_reg_6_ ( .D(N90), .SI(n71), .SE(n71), .CK(
        net927), .RD(n10), .Q(clk_cnt[6]) );
  SAEDRVT14_FSDPRBQ_V2LP_2 done_reg ( .D(state[1]), .SI(n71), .SE(n71), .CK(
        net937), .RD(n8), .Q(done) );
  SAEDRVT14_FSDPRBQ_V2LP_2 bit_cnt_reg_3_ ( .D(N99), .SI(n71), .SE(n71), .CK(
        net932), .RD(n25), .Q(bit_cnt[3]) );
  SAEDRVT14_FSDPRBQ_V2LP_2 tx_shift_reg_2_ ( .D(N106), .SI(n71), .SE(n71), 
        .CK(net921), .RD(n8), .Q(tx_shift[2]) );
  SAEDRVT14_FSDPRBQ_V2LP_2 clk_cnt_reg_5_ ( .D(N89), .SI(n71), .SE(n71), .CK(
        net927), .RD(n39), .Q(clk_cnt[5]) );
  SAEDRVT14_FSDPSBQ_V2LP_1 cs_n_reg_2_ ( .D(N153), .SI(n71), .SE(n71), .CK(
        net937), .SD(n10), .Q(n72) );
  SAEDRVT14_FSDPSBQ_V2LP_1 cs_n_reg_0_ ( .D(N149), .SI(n71), .SE(n71), .CK(
        net937), .SD(n13), .Q(n74) );
  SAEDRVT14_FSDPSBQ_V2LP_1 cs_n_reg_1_ ( .D(N151), .SI(n71), .SE(n71), .CK(
        net937), .SD(n26), .Q(n73) );
  SAEDRVT14_FSDPRBQ_V2LP_2 state_reg_0_ ( .D(n30), .SI(n71), .SE(n71), .CK(clk), .RD(n17), .Q(state[0]) );
  SAEDRVT14_FSDPRBQ_V2LP_2 bit_cnt_reg_0_ ( .D(N93), .SI(n71), .SE(n71), .CK(
        net932), .RD(n12), .Q(bit_cnt[0]) );
  SAEDRVT14_FSDPRBQ_V2LP_2 bit_cnt_reg_2_ ( .D(N97), .SI(n71), .SE(n71), .CK(
        net932), .RD(n27), .Q(bit_cnt[2]) );
  SAEDRVT14_FSDPRBQ_V2LP_2 clk_cnt_reg_1_ ( .D(N85), .SI(n71), .SE(n71), .CK(
        net927), .RD(n9), .Q(clk_cnt[1]) );
  SAEDRVT14_FSDPRBQ_V2LP_2 clk_cnt_reg_2_ ( .D(N86), .SI(n71), .SE(n71), .CK(
        net927), .RD(n39), .Q(clk_cnt[2]) );
  SAEDRVT14_FSDPRBQ_V2LP_2 clk_cnt_reg_3_ ( .D(N87), .SI(n71), .SE(n71), .CK(
        net927), .RD(n14), .Q(clk_cnt[3]) );
  SAEDRVT14_FSDPRBQ_V2LP_2 clk_cnt_reg_4_ ( .D(N88), .SI(n71), .SE(n71), .CK(
        net927), .RD(n9), .Q(clk_cnt[4]) );
  SAEDRVT14_FSDPRBQ_V2LP_2 clk_cnt_reg_7_ ( .D(N91), .SI(n71), .SE(n71), .CK(
        net927), .RD(n41), .Q(clk_cnt[7]) );
  SAEDRVT14_FSDPRBQ_V2LP_2 tx_shift_reg_0_ ( .D(N104), .SI(n71), .SE(n71), 
        .CK(net921), .RD(n26), .Q(tx_shift[0]) );
  SAEDRVT14_FSDPRBQ_V2LP_2 tx_shift_reg_1_ ( .D(N105), .SI(n71), .SE(n71), 
        .CK(net921), .RD(n25), .Q(tx_shift[1]) );
  SAEDRVT14_FSDPRBQ_V2LP_2 tx_shift_reg_3_ ( .D(N107), .SI(n71), .SE(n71), 
        .CK(net921), .RD(n13), .Q(tx_shift[3]) );
  SAEDRVT14_FSDPRBQ_V2LP_2 tx_shift_reg_4_ ( .D(N108), .SI(n71), .SE(n71), 
        .CK(net921), .RD(n15), .Q(tx_shift[4]) );
  SAEDRVT14_FSDPRBQ_V2LP_2 tx_shift_reg_6_ ( .D(N110), .SI(n71), .SE(n71), 
        .CK(net921), .RD(n12), .Q(tx_shift[6]) );
  SAEDRVT14_FSDPRBQ_V2LP_2 tx_shift_reg_5_ ( .D(N109), .SI(n71), .SE(n71), 
        .CK(net921), .RD(n15), .Q(tx_shift[5]) );
  SAEDLVT14_TIE0_V1_2 U3 ( .X(n71) );
  SAEDRVT14_INV_0P5 U5 ( .A(n73), .X(n1) );
  SAEDRVT14_INV_0P5 U6 ( .A(n1), .X(cs_n[1]) );
  SAEDRVT14_INV_0P5 U7 ( .A(n74), .X(n3) );
  SAEDRVT14_INV_0P5 U8 ( .A(n3), .X(cs_n[0]) );
  SAEDRVT14_INV_0P5 U9 ( .A(n72), .X(n5) );
  SAEDRVT14_INV_0P5 U10 ( .A(n5), .X(cs_n[2]) );
  SAEDRVT14_AN2_0P5 U11 ( .A1(start), .A2(n36), .X(n47) );
  SAEDRVT14_INV_0P5 U12 ( .A(n47), .X(n7) );
  SAEDLVT14_NR2_MM_0P5 U13 ( .A1(tx_byte[0]), .A2(n7), .X(n67) );
  SAEDRVT14_INV_0P5 U14 ( .A(n16), .X(n8) );
  SAEDRVT14_INV_0P5 U15 ( .A(n16), .X(n9) );
  SAEDRVT14_INV_0P5 U16 ( .A(n16), .X(n10) );
  SAEDRVT14_INV_0P5 U17 ( .A(n17), .X(n11) );
  SAEDRVT14_INV_0P5 U18 ( .A(n11), .X(n12) );
  SAEDRVT14_INV_0P5 U19 ( .A(n11), .X(n13) );
  SAEDRVT14_INV_0P5 U20 ( .A(n11), .X(n14) );
  SAEDRVT14_INV_0P5 U21 ( .A(n11), .X(n15) );
  SAEDRVT14_CLKSPLT_1 U22 ( .CK(rst_n), .CKOUTB(n16), .CKOUT(n17) );
  SAEDRVT14_INV_0P5 U23 ( .A(n42), .X(n18) );
  SAEDRVT14_INV_0P5 U24 ( .A(n18), .X(n19) );
  SAEDRVT14_INV_0P5 U25 ( .A(n18), .X(n20) );
  SAEDRVT14_INV_0P5 U26 ( .A(n18), .X(n21) );
  SAEDRVT14_INV_0P5 U27 ( .A(n27), .X(n23) );
  SAEDRVT14_INV_0P5 U28 ( .A(n23), .X(n24) );
  SAEDRVT14_INV_0P5 U29 ( .A(n23), .X(n25) );
  SAEDRVT14_INV_0P5 U30 ( .A(n38), .X(n26) );
  SAEDRVT14_INV_0P5 U31 ( .A(n38), .X(n27) );
  SAEDRVT14_INV_0P5 U32 ( .A(n65), .X(n29) );
  SAEDRVT14_INV_0P5 U33 ( .A(n29), .X(n31) );
  SAEDRVT14_INV_0P5 U34 ( .A(n29), .X(n32) );
  SAEDRVT14_INV_0P5 U35 ( .A(n29), .X(n33) );
  SAEDRVT14_INV_0P5 U36 ( .A(n50), .X(n34) );
  SAEDRVT14_INV_0P5 U37 ( .A(n34), .X(n35) );
  SAEDRVT14_INV_0P5 U38 ( .A(n34), .X(n36) );
  SAEDRVT14_INV_0P5 U39 ( .A(n34), .X(n37) );
  SAEDRVT14_INV_0P5 U40 ( .A(n14), .X(n38) );
  SAEDRVT14_INV_0P5 U41 ( .A(n38), .X(n39) );
  SAEDRVT14_INV_0P5 U42 ( .A(n38), .X(n40) );
  SAEDRVT14_INV_0P5 U43 ( .A(n38), .X(n41) );
  SAEDRVT14_INV_0P5 U44 ( .A(state[0]), .X(n42) );
  SAEDRVT14_INV_0P5 U45 ( .A(n42), .X(n43) );
  SAEDRVT14_INV_0P5 U46 ( .A(n42), .X(n44) );
  SAEDRVT14_INV_0P5 U47 ( .A(n42), .X(n45) );
  SAEDRVT14_INV_0P5 U48 ( .A(n42), .X(n46) );
  SAEDRVT14_ND2_ECO_1 U49 ( .A1(N146), .A2(n69), .X(n70) );
  SAEDRVT14_NR4_0P75 U50 ( .A1(clk_cnt[3]), .A2(clk_cnt[4]), .A3(n54), .A4(n53), .X(n68) );
  SAEDRVT14_INV_0P5 U51 ( .A(n68), .X(n48) );
  SAEDRVT14_AN2_0P5 U52 ( .A1(n43), .A2(n35), .X(N152) );
  SAEDRVT14_INV_0P5 U53 ( .A(N152), .X(n49) );
  SAEDRVT14_AN2_0P5 U54 ( .A1(n43), .A2(tx_shift[1]), .X(N106) );
  SAEDRVT14_AN2_0P5 U55 ( .A1(n46), .A2(tx_shift[5]), .X(N110) );
  SAEDLVT14_NR2_MM_0P5 U56 ( .A1(bit_cnt[3]), .A2(n61), .X(n60) );
  SAEDRVT14_NR2_1 U57 ( .A1(n56), .A2(n49), .X(N146) );
  SAEDRVT14_AN2_0P5 U58 ( .A1(bit_cnt[0]), .A2(bit_cnt[1]), .X(n63) );
  SAEDLVT14_NR2_MM_0P5 U59 ( .A1(clk_cnt[0]), .A2(n21), .X(N84) );
  SAEDRVT14_INV_0P5 U60 ( .A(state[1]), .X(n50) );
  SAEDRVT14_ND2_CDC_1 U61 ( .A1(n37), .A2(n57), .X(n59) );
  SAEDRVT14_AN2_0P5 U62 ( .A1(n31), .A2(N52), .X(N85) );
  SAEDRVT14_AN2_0P5 U63 ( .A1(n31), .A2(N53), .X(N86) );
  SAEDRVT14_AN2_0P5 U64 ( .A1(n31), .A2(N54), .X(N87) );
  SAEDRVT14_AN2_0P5 U65 ( .A1(n33), .A2(N55), .X(N88) );
  SAEDRVT14_AN2_0P5 U66 ( .A1(n33), .A2(N56), .X(N89) );
  SAEDRVT14_AN2_0P5 U67 ( .A1(n32), .A2(N57), .X(N90) );
  SAEDRVT14_AN2_0P5 U68 ( .A1(n48), .A2(n45), .X(n65) );
  SAEDRVT14_OAI21_0P5 U69 ( .A1(bit_cnt[0]), .A2(bit_cnt[1]), .B(n46), .X(n51)
         );
  SAEDRVT14_NR2_1 U70 ( .A1(n63), .A2(n51), .X(N95) );
  SAEDRVT14_NR2_1 U71 ( .A1(bit_cnt[0]), .A2(n20), .X(N93) );
  SAEDRVT14_ND2_CDC_1 U72 ( .A1(n63), .A2(bit_cnt[2]), .X(n61) );
  SAEDRVT14_INV_0P5 U73 ( .A(n60), .X(n55) );
  SAEDRVT14_ND2_CDC_1 U74 ( .A1(clk_cnt[2]), .A2(clk_cnt[0]), .X(n54) );
  SAEDRVT14_INV_0P5 U75 ( .A(clk_cnt[1]), .X(n52) );
  SAEDRVT14_OR4_1 U76 ( .A1(clk_cnt[5]), .A2(n52), .A3(clk_cnt[7]), .A4(
        clk_cnt[6]), .X(n53) );
  SAEDRVT14_INV_0P5 U77 ( .A(N167), .X(n56) );
  SAEDRVT14_OR3_0P5 U78 ( .A1(n48), .A2(n56), .A3(n55), .X(n57) );
  SAEDRVT14_NR2_1 U79 ( .A1(n57), .A2(n49), .X(n22) );
  SAEDRVT14_INV_0P5 U80 ( .A(tx_byte[0]), .X(n66) );
  SAEDRVT14_NR2_1 U81 ( .A1(n45), .A2(n66), .X(N104) );
  SAEDRVT14_ND2_CDC_1 U82 ( .A1(n19), .A2(start), .X(n58) );
  SAEDRVT14_OAI22_0P5 U83 ( .A1(n21), .A2(n59), .B1(state[1]), .B2(n58), .X(
        n30) );
  SAEDRVT14_AO32_U_0P5 U84 ( .A1(n43), .A2(bit_cnt[3]), .A3(n61), .B1(n45), 
        .B2(n60), .X(N99) );
  SAEDRVT14_NR2_1 U85 ( .A1(n60), .A2(n48), .X(n69) );
  SAEDRVT14_AO32_U_0P5 U86 ( .A1(n35), .A2(N167), .A3(n69), .B1(n36), .B2(n19), 
        .X(N142) );
  SAEDRVT14_AN2_MM_1 U87 ( .A1(n44), .A2(tx_shift[2]), .X(N107) );
  SAEDRVT14_ND2_CDC_1 U88 ( .A1(n46), .A2(n61), .X(n62) );
  SAEDRVT14_OA21B_1 U89 ( .A1(n63), .A2(bit_cnt[2]), .B(n62), .X(N97) );
  SAEDRVT14_ND2_CDC_1 U90 ( .A1(tx_byte[7]), .A2(n20), .X(n64) );
  SAEDRVT14_AO21B_0P5 U91 ( .A1(n43), .A2(tx_shift[6]), .B(n64), .X(N120) );
  SAEDRVT14_MUX2_U_0P5 U92 ( .D0(tx_byte[1]), .D1(tx_shift[0]), .S(n44), .X(
        N105) );
  SAEDRVT14_AO21B_0P5 U93 ( .A1(n45), .A2(tx_shift[3]), .B(n64), .X(N108) );
  SAEDRVT14_AO21B_0P5 U94 ( .A1(n44), .A2(tx_shift[4]), .B(n64), .X(N109) );
  SAEDRVT14_AN2_MM_1 U95 ( .A1(n32), .A2(N58), .X(N91) );
  SAEDRVT14_OR3_0P5 U96 ( .A1(tx_byte[0]), .A2(tx_byte[1]), .A3(n7), .X(N149)
         );
  SAEDRVT14_OR3_0P5 U97 ( .A1(tx_byte[1]), .A2(n66), .A3(n7), .X(N151) );
  SAEDRVT14_ND2_CDC_1 U98 ( .A1(n67), .A2(tx_byte[1]), .X(N153) );
  SAEDRVT14_ND2B_U_0P5 U99 ( .A(n49), .B(n48), .X(N147) );
  SAEDRVT14_OAI21_0P5 U100 ( .A1(n46), .A2(n7), .B(n70), .X(N130) );
endmodule


module bms_master_control_unit_enhanced_bms_current_limit_supervisor_0 ( clk, 
        rst_n, pack_current, max_temp_seen, active_lmu_count, global_fault_in, 
        current_warn, current_trip, thermal_warn, thermal_trip, 
        lmu_count_fault, allowed_current, supervisor_code );
  input [15:0] pack_current;
  input [11:0] max_temp_seen;
  input [3:0] active_lmu_count;
  output [15:0] allowed_current;
  output [7:0] supervisor_code;
  input clk, rst_n, global_fault_in;
  output current_warn, current_trip, thermal_warn, thermal_trip,
         lmu_count_fault;
  wire   allowed_current_5_, n36, n37, thermal_warn, thermal_trip, N3, N4, N19,
         N20, N32, N33, N34, N36, N37, n19, n32, n34, n7, n9, n11, n13, n14,
         n15, n16, n17, n18, n20, n21, n22, n23, n24, n25, n26, n27, n28, n29,
         n30, n31, n33, n35;
  assign allowed_current[4] = allowed_current[7];
  assign allowed_current[5] = allowed_current[8];
  assign allowed_current[1] = thermal_warn;
  assign allowed_current[6] = thermal_trip;
  assign allowed_current[0] = thermal_trip;
  assign supervisor_code[5] = supervisor_code[7];

  SAEDRVT14_FSDPSBQ_V2LP_1 allowed_current_reg_5_ ( .D(N20), .SI(n19), .SE(n19), .CK(clk), .SD(n16), .Q(allowed_current_5_) );
  SAEDRVT14_FSDPRBQ_V2LP_2 supervisor_code_reg_5_ ( .D(N37), .SI(n19), .SE(n19), .CK(clk), .RD(n15), .Q(supervisor_code[7]) );
  SAEDRVT14_FSDPRBQ_V2LP_2 allowed_current_reg_1_ ( .D(n17), .SI(n19), .SE(n19), .CK(clk), .RD(rst_n), .Q(thermal_warn) );
  SAEDRVT14_FSDPRBQ_V2LP_2 allowed_current_reg_4_ ( .D(N19), .SI(n19), .SE(n19), .CK(clk), .RD(n16), .Q(allowed_current[7]) );
  SAEDRVT14_FSDPSBQ_V2LP_1 allowed_current_reg_3_ ( .D(n34), .SI(n19), .SE(n19), .CK(clk), .SD(n16), .Q(n36) );
  SAEDRVT14_FSDPRBQ_V2LP_2 allowed_current_reg_0_ ( .D(n32), .SI(n19), .SE(n19), .CK(clk), .RD(n15), .Q(thermal_trip) );
  SAEDRVT14_FSDPRBQ_V2LP_2 current_trip_reg ( .D(N4), .SI(n19), .SE(n19), .CK(
        clk), .RD(n16), .Q(current_trip) );
  SAEDRVT14_FSDPRBQ_V2LP_2 current_warn_reg ( .D(N3), .SI(n19), .SE(n19), .CK(
        clk), .RD(n14), .Q(current_warn) );
  SAEDRVT14_FSDPRBQ_V2LP_2 supervisor_code_reg_0_ ( .D(n20), .SI(n19), .SE(n19), .CK(clk), .RD(n15), .Q(supervisor_code[0]) );
  SAEDRVT14_FSDPRBQ_V2LP_2 supervisor_code_reg_1_ ( .D(N33), .SI(n19), .SE(n19), .CK(clk), .RD(n15), .Q(supervisor_code[1]) );
  SAEDRVT14_FSDPRBQ_V2LP_2 supervisor_code_reg_2_ ( .D(N34), .SI(n19), .SE(n19), .CK(clk), .RD(n14), .Q(supervisor_code[2]) );
  SAEDRVT14_FSDPRBQ_V2LP_2 supervisor_code_reg_6_ ( .D(N36), .SI(n19), .SE(n19), .CK(clk), .RD(n14), .Q(supervisor_code[6]) );
  SAEDRVT14_FSDPSBQ_V2LP_1 allowed_current_reg_2_ ( .D(n18), .SI(n19), .SE(n19), .CK(clk), .SD(n14), .Q(n37) );
  SAEDRVT14_NR2B_2 U3 ( .A(N4), .B(global_fault_in), .X(N33) );
  SAEDRVT14_ND2_CDC_1 U4 ( .A1(n18), .A2(n35), .X(N36) );
  SAEDRVT14_ND2_CDC_1 U5 ( .A1(n18), .A2(n17), .X(n34) );
  SAEDLVT14_TIE0_V1_2 U6 ( .X(n19) );
  SAEDRVT14_INV_0P5 U7 ( .A(allowed_current_5_), .X(n7) );
  SAEDRVT14_INV_0P5 U8 ( .A(n7), .X(allowed_current[8]) );
  SAEDRVT14_INV_0P5 U9 ( .A(n36), .X(n9) );
  SAEDRVT14_INV_0P5 U10 ( .A(n9), .X(allowed_current[3]) );
  SAEDRVT14_INV_0P5 U11 ( .A(n37), .X(n11) );
  SAEDRVT14_INV_0P5 U12 ( .A(n11), .X(allowed_current[2]) );
  SAEDRVT14_OR2_MM_1P5 U13 ( .A1(max_temp_seen[7]), .A2(n23), .X(n32) );
  SAEDRVT14_INV_0P5 U14 ( .A(n16), .X(n13) );
  SAEDRVT14_INV_0P5 U15 ( .A(n13), .X(n14) );
  SAEDRVT14_INV_0P5 U16 ( .A(n13), .X(n15) );
  SAEDRVT14_CLKSPLT_1 U17 ( .CK(rst_n), .CKOUT(n16) );
  SAEDRVT14_OR3_0P5 U18 ( .A1(pack_current[13]), .A2(pack_current[14]), .A3(
        n21), .X(n30) );
  SAEDRVT14_AN4_0P75 U19 ( .A1(pack_current[7]), .A2(pack_current[6]), .A3(
        pack_current[5]), .A4(pack_current[4]), .X(n31) );
  SAEDRVT14_ND2_MM_0P5 U20 ( .A1(n29), .A2(n28), .X(N4) );
  SAEDRVT14_INV_0P5 U21 ( .A(N20), .X(n17) );
  SAEDRVT14_INV_0P5 U22 ( .A(n32), .X(n18) );
  SAEDRVT14_AN2_0P5 U23 ( .A1(n35), .A2(n33), .X(N32) );
  SAEDRVT14_INV_0P5 U24 ( .A(N32), .X(n20) );
  SAEDRVT14_ND2_CDC_1 U25 ( .A1(pack_current[8]), .A2(n27), .X(n28) );
  SAEDRVT14_NR4_0P75 U26 ( .A1(pack_current[11]), .A2(pack_current[15]), .A3(
        pack_current[10]), .A4(pack_current[12]), .X(n25) );
  SAEDRVT14_INV_0P5 U27 ( .A(n25), .X(n21) );
  SAEDRVT14_AN2_0P5 U28 ( .A1(n32), .A2(n35), .X(N34) );
  SAEDLVT14_NR2_MM_0P5 U29 ( .A1(global_fault_in), .A2(N4), .X(n35) );
  SAEDRVT14_OR4_1 U30 ( .A1(max_temp_seen[9]), .A2(max_temp_seen[11]), .A3(
        max_temp_seen[10]), .A4(max_temp_seen[8]), .X(n22) );
  SAEDRVT14_AO221_0P5 U31 ( .A1(max_temp_seen[6]), .A2(max_temp_seen[5]), .B1(
        max_temp_seen[6]), .B2(max_temp_seen[4]), .C(n22), .X(n23) );
  SAEDRVT14_OR4_1 U32 ( .A1(max_temp_seen[0]), .A2(max_temp_seen[3]), .A3(
        max_temp_seen[2]), .A4(max_temp_seen[1]), .X(n24) );
  SAEDRVT14_AOI21_0P5 U33 ( .A1(max_temp_seen[6]), .A2(n24), .B(n32), .X(N20)
         );
  SAEDRVT14_INV_0P5 U34 ( .A(n34), .X(N19) );
  SAEDRVT14_NR2_1 U35 ( .A1(pack_current[9]), .A2(n30), .X(n29) );
  SAEDRVT14_AO32_U_0P5 U36 ( .A1(pack_current[5]), .A2(pack_current[3]), .A3(
        pack_current[2]), .B1(pack_current[5]), .B2(pack_current[4]), .X(n26)
         );
  SAEDRVT14_OR3_0P5 U37 ( .A1(pack_current[7]), .A2(pack_current[6]), .A3(n26), 
        .X(n27) );
  SAEDRVT14_OR4_1 U38 ( .A1(pack_current[8]), .A2(pack_current[9]), .A3(n31), 
        .A4(n30), .X(N3) );
  SAEDRVT14_OAI21_0P5 U39 ( .A1(n17), .A2(N3), .B(n18), .X(n33) );
  SAEDRVT14_OR3_0P5 U40 ( .A1(n17), .A2(N3), .A3(N36), .X(N37) );
endmodule



    module bms_master_control_unit_enhanced_SNPS_CLOCK_GATE_HIGH_bms_master_control_unit_enhanced_0 ( 
        CLK, EN, ENCLK, TE );
  input CLK, EN, TE;
  output ENCLK;


  SAEDRVT14_CKGTPLT_V5_1 latch ( .CK(CLK), .EN(EN), .SE(TE), .Q(ENCLK) );
endmodule



    module bms_master_control_unit_enhanced_SNPS_CLOCK_GATE_HIGH_bms_master_control_unit_enhanced_2 ( 
        CLK, EN, ENCLK, TE );
  input CLK, EN, TE;
  output ENCLK;


  SAEDRVT14_CKGTPLT_V5_1 latch ( .CK(CLK), .EN(EN), .SE(TE), .Q(ENCLK) );
endmodule



    module bms_master_control_unit_enhanced_SNPS_CLOCK_GATE_HIGH_bms_master_control_unit_enhanced_1 ( 
        CLK, EN, ENCLK, TE );
  input CLK, EN, TE;
  output ENCLK;


  SAEDRVT14_CKGTPLT_V5_1 latch ( .CK(CLK), .EN(EN), .SE(TE), .Q(ENCLK) );
endmodule



    module bms_master_control_unit_enhanced_bms_master_control_unit_enhanced_DP_OP_27J1_123_5989_J1_0_0 ( 
        I1, I2, I3, O1 );
  input [15:0] I1;
  input [15:0] I2;
  input [15:0] I3;
  output [15:0] O1;
  wire   n114, n115, n116, n117, n118, n119, n120, n121, n122, n123, n124,
         n125, n126, n127, n128, n129, n130, n131, n132, n133, n134, n135,
         n136, n137, n138, n139, n140, n141, n142, n143, n144, n145, n146,
         n147, n148, n149, n150, n151, n152, n153, n154, n155, n156, n157,
         n158;

  SAEDRVT14_EO2_1 U35 ( .A1(n158), .A2(n157), .X(O1[15]) );
  SAEDRVT14_ADDF_V2_0P5 U36 ( .A(n148), .B(n147), .CI(I3[1]), .CO(n146), .S(
        O1[1]) );
  SAEDRVT14_ADDF_V2_0P5 U37 ( .A(I3[0]), .B(I2[0]), .CI(I1[0]), .CO(n148), .S(
        O1[0]) );
  SAEDRVT14_EO2_1 U38 ( .A1(n156), .A2(n155), .X(n157) );
  SAEDRVT14_ADDF_V2_0P5 U39 ( .A(I1[14]), .B(I3[14]), .CI(I2[14]), .CO(n155), 
        .S(n153) );
  SAEDRVT14_ADDF_V2_0P5 U40 ( .A(I1[11]), .B(I3[11]), .CI(I2[11]), .CO(n114), 
        .S(n118) );
  SAEDRVT14_ADDF_V2_0P5 U41 ( .A(n119), .B(n118), .CI(n117), .CO(n116), .S(
        O1[11]) );
  SAEDRVT14_ADDF_V2_0P5 U42 ( .A(I1[10]), .B(I3[10]), .CI(I2[10]), .CO(n117), 
        .S(n121) );
  SAEDRVT14_ADDF_V2_0P5 U43 ( .A(I1[7]), .B(I3[7]), .CI(I2[7]), .CO(n126), .S(
        n130) );
  SAEDRVT14_ADDF_V2_0P5 U44 ( .A(I1[4]), .B(I3[4]), .CI(I2[4]), .CO(n135), .S(
        n139) );
  SAEDRVT14_ADDF_V2_0P5 U45 ( .A(n125), .B(n124), .CI(n123), .CO(n122), .S(
        O1[9]) );
  SAEDRVT14_ADDF_V2_0P5 U46 ( .A(n128), .B(n127), .CI(n126), .CO(n125), .S(
        O1[8]) );
  SAEDRVT14_ADDF_V2_0P5 U47 ( .A(n134), .B(n133), .CI(n132), .CO(n131), .S(
        O1[6]) );
  SAEDRVT14_ADDF_V2_0P5 U48 ( .A(n137), .B(n136), .CI(n135), .CO(n134), .S(
        O1[5]) );
  SAEDRVT14_ADDF_V2_0P5 U49 ( .A(n143), .B(n142), .CI(n141), .CO(n140), .S(
        O1[3]) );
  SAEDRVT14_ADDF_V2_0P5 U50 ( .A(n146), .B(n145), .CI(n144), .CO(n143), .S(
        O1[2]) );
  SAEDRVT14_ADDF_V2_0P5 U51 ( .A(n151), .B(n150), .CI(n149), .CO(n154), .S(
        O1[13]) );
  SAEDRVT14_ADDF_V2_0P5 U52 ( .A(n116), .B(n115), .CI(n114), .CO(n151), .S(
        O1[12]) );
  SAEDRVT14_ADDH_0P5 U53 ( .A(I1[1]), .B(I2[1]), .CO(n144), .S(n147) );
  SAEDRVT14_ADDF_V1_0P5 U54 ( .A(I1[2]), .B(I3[2]), .CI(I2[2]), .CO(n141), .S(
        n145) );
  SAEDRVT14_ADDF_V1_0P5 U55 ( .A(I1[3]), .B(I3[3]), .CI(I2[3]), .CO(n138), .S(
        n142) );
  SAEDRVT14_ADDF_V1_0P5 U56 ( .A(I1[5]), .B(I3[5]), .CI(I2[5]), .CO(n132), .S(
        n136) );
  SAEDRVT14_ADDF_V1_0P5 U57 ( .A(I1[6]), .B(I3[6]), .CI(I2[6]), .CO(n129), .S(
        n133) );
  SAEDRVT14_ADDF_V1_0P5 U58 ( .A(I1[8]), .B(I3[8]), .CI(I2[8]), .CO(n123), .S(
        n127) );
  SAEDRVT14_ADDF_V1_0P5 U59 ( .A(I1[9]), .B(I3[9]), .CI(I2[9]), .CO(n120), .S(
        n124) );
  SAEDRVT14_ADDF_V1_0P5 U60 ( .A(I1[12]), .B(I3[12]), .CI(I2[12]), .CO(n149), 
        .S(n115) );
  SAEDRVT14_ADDF_V1_0P5 U61 ( .A(n122), .B(n121), .CI(n120), .CO(n119), .S(
        O1[10]) );
  SAEDRVT14_ADDF_V1_0P5 U62 ( .A(n131), .B(n130), .CI(n129), .CO(n128), .S(
        O1[7]) );
  SAEDRVT14_ADDF_V1_0P5 U63 ( .A(n140), .B(n139), .CI(n138), .CO(n137), .S(
        O1[4]) );
  SAEDRVT14_ADDF_V1_0P5 U64 ( .A(I1[13]), .B(I3[13]), .CI(I2[13]), .CO(n152), 
        .S(n150) );
  SAEDRVT14_ADDF_V1_0P5 U65 ( .A(n154), .B(n153), .CI(n152), .CO(n158), .S(
        O1[14]) );
  SAEDRVT14_EO3_0P5 U66 ( .A1(I1[15]), .A2(I3[15]), .A3(I2[15]), .X(n156) );
endmodule



    module bms_master_control_unit_enhanced_bms_master_control_unit_enhanced_DP_OP_26J1_122_5989_J1_0_0 ( 
        I1, I2, I3, O1 );
  input [15:0] I1;
  input [15:0] I2;
  input [15:0] I3;
  output [15:0] O1;
  wire   n114, n115, n116, n117, n118, n119, n120, n121, n122, n123, n124,
         n125, n126, n127, n128, n129, n130, n131, n132, n133, n134, n135,
         n136, n137, n138, n139, n140, n141, n142, n143, n144, n145, n146,
         n147, n148, n149, n150, n151, n152, n153, n154, n155, n156, n157,
         n158;

  SAEDRVT14_EO2_1 U35 ( .A1(n158), .A2(n157), .X(O1[15]) );
  SAEDRVT14_ADDF_V2_0P5 U36 ( .A(n148), .B(n147), .CI(I3[1]), .CO(n146), .S(
        O1[1]) );
  SAEDRVT14_ADDF_V2_0P5 U37 ( .A(I3[0]), .B(I2[0]), .CI(I1[0]), .CO(n148), .S(
        O1[0]) );
  SAEDRVT14_EO2_1 U38 ( .A1(n156), .A2(n155), .X(n157) );
  SAEDRVT14_ADDF_V2_0P5 U39 ( .A(I1[14]), .B(I3[14]), .CI(I2[14]), .CO(n155), 
        .S(n153) );
  SAEDRVT14_ADDF_V2_0P5 U40 ( .A(I1[11]), .B(I3[11]), .CI(I2[11]), .CO(n114), 
        .S(n118) );
  SAEDRVT14_ADDF_V2_0P5 U41 ( .A(n119), .B(n118), .CI(n117), .CO(n116), .S(
        O1[11]) );
  SAEDRVT14_ADDF_V2_0P5 U42 ( .A(I1[10]), .B(I3[10]), .CI(I2[10]), .CO(n117), 
        .S(n121) );
  SAEDRVT14_ADDF_V2_0P5 U43 ( .A(I1[7]), .B(I3[7]), .CI(I2[7]), .CO(n126), .S(
        n130) );
  SAEDRVT14_ADDF_V2_0P5 U44 ( .A(I1[4]), .B(I3[4]), .CI(I2[4]), .CO(n135), .S(
        n139) );
  SAEDRVT14_ADDF_V2_0P5 U45 ( .A(n125), .B(n124), .CI(n123), .CO(n122), .S(
        O1[9]) );
  SAEDRVT14_ADDF_V2_0P5 U46 ( .A(n128), .B(n127), .CI(n126), .CO(n125), .S(
        O1[8]) );
  SAEDRVT14_ADDF_V2_0P5 U47 ( .A(n134), .B(n133), .CI(n132), .CO(n131), .S(
        O1[6]) );
  SAEDRVT14_ADDF_V2_0P5 U48 ( .A(n137), .B(n136), .CI(n135), .CO(n134), .S(
        O1[5]) );
  SAEDRVT14_ADDF_V2_0P5 U49 ( .A(n143), .B(n142), .CI(n141), .CO(n140), .S(
        O1[3]) );
  SAEDRVT14_ADDF_V2_0P5 U50 ( .A(n146), .B(n145), .CI(n144), .CO(n143), .S(
        O1[2]) );
  SAEDRVT14_ADDF_V2_0P5 U51 ( .A(n151), .B(n150), .CI(n149), .CO(n154), .S(
        O1[13]) );
  SAEDRVT14_ADDF_V2_0P5 U52 ( .A(n116), .B(n115), .CI(n114), .CO(n151), .S(
        O1[12]) );
  SAEDRVT14_ADDH_0P5 U53 ( .A(I1[1]), .B(I2[1]), .CO(n144), .S(n147) );
  SAEDRVT14_ADDF_V1_0P5 U54 ( .A(I1[2]), .B(I3[2]), .CI(I2[2]), .CO(n141), .S(
        n145) );
  SAEDRVT14_ADDF_V1_0P5 U55 ( .A(I1[3]), .B(I3[3]), .CI(I2[3]), .CO(n138), .S(
        n142) );
  SAEDRVT14_ADDF_V1_0P5 U56 ( .A(I1[5]), .B(I3[5]), .CI(I2[5]), .CO(n132), .S(
        n136) );
  SAEDRVT14_ADDF_V1_0P5 U57 ( .A(I1[6]), .B(I3[6]), .CI(I2[6]), .CO(n129), .S(
        n133) );
  SAEDRVT14_ADDF_V1_0P5 U58 ( .A(I1[8]), .B(I3[8]), .CI(I2[8]), .CO(n123), .S(
        n127) );
  SAEDRVT14_ADDF_V1_0P5 U59 ( .A(I1[9]), .B(I3[9]), .CI(I2[9]), .CO(n120), .S(
        n124) );
  SAEDRVT14_ADDF_V1_0P5 U60 ( .A(I1[12]), .B(I3[12]), .CI(I2[12]), .CO(n149), 
        .S(n115) );
  SAEDRVT14_ADDF_V1_0P5 U61 ( .A(n122), .B(n121), .CI(n120), .CO(n119), .S(
        O1[10]) );
  SAEDRVT14_ADDF_V1_0P5 U62 ( .A(n131), .B(n130), .CI(n129), .CO(n128), .S(
        O1[7]) );
  SAEDRVT14_ADDF_V1_0P5 U63 ( .A(n140), .B(n139), .CI(n138), .CO(n137), .S(
        O1[4]) );
  SAEDRVT14_ADDF_V1_0P5 U64 ( .A(I1[13]), .B(I3[13]), .CI(I2[13]), .CO(n152), 
        .S(n150) );
  SAEDRVT14_ADDF_V1_0P5 U65 ( .A(n154), .B(n153), .CI(n152), .CO(n158), .S(
        O1[14]) );
  SAEDRVT14_EO3_0P5 U66 ( .A1(I1[15]), .A2(I3[15]), .A3(I2[15]), .X(n156) );
endmodule



    module bms_master_control_unit_enhanced_bms_master_control_unit_enhanced_DW_cmp_J1_0_0 ( 
        A, B, TC, GE_LT, GE_GT_EQ, GE_LT_GT_LE, EQ_NE );
  input [11:0] A;
  input [11:0] B;
  input TC, GE_LT, GE_GT_EQ;
  output GE_LT_GT_LE, EQ_NE;
  wire   n90, n91, n92, n93, n94, n95, n96, n97, n98, n99, n100, n101, n102,
         n103, n104, n105, n106, n107, n108, n109, n110, n111, n112, n113,
         n114, n115, n116, n117, n118, n119, n120, n121, n122, n123, n124,
         n125, n126, n127, n128, n129, n130, n131, n132, n133, n134, n135,
         n136, n137, n138, n139, n140, n141;

  SAEDRVT14_ND2_CDC_1 U60 ( .A1(B[0]), .A2(n91), .X(n94) );
  SAEDRVT14_AN2_MM_0P5 U61 ( .A1(B[10]), .A2(n132), .X(n133) );
  SAEDRVT14_ND2_CDC_1 U62 ( .A1(B[8]), .A2(n127), .X(n130) );
  SAEDRVT14_NR2_1 U63 ( .A1(n127), .A2(B[8]), .X(n124) );
  SAEDRVT14_ND2_CDC_1 U64 ( .A1(B[2]), .A2(n97), .X(n100) );
  SAEDRVT14_NR2_1 U65 ( .A1(n97), .A2(B[2]), .X(n96) );
  SAEDRVT14_ND2_CDC_1 U66 ( .A1(B[1]), .A2(n92), .X(n93) );
  SAEDLVT14_NR2_MM_0P5 U67 ( .A1(B[1]), .A2(n92), .X(n95) );
  SAEDRVT14_ND2_CDC_1 U68 ( .A1(B[4]), .A2(n108), .X(n111) );
  SAEDRVT14_NR2_1 U69 ( .A1(n108), .A2(B[4]), .X(n106) );
  SAEDLVT14_NR2_MM_0P5 U70 ( .A1(n131), .A2(n124), .X(n125) );
  SAEDRVT14_NR2_1 U71 ( .A1(n128), .A2(B[9]), .X(n131) );
  SAEDLVT14_NR2_MM_0P5 U72 ( .A1(n101), .A2(n96), .X(n103) );
  SAEDRVT14_NR2_1 U73 ( .A1(n98), .A2(B[3]), .X(n101) );
  SAEDLVT14_NR2_MM_0P5 U74 ( .A1(n112), .A2(n106), .X(n107) );
  SAEDRVT14_NR2_1 U75 ( .A1(n109), .A2(B[5]), .X(n112) );
  SAEDLVT14_NR2_MM_0P5 U76 ( .A1(n137), .A2(n126), .X(n140) );
  SAEDRVT14_NR2_1 U77 ( .A1(n135), .A2(B[11]), .X(n137) );
  SAEDRVT14_OR2_0P5 U78 ( .A1(n132), .A2(B[10]), .X(n90) );
  SAEDLVT14_NR2_MM_0P5 U79 ( .A1(n117), .A2(n105), .X(n119) );
  SAEDRVT14_NR2_1 U80 ( .A1(n114), .A2(B[7]), .X(n117) );
  SAEDRVT14_INV_0P5 U81 ( .A(A[1]), .X(n92) );
  SAEDRVT14_INV_0P5 U82 ( .A(A[0]), .X(n91) );
  SAEDRVT14_OAI21_0P5 U83 ( .A1(n95), .A2(n94), .B(n93), .X(n104) );
  SAEDRVT14_INV_0P5 U84 ( .A(A[2]), .X(n97) );
  SAEDRVT14_INV_0P5 U85 ( .A(A[3]), .X(n98) );
  SAEDRVT14_ND2_CDC_1 U86 ( .A1(B[3]), .A2(n98), .X(n99) );
  SAEDRVT14_OAI21_0P5 U87 ( .A1(n101), .A2(n100), .B(n99), .X(n102) );
  SAEDRVT14_AOI21_0P75 U88 ( .A1(n104), .A2(n103), .B(n102), .X(n123) );
  SAEDRVT14_INV_0P5 U89 ( .A(A[6]), .X(n113) );
  SAEDRVT14_NR2_1 U90 ( .A1(n113), .A2(B[6]), .X(n105) );
  SAEDRVT14_INV_0P5 U91 ( .A(A[7]), .X(n114) );
  SAEDRVT14_INV_0P5 U92 ( .A(A[4]), .X(n108) );
  SAEDRVT14_INV_0P5 U93 ( .A(A[5]), .X(n109) );
  SAEDRVT14_ND2_CDC_1 U94 ( .A1(n107), .A2(n119), .X(n122) );
  SAEDRVT14_ND2_CDC_1 U95 ( .A1(B[5]), .A2(n109), .X(n110) );
  SAEDRVT14_OAI21_0P5 U96 ( .A1(n112), .A2(n111), .B(n110), .X(n120) );
  SAEDRVT14_ND2_CDC_1 U97 ( .A1(B[6]), .A2(n113), .X(n116) );
  SAEDRVT14_ND2_CDC_1 U98 ( .A1(B[7]), .A2(n114), .X(n115) );
  SAEDRVT14_OAI21_0P5 U99 ( .A1(n117), .A2(n116), .B(n115), .X(n118) );
  SAEDRVT14_AOI21_0P75 U100 ( .A1(n119), .A2(n120), .B(n118), .X(n121) );
  SAEDRVT14_OAI21_0P5 U101 ( .A1(n123), .A2(n122), .B(n121), .X(n141) );
  SAEDRVT14_INV_0P5 U102 ( .A(A[10]), .X(n132) );
  SAEDRVT14_INV_0P5 U103 ( .A(A[8]), .X(n127) );
  SAEDRVT14_INV_0P5 U104 ( .A(A[9]), .X(n128) );
  SAEDRVT14_ND2_CDC_1 U105 ( .A1(n90), .A2(n125), .X(n126) );
  SAEDRVT14_INV_0P5 U106 ( .A(A[11]), .X(n135) );
  SAEDRVT14_ND2_CDC_1 U107 ( .A1(B[9]), .A2(n128), .X(n129) );
  SAEDRVT14_OAI21_0P5 U108 ( .A1(n131), .A2(n130), .B(n129), .X(n134) );
  SAEDRVT14_AOI21_0P75 U109 ( .A1(n134), .A2(n90), .B(n133), .X(n138) );
  SAEDRVT14_ND2_CDC_1 U110 ( .A1(B[11]), .A2(n135), .X(n136) );
  SAEDRVT14_OAI21_0P5 U111 ( .A1(n137), .A2(n138), .B(n136), .X(n139) );
  SAEDRVT14_AOI21_0P75 U112 ( .A1(n141), .A2(n140), .B(n139), .X(GE_LT_GT_LE)
         );
endmodule



    module bms_master_control_unit_enhanced_bms_master_control_unit_enhanced_DW_cmp_J1_1_0 ( 
        A, B, TC, GE_LT, GE_GT_EQ, GE_LT_GT_LE, EQ_NE );
  input [11:0] A;
  input [11:0] B;
  input TC, GE_LT, GE_GT_EQ;
  output GE_LT_GT_LE, EQ_NE;
  wire   n90, n91, n92, n93, n94, n95, n96, n97, n98, n99, n100, n101, n102,
         n103, n104, n105, n106, n107, n108, n109, n110, n111, n112, n113,
         n114, n115, n116, n117, n118, n119, n120, n121, n122, n123, n124,
         n125, n126, n127, n128, n129, n130, n131, n132, n133, n134, n135,
         n136, n137, n138, n139, n140, n141;

  SAEDRVT14_ND2_CDC_1 U60 ( .A1(B[0]), .A2(n91), .X(n94) );
  SAEDRVT14_AN2_MM_0P5 U61 ( .A1(B[10]), .A2(n132), .X(n133) );
  SAEDRVT14_ND2_CDC_1 U62 ( .A1(B[8]), .A2(n127), .X(n130) );
  SAEDRVT14_NR2_1 U63 ( .A1(n127), .A2(B[8]), .X(n124) );
  SAEDRVT14_ND2_CDC_1 U64 ( .A1(B[1]), .A2(n92), .X(n93) );
  SAEDLVT14_NR2_MM_0P5 U65 ( .A1(B[1]), .A2(n92), .X(n95) );
  SAEDRVT14_ND2_CDC_1 U66 ( .A1(B[2]), .A2(n97), .X(n100) );
  SAEDRVT14_NR2_1 U67 ( .A1(n97), .A2(B[2]), .X(n96) );
  SAEDRVT14_ND2_CDC_1 U68 ( .A1(B[4]), .A2(n108), .X(n111) );
  SAEDRVT14_NR2_1 U69 ( .A1(n108), .A2(B[4]), .X(n106) );
  SAEDLVT14_NR2_MM_0P5 U70 ( .A1(n131), .A2(n124), .X(n125) );
  SAEDRVT14_NR2_1 U71 ( .A1(n128), .A2(B[9]), .X(n131) );
  SAEDLVT14_NR2_MM_0P5 U72 ( .A1(n101), .A2(n96), .X(n103) );
  SAEDRVT14_NR2_1 U73 ( .A1(n98), .A2(B[3]), .X(n101) );
  SAEDLVT14_NR2_MM_0P5 U74 ( .A1(n112), .A2(n106), .X(n107) );
  SAEDRVT14_NR2_1 U75 ( .A1(n109), .A2(B[5]), .X(n112) );
  SAEDLVT14_NR2_MM_0P5 U76 ( .A1(n137), .A2(n126), .X(n140) );
  SAEDRVT14_NR2_1 U77 ( .A1(n135), .A2(B[11]), .X(n137) );
  SAEDRVT14_OR2_0P5 U78 ( .A1(n132), .A2(B[10]), .X(n90) );
  SAEDLVT14_NR2_MM_0P5 U79 ( .A1(n117), .A2(n105), .X(n119) );
  SAEDRVT14_NR2_1 U80 ( .A1(n114), .A2(B[7]), .X(n117) );
  SAEDRVT14_INV_0P5 U81 ( .A(A[1]), .X(n92) );
  SAEDRVT14_INV_0P5 U82 ( .A(A[0]), .X(n91) );
  SAEDRVT14_OAI21_0P5 U83 ( .A1(n95), .A2(n94), .B(n93), .X(n104) );
  SAEDRVT14_INV_0P5 U84 ( .A(A[2]), .X(n97) );
  SAEDRVT14_INV_0P5 U85 ( .A(A[3]), .X(n98) );
  SAEDRVT14_ND2_CDC_1 U86 ( .A1(B[3]), .A2(n98), .X(n99) );
  SAEDRVT14_OAI21_0P5 U87 ( .A1(n101), .A2(n100), .B(n99), .X(n102) );
  SAEDRVT14_AOI21_0P75 U88 ( .A1(n104), .A2(n103), .B(n102), .X(n123) );
  SAEDRVT14_INV_0P5 U89 ( .A(A[6]), .X(n113) );
  SAEDRVT14_NR2_1 U90 ( .A1(n113), .A2(B[6]), .X(n105) );
  SAEDRVT14_INV_0P5 U91 ( .A(A[7]), .X(n114) );
  SAEDRVT14_INV_0P5 U92 ( .A(A[4]), .X(n108) );
  SAEDRVT14_INV_0P5 U93 ( .A(A[5]), .X(n109) );
  SAEDRVT14_ND2_CDC_1 U94 ( .A1(n107), .A2(n119), .X(n122) );
  SAEDRVT14_ND2_CDC_1 U95 ( .A1(B[5]), .A2(n109), .X(n110) );
  SAEDRVT14_OAI21_0P5 U96 ( .A1(n112), .A2(n111), .B(n110), .X(n120) );
  SAEDRVT14_ND2_CDC_1 U97 ( .A1(B[6]), .A2(n113), .X(n116) );
  SAEDRVT14_ND2_CDC_1 U98 ( .A1(B[7]), .A2(n114), .X(n115) );
  SAEDRVT14_OAI21_0P5 U99 ( .A1(n117), .A2(n116), .B(n115), .X(n118) );
  SAEDRVT14_AOI21_0P75 U100 ( .A1(n119), .A2(n120), .B(n118), .X(n121) );
  SAEDRVT14_OAI21_0P5 U101 ( .A1(n123), .A2(n122), .B(n121), .X(n141) );
  SAEDRVT14_INV_0P5 U102 ( .A(A[10]), .X(n132) );
  SAEDRVT14_INV_0P5 U103 ( .A(A[8]), .X(n127) );
  SAEDRVT14_INV_0P5 U104 ( .A(A[9]), .X(n128) );
  SAEDRVT14_ND2_CDC_1 U105 ( .A1(n90), .A2(n125), .X(n126) );
  SAEDRVT14_INV_0P5 U106 ( .A(A[11]), .X(n135) );
  SAEDRVT14_ND2_CDC_1 U107 ( .A1(B[9]), .A2(n128), .X(n129) );
  SAEDRVT14_OAI21_0P5 U108 ( .A1(n131), .A2(n130), .B(n129), .X(n134) );
  SAEDRVT14_AOI21_0P75 U109 ( .A1(n134), .A2(n90), .B(n133), .X(n138) );
  SAEDRVT14_ND2_CDC_1 U110 ( .A1(B[11]), .A2(n135), .X(n136) );
  SAEDRVT14_OAI21_0P5 U111 ( .A1(n137), .A2(n138), .B(n136), .X(n139) );
  SAEDRVT14_AOI21_0P75 U112 ( .A1(n141), .A2(n140), .B(n139), .X(GE_LT_GT_LE)
         );
endmodule



    module bms_master_control_unit_enhanced_bms_master_control_unit_enhanced_DW_cmp_J1_2_0 ( 
        A, B, TC, GE_LT, GE_GT_EQ, GE_LT_GT_LE, EQ_NE );
  input [11:0] A;
  input [11:0] B;
  input TC, GE_LT, GE_GT_EQ;
  output GE_LT_GT_LE, EQ_NE;
  wire   n90, n91, n92, n93, n94, n95, n96, n97, n98, n99, n100, n101, n102,
         n103, n104, n105, n106, n107, n108, n109, n110, n111, n112, n113,
         n114, n115, n116, n117, n118, n119, n120, n121, n122, n123, n124,
         n125, n126, n127, n128, n129, n130, n131, n132, n133, n134, n135,
         n136, n137, n138, n139, n140, n141;

  SAEDRVT14_ND2_CDC_1 U60 ( .A1(B[0]), .A2(n91), .X(n94) );
  SAEDRVT14_AN2_MM_0P5 U61 ( .A1(B[10]), .A2(n132), .X(n133) );
  SAEDRVT14_ND2_CDC_1 U62 ( .A1(B[8]), .A2(n127), .X(n130) );
  SAEDRVT14_NR2_1 U63 ( .A1(n127), .A2(B[8]), .X(n124) );
  SAEDRVT14_ND2_CDC_1 U64 ( .A1(B[1]), .A2(n92), .X(n93) );
  SAEDLVT14_NR2_MM_0P5 U65 ( .A1(B[1]), .A2(n92), .X(n95) );
  SAEDRVT14_ND2_CDC_1 U66 ( .A1(B[2]), .A2(n97), .X(n100) );
  SAEDRVT14_NR2_1 U67 ( .A1(n97), .A2(B[2]), .X(n96) );
  SAEDRVT14_ND2_CDC_1 U68 ( .A1(B[4]), .A2(n108), .X(n111) );
  SAEDRVT14_NR2_1 U69 ( .A1(n108), .A2(B[4]), .X(n106) );
  SAEDLVT14_NR2_MM_0P5 U70 ( .A1(n131), .A2(n124), .X(n125) );
  SAEDRVT14_NR2_1 U71 ( .A1(n128), .A2(B[9]), .X(n131) );
  SAEDLVT14_NR2_MM_0P5 U72 ( .A1(n101), .A2(n96), .X(n103) );
  SAEDRVT14_NR2_1 U73 ( .A1(n98), .A2(B[3]), .X(n101) );
  SAEDLVT14_NR2_MM_0P5 U74 ( .A1(n112), .A2(n106), .X(n107) );
  SAEDRVT14_NR2_1 U75 ( .A1(n109), .A2(B[5]), .X(n112) );
  SAEDLVT14_NR2_MM_0P5 U76 ( .A1(n137), .A2(n126), .X(n140) );
  SAEDRVT14_NR2_1 U77 ( .A1(n135), .A2(B[11]), .X(n137) );
  SAEDRVT14_OR2_0P5 U78 ( .A1(n132), .A2(B[10]), .X(n90) );
  SAEDLVT14_NR2_MM_0P5 U79 ( .A1(n117), .A2(n105), .X(n119) );
  SAEDRVT14_NR2_1 U80 ( .A1(n114), .A2(B[7]), .X(n117) );
  SAEDRVT14_INV_0P5 U81 ( .A(A[1]), .X(n92) );
  SAEDRVT14_INV_0P5 U82 ( .A(A[0]), .X(n91) );
  SAEDRVT14_OAI21_0P5 U83 ( .A1(n95), .A2(n94), .B(n93), .X(n104) );
  SAEDRVT14_INV_0P5 U84 ( .A(A[2]), .X(n97) );
  SAEDRVT14_INV_0P5 U85 ( .A(A[3]), .X(n98) );
  SAEDRVT14_ND2_CDC_1 U86 ( .A1(B[3]), .A2(n98), .X(n99) );
  SAEDRVT14_OAI21_0P5 U87 ( .A1(n101), .A2(n100), .B(n99), .X(n102) );
  SAEDRVT14_AOI21_0P75 U88 ( .A1(n104), .A2(n103), .B(n102), .X(n123) );
  SAEDRVT14_INV_0P5 U89 ( .A(A[6]), .X(n113) );
  SAEDRVT14_NR2_1 U90 ( .A1(n113), .A2(B[6]), .X(n105) );
  SAEDRVT14_INV_0P5 U91 ( .A(A[7]), .X(n114) );
  SAEDRVT14_INV_0P5 U92 ( .A(A[4]), .X(n108) );
  SAEDRVT14_INV_0P5 U93 ( .A(A[5]), .X(n109) );
  SAEDRVT14_ND2_CDC_1 U94 ( .A1(n107), .A2(n119), .X(n122) );
  SAEDRVT14_ND2_CDC_1 U95 ( .A1(B[5]), .A2(n109), .X(n110) );
  SAEDRVT14_OAI21_0P5 U96 ( .A1(n112), .A2(n111), .B(n110), .X(n120) );
  SAEDRVT14_ND2_CDC_1 U97 ( .A1(B[6]), .A2(n113), .X(n116) );
  SAEDRVT14_ND2_CDC_1 U98 ( .A1(B[7]), .A2(n114), .X(n115) );
  SAEDRVT14_OAI21_0P5 U99 ( .A1(n117), .A2(n116), .B(n115), .X(n118) );
  SAEDRVT14_AOI21_0P75 U100 ( .A1(n119), .A2(n120), .B(n118), .X(n121) );
  SAEDRVT14_OAI21_0P5 U101 ( .A1(n123), .A2(n122), .B(n121), .X(n141) );
  SAEDRVT14_INV_0P5 U102 ( .A(A[10]), .X(n132) );
  SAEDRVT14_INV_0P5 U103 ( .A(A[8]), .X(n127) );
  SAEDRVT14_INV_0P5 U104 ( .A(A[9]), .X(n128) );
  SAEDRVT14_ND2_CDC_1 U105 ( .A1(n90), .A2(n125), .X(n126) );
  SAEDRVT14_INV_0P5 U106 ( .A(A[11]), .X(n135) );
  SAEDRVT14_ND2_CDC_1 U107 ( .A1(B[9]), .A2(n128), .X(n129) );
  SAEDRVT14_OAI21_0P5 U108 ( .A1(n131), .A2(n130), .B(n129), .X(n134) );
  SAEDRVT14_AOI21_0P75 U109 ( .A1(n134), .A2(n90), .B(n133), .X(n138) );
  SAEDRVT14_ND2_CDC_1 U110 ( .A1(B[11]), .A2(n135), .X(n136) );
  SAEDRVT14_OAI21_0P5 U111 ( .A1(n137), .A2(n138), .B(n136), .X(n139) );
  SAEDRVT14_AOI21_0P75 U112 ( .A1(n141), .A2(n140), .B(n139), .X(GE_LT_GT_LE)
         );
endmodule



    module bms_master_control_unit_enhanced_bms_master_control_unit_enhanced_DW_div_uns_J1_0_0 ( 
        a, b, quotient, remainder, divide_by_0 );
  input [15:0] a;
  input [1:0] b;
  output [15:0] quotient;
  output [1:0] remainder;
  output divide_by_0;
  wire   n1, n2, n3, n4, n5, n6, n7, n8, n9, n10, n11, n12, n13, n14, n15, n16,
         n17, n18, n19, n20, n21, n22, n23, n24, n25, n26, n27, n28, n29, n30,
         n31, n32, n33, n34, n35, n36, n37, n38, n39, n40, n41, n42, n43, n44,
         n45, n46, n47, n48, n49, n50, n51, n52, n53, n54, n55;

  SAEDRVT14_AO2BB2_V1_0P5 U1 ( .A1(n1), .A2(a[14]), .B1(n2), .B2(a[13]), .X(
        quotient[13]) );
  SAEDRVT14_NR2B_2 U2 ( .A(a[14]), .B(a[15]), .X(n2) );
  SAEDRVT14_AN2_0P5 U3 ( .A1(a[15]), .A2(a[14]), .X(quotient[14]) );
  SAEDRVT14_OA2BB2_V1_0P5 U4 ( .A1(a[0]), .A2(quotient[1]), .B1(n52), .B2(n51), 
        .X(n54) );
  SAEDRVT14_INV_0P5 U5 ( .A(a[15]), .X(n1) );
  SAEDRVT14_EN2_0P5 U6 ( .A1(quotient[13]), .A2(a[13]), .X(n7) );
  SAEDRVT14_INV_0P5 U7 ( .A(a[12]), .X(n6) );
  SAEDRVT14_ND2_CDC_1 U8 ( .A1(quotient[13]), .A2(a[13]), .X(n4) );
  SAEDRVT14_INV_0P5 U9 ( .A(n2), .X(n3) );
  SAEDRVT14_EN2_0P5 U10 ( .A1(n4), .A2(n3), .X(n5) );
  SAEDRVT14_OAI21_0P5 U11 ( .A1(n7), .A2(n6), .B(n5), .X(quotient[12]) );
  SAEDRVT14_EN2_0P5 U12 ( .A1(quotient[12]), .A2(a[12]), .X(n11) );
  SAEDRVT14_INV_0P5 U13 ( .A(a[11]), .X(n10) );
  SAEDRVT14_ND2_CDC_1 U14 ( .A1(quotient[12]), .A2(a[12]), .X(n8) );
  SAEDRVT14_EN2_0P5 U15 ( .A1(n8), .A2(n7), .X(n9) );
  SAEDRVT14_OAI21_0P5 U16 ( .A1(n11), .A2(n10), .B(n9), .X(quotient[11]) );
  SAEDRVT14_EN2_0P5 U17 ( .A1(quotient[11]), .A2(a[11]), .X(n15) );
  SAEDRVT14_INV_0P5 U18 ( .A(a[10]), .X(n14) );
  SAEDRVT14_ND2_CDC_1 U19 ( .A1(quotient[11]), .A2(a[11]), .X(n12) );
  SAEDRVT14_EN2_0P5 U20 ( .A1(n12), .A2(n11), .X(n13) );
  SAEDRVT14_OAI21_0P5 U21 ( .A1(n15), .A2(n14), .B(n13), .X(quotient[10]) );
  SAEDRVT14_EN2_0P5 U22 ( .A1(quotient[10]), .A2(a[10]), .X(n19) );
  SAEDRVT14_INV_0P5 U23 ( .A(a[9]), .X(n18) );
  SAEDRVT14_ND2_CDC_1 U24 ( .A1(quotient[10]), .A2(a[10]), .X(n16) );
  SAEDRVT14_EN2_0P5 U25 ( .A1(n16), .A2(n15), .X(n17) );
  SAEDRVT14_OAI21_0P5 U26 ( .A1(n19), .A2(n18), .B(n17), .X(quotient[9]) );
  SAEDRVT14_EN2_0P5 U27 ( .A1(quotient[9]), .A2(a[9]), .X(n23) );
  SAEDRVT14_INV_0P5 U28 ( .A(a[8]), .X(n22) );
  SAEDRVT14_ND2_CDC_1 U29 ( .A1(quotient[9]), .A2(a[9]), .X(n20) );
  SAEDRVT14_EN2_0P5 U30 ( .A1(n20), .A2(n19), .X(n21) );
  SAEDRVT14_OAI21_0P5 U31 ( .A1(n23), .A2(n22), .B(n21), .X(quotient[8]) );
  SAEDRVT14_EN2_0P5 U32 ( .A1(quotient[8]), .A2(a[8]), .X(n27) );
  SAEDRVT14_INV_0P5 U33 ( .A(a[7]), .X(n26) );
  SAEDRVT14_ND2_CDC_1 U34 ( .A1(quotient[8]), .A2(a[8]), .X(n24) );
  SAEDRVT14_EN2_0P5 U35 ( .A1(n24), .A2(n23), .X(n25) );
  SAEDRVT14_OAI21_0P5 U36 ( .A1(n27), .A2(n26), .B(n25), .X(quotient[7]) );
  SAEDRVT14_EN2_0P5 U37 ( .A1(quotient[7]), .A2(a[7]), .X(n31) );
  SAEDRVT14_INV_0P5 U38 ( .A(a[6]), .X(n30) );
  SAEDRVT14_ND2_CDC_1 U39 ( .A1(quotient[7]), .A2(a[7]), .X(n28) );
  SAEDRVT14_EN2_0P5 U40 ( .A1(n28), .A2(n27), .X(n29) );
  SAEDRVT14_OAI21_0P5 U41 ( .A1(n31), .A2(n30), .B(n29), .X(quotient[6]) );
  SAEDRVT14_EN2_0P5 U42 ( .A1(quotient[6]), .A2(a[6]), .X(n35) );
  SAEDRVT14_INV_0P5 U43 ( .A(a[5]), .X(n34) );
  SAEDRVT14_ND2_CDC_1 U44 ( .A1(quotient[6]), .A2(a[6]), .X(n32) );
  SAEDRVT14_EN2_0P5 U45 ( .A1(n32), .A2(n31), .X(n33) );
  SAEDRVT14_OAI21_0P5 U46 ( .A1(n35), .A2(n34), .B(n33), .X(quotient[5]) );
  SAEDRVT14_EN2_0P5 U47 ( .A1(quotient[5]), .A2(a[5]), .X(n39) );
  SAEDRVT14_INV_0P5 U48 ( .A(a[4]), .X(n38) );
  SAEDRVT14_ND2_CDC_1 U49 ( .A1(quotient[5]), .A2(a[5]), .X(n36) );
  SAEDRVT14_EN2_0P5 U50 ( .A1(n36), .A2(n35), .X(n37) );
  SAEDRVT14_OAI21_0P5 U51 ( .A1(n39), .A2(n38), .B(n37), .X(quotient[4]) );
  SAEDRVT14_EN2_0P5 U52 ( .A1(quotient[4]), .A2(a[4]), .X(n43) );
  SAEDRVT14_INV_0P5 U53 ( .A(a[3]), .X(n42) );
  SAEDRVT14_ND2_CDC_1 U54 ( .A1(a[4]), .A2(quotient[4]), .X(n40) );
  SAEDRVT14_EN2_0P5 U55 ( .A1(n40), .A2(n39), .X(n41) );
  SAEDRVT14_OAI21_0P5 U56 ( .A1(n43), .A2(n42), .B(n41), .X(quotient[3]) );
  SAEDRVT14_EN2_0P5 U57 ( .A1(quotient[3]), .A2(a[3]), .X(n47) );
  SAEDRVT14_INV_0P5 U58 ( .A(a[2]), .X(n46) );
  SAEDRVT14_ND2_CDC_1 U59 ( .A1(a[3]), .A2(quotient[3]), .X(n44) );
  SAEDRVT14_EN2_0P5 U60 ( .A1(n44), .A2(n43), .X(n45) );
  SAEDRVT14_OAI21_0P5 U61 ( .A1(n47), .A2(n46), .B(n45), .X(quotient[2]) );
  SAEDRVT14_EN2_0P5 U62 ( .A1(quotient[2]), .A2(a[2]), .X(n50) );
  SAEDRVT14_INV_0P5 U63 ( .A(a[1]), .X(n51) );
  SAEDRVT14_ND2_CDC_1 U64 ( .A1(quotient[2]), .A2(a[2]), .X(n48) );
  SAEDRVT14_EN2_0P5 U65 ( .A1(n48), .A2(n47), .X(n49) );
  SAEDRVT14_OAI21_0P5 U66 ( .A1(n50), .A2(n51), .B(n49), .X(quotient[1]) );
  SAEDRVT14_INV_0P5 U67 ( .A(n50), .X(n55) );
  SAEDRVT14_NR2_1 U68 ( .A1(quotient[1]), .A2(a[0]), .X(n52) );
  SAEDRVT14_ND2B_U_0P5 U69 ( .A(quotient[1]), .B(n55), .X(n53) );
  SAEDRVT14_OAI21_0P5 U70 ( .A1(n55), .A2(n54), .B(n53), .X(quotient[0]) );
endmodule



    module bms_master_control_unit_enhanced_bms_master_control_unit_enhanced_DW_div_uns_J1_1_0 ( 
        a, b, quotient, remainder, divide_by_0 );
  input [15:0] a;
  input [1:0] b;
  output [15:0] quotient;
  output [1:0] remainder;
  output divide_by_0;
  wire   n1, n2, n3, n4, n5, n6, n7, n8, n9, n10, n11, n12, n13, n14, n15, n16,
         n17, n18, n19, n20, n21, n22, n23, n24, n25, n26, n27, n28, n29, n30,
         n31, n32, n33, n34, n35, n36, n37, n38, n39, n40, n41, n42, n43, n44,
         n45, n46, n47, n48, n49, n50, n51, n52, n53, n54, n55;

  SAEDRVT14_AO2BB2_V1_0P5 U1 ( .A1(n1), .A2(a[14]), .B1(n2), .B2(a[13]), .X(
        quotient[13]) );
  SAEDRVT14_NR2B_2 U2 ( .A(a[14]), .B(a[15]), .X(n2) );
  SAEDRVT14_AN2_0P5 U3 ( .A1(a[15]), .A2(a[14]), .X(quotient[14]) );
  SAEDRVT14_OA2BB2_V1_0P5 U4 ( .A1(a[0]), .A2(quotient[1]), .B1(n52), .B2(n51), 
        .X(n54) );
  SAEDRVT14_INV_0P5 U5 ( .A(a[15]), .X(n1) );
  SAEDRVT14_EN2_0P5 U6 ( .A1(quotient[13]), .A2(a[13]), .X(n7) );
  SAEDRVT14_INV_0P5 U7 ( .A(a[12]), .X(n6) );
  SAEDRVT14_ND2_CDC_1 U8 ( .A1(quotient[13]), .A2(a[13]), .X(n4) );
  SAEDRVT14_INV_0P5 U9 ( .A(n2), .X(n3) );
  SAEDRVT14_EN2_0P5 U10 ( .A1(n4), .A2(n3), .X(n5) );
  SAEDRVT14_OAI21_0P5 U11 ( .A1(n7), .A2(n6), .B(n5), .X(quotient[12]) );
  SAEDRVT14_EN2_0P5 U12 ( .A1(quotient[12]), .A2(a[12]), .X(n11) );
  SAEDRVT14_INV_0P5 U13 ( .A(a[11]), .X(n10) );
  SAEDRVT14_ND2_CDC_1 U14 ( .A1(quotient[12]), .A2(a[12]), .X(n8) );
  SAEDRVT14_EN2_0P5 U15 ( .A1(n8), .A2(n7), .X(n9) );
  SAEDRVT14_OAI21_0P5 U16 ( .A1(n11), .A2(n10), .B(n9), .X(quotient[11]) );
  SAEDRVT14_EN2_0P5 U17 ( .A1(quotient[11]), .A2(a[11]), .X(n15) );
  SAEDRVT14_INV_0P5 U18 ( .A(a[10]), .X(n14) );
  SAEDRVT14_ND2_CDC_1 U19 ( .A1(quotient[11]), .A2(a[11]), .X(n12) );
  SAEDRVT14_EN2_0P5 U20 ( .A1(n12), .A2(n11), .X(n13) );
  SAEDRVT14_OAI21_0P5 U21 ( .A1(n15), .A2(n14), .B(n13), .X(quotient[10]) );
  SAEDRVT14_EN2_0P5 U22 ( .A1(quotient[10]), .A2(a[10]), .X(n19) );
  SAEDRVT14_INV_0P5 U23 ( .A(a[9]), .X(n18) );
  SAEDRVT14_ND2_CDC_1 U24 ( .A1(quotient[10]), .A2(a[10]), .X(n16) );
  SAEDRVT14_EN2_0P5 U25 ( .A1(n16), .A2(n15), .X(n17) );
  SAEDRVT14_OAI21_0P5 U26 ( .A1(n19), .A2(n18), .B(n17), .X(quotient[9]) );
  SAEDRVT14_EN2_0P5 U27 ( .A1(quotient[9]), .A2(a[9]), .X(n23) );
  SAEDRVT14_INV_0P5 U28 ( .A(a[8]), .X(n22) );
  SAEDRVT14_ND2_CDC_1 U29 ( .A1(quotient[9]), .A2(a[9]), .X(n20) );
  SAEDRVT14_EN2_0P5 U30 ( .A1(n20), .A2(n19), .X(n21) );
  SAEDRVT14_OAI21_0P5 U31 ( .A1(n23), .A2(n22), .B(n21), .X(quotient[8]) );
  SAEDRVT14_EN2_0P5 U32 ( .A1(quotient[8]), .A2(a[8]), .X(n27) );
  SAEDRVT14_INV_0P5 U33 ( .A(a[7]), .X(n26) );
  SAEDRVT14_ND2_CDC_1 U34 ( .A1(quotient[8]), .A2(a[8]), .X(n24) );
  SAEDRVT14_EN2_0P5 U35 ( .A1(n24), .A2(n23), .X(n25) );
  SAEDRVT14_OAI21_0P5 U36 ( .A1(n27), .A2(n26), .B(n25), .X(quotient[7]) );
  SAEDRVT14_EN2_0P5 U37 ( .A1(quotient[7]), .A2(a[7]), .X(n31) );
  SAEDRVT14_INV_0P5 U38 ( .A(a[6]), .X(n30) );
  SAEDRVT14_ND2_CDC_1 U39 ( .A1(quotient[7]), .A2(a[7]), .X(n28) );
  SAEDRVT14_EN2_0P5 U40 ( .A1(n28), .A2(n27), .X(n29) );
  SAEDRVT14_OAI21_0P5 U41 ( .A1(n31), .A2(n30), .B(n29), .X(quotient[6]) );
  SAEDRVT14_EN2_0P5 U42 ( .A1(quotient[6]), .A2(a[6]), .X(n35) );
  SAEDRVT14_INV_0P5 U43 ( .A(a[5]), .X(n34) );
  SAEDRVT14_ND2_CDC_1 U44 ( .A1(quotient[6]), .A2(a[6]), .X(n32) );
  SAEDRVT14_EN2_0P5 U45 ( .A1(n32), .A2(n31), .X(n33) );
  SAEDRVT14_OAI21_0P5 U46 ( .A1(n35), .A2(n34), .B(n33), .X(quotient[5]) );
  SAEDRVT14_EN2_0P5 U47 ( .A1(quotient[5]), .A2(a[5]), .X(n39) );
  SAEDRVT14_INV_0P5 U48 ( .A(a[4]), .X(n38) );
  SAEDRVT14_ND2_CDC_1 U49 ( .A1(quotient[5]), .A2(a[5]), .X(n36) );
  SAEDRVT14_EN2_0P5 U50 ( .A1(n36), .A2(n35), .X(n37) );
  SAEDRVT14_OAI21_0P5 U51 ( .A1(n39), .A2(n38), .B(n37), .X(quotient[4]) );
  SAEDRVT14_EN2_0P5 U52 ( .A1(quotient[4]), .A2(a[4]), .X(n43) );
  SAEDRVT14_INV_0P5 U53 ( .A(a[3]), .X(n42) );
  SAEDRVT14_ND2_CDC_1 U54 ( .A1(a[4]), .A2(quotient[4]), .X(n40) );
  SAEDRVT14_EN2_0P5 U55 ( .A1(n40), .A2(n39), .X(n41) );
  SAEDRVT14_OAI21_0P5 U56 ( .A1(n43), .A2(n42), .B(n41), .X(quotient[3]) );
  SAEDRVT14_EN2_0P5 U57 ( .A1(quotient[3]), .A2(a[3]), .X(n47) );
  SAEDRVT14_INV_0P5 U58 ( .A(a[2]), .X(n46) );
  SAEDRVT14_ND2_CDC_1 U59 ( .A1(a[3]), .A2(quotient[3]), .X(n44) );
  SAEDRVT14_EN2_0P5 U60 ( .A1(n44), .A2(n43), .X(n45) );
  SAEDRVT14_OAI21_0P5 U61 ( .A1(n47), .A2(n46), .B(n45), .X(quotient[2]) );
  SAEDRVT14_EN2_0P5 U62 ( .A1(quotient[2]), .A2(a[2]), .X(n50) );
  SAEDRVT14_INV_0P5 U63 ( .A(a[1]), .X(n51) );
  SAEDRVT14_ND2_CDC_1 U64 ( .A1(quotient[2]), .A2(a[2]), .X(n48) );
  SAEDRVT14_EN2_0P5 U65 ( .A1(n48), .A2(n47), .X(n49) );
  SAEDRVT14_OAI21_0P5 U66 ( .A1(n50), .A2(n51), .B(n49), .X(quotient[1]) );
  SAEDRVT14_INV_0P5 U67 ( .A(n50), .X(n55) );
  SAEDRVT14_NR2_1 U68 ( .A1(quotient[1]), .A2(a[0]), .X(n52) );
  SAEDRVT14_ND2B_U_0P5 U69 ( .A(quotient[1]), .B(n55), .X(n53) );
  SAEDRVT14_OAI21_0P5 U70 ( .A1(n55), .A2(n54), .B(n53), .X(quotient[0]) );
endmodule


module bms_master_control_unit_enhanced ( clk, rst_n, start_poll, spi_miso, 
        pack_current, lmu0_temp_die, lmu1_temp_die, lmu2_temp_die, lmu0_soc, 
        lmu1_soc, lmu2_soc, lmu0_soh, lmu1_soh, lmu2_soh, lmu0_fault, 
        lmu1_fault, lmu2_fault, lmu0_fault_code, lmu1_fault_code, 
        lmu2_fault_code, spi_sclk, spi_mosi, spi_cs_n, pack_soc_avg, 
        pack_soh_avg, global_fault, global_fault_code, active_lmu_id, 
        poll_busy, current_warn, current_trip, thermal_warn, thermal_trip, 
        lmu_count_fault, allowed_current, supervisor_code, max_temp_seen );
  input [15:0] pack_current;
  input [11:0] lmu0_temp_die;
  input [11:0] lmu1_temp_die;
  input [11:0] lmu2_temp_die;
  input [15:0] lmu0_soc;
  input [15:0] lmu1_soc;
  input [15:0] lmu2_soc;
  input [15:0] lmu0_soh;
  input [15:0] lmu1_soh;
  input [15:0] lmu2_soh;
  input [7:0] lmu0_fault_code;
  input [7:0] lmu1_fault_code;
  input [7:0] lmu2_fault_code;
  output [2:0] spi_cs_n;
  output [15:0] pack_soc_avg;
  output [15:0] pack_soh_avg;
  output [7:0] global_fault_code;
  output [1:0] active_lmu_id;
  output [15:0] allowed_current;
  output [7:0] supervisor_code;
  output [11:0] max_temp_seen;
  input clk, rst_n, start_poll, spi_miso, lmu0_fault, lmu1_fault, lmu2_fault;
  output spi_sclk, spi_mosi, global_fault, poll_busy, current_warn,
         current_trip, thermal_warn, thermal_trip, lmu_count_fault;

//synopsys upf_name_map bms_master_control_unit_enhanced ""
  wire   n214, n215, n216, n217, n218, n219, n220, spi_start, spi_tx_byte_4_,
         spi_done, N40, N41, N42, N43, N44, N45, N46, N47, N48, N49, N50, N51,
         N52, N53, N54, N55, N56, N57, N58, N59, N60, N61, N62, N63, N64, N65,
         N66, N67, N68, N69, N70, N88, N89, N90, N91, N92, N93, N94, N95, N96,
         N97, N98, N99, N100, N101, N102, N103, N104, N105, N106, N107, N108,
         N109, N110, N111, N112, N113, N114, N115, N116, N117, N118, N120,
         N121, N123, N126, N127, N128, N129, N130, N131, N132, N133, N134,
         N135, N136, N137, N138, N153, N155, N157, N159, N161, net893, net899,
         net904, n3, n82, n83, n85, n86, n87, n88, n89, n90, n91, n92, n93,
         n95, n96, n98, n99, n101, n102, n103, n104, n105, n106, n107, n109,
         n110, n111, n112, n113, n114, n115, n116, n117, n118, n119, n120,
         n121, n122, n123, n124, n125, n126, n127, n128, n130, n131, n133,
         n134, n135, n136, n137, n138, n139, n141, n142, n143, n144, n145,
         n146, n147, n148, n149, n150, n151, n152, n153, n154, n155, n156,
         n157, n158, n159, n160, n161, n162, n163, n164, n165, n166, n167,
         n168, n169, n170, n171, n172, n173, n174, n175, n176, n177, n178,
         n179, n180, n181, n182, n183, n184, n185, n186, lmu_count_fault, n198,
         n199, n200, n201, n202, n203, n204, n205, n206, n207, n208, n209,
         n210, n211, n212, n213, SYNOPSYS_UNCONNECTED_1,
         SYNOPSYS_UNCONNECTED_2, SYNOPSYS_UNCONNECTED_3,
         SYNOPSYS_UNCONNECTED_4, SYNOPSYS_UNCONNECTED_5,
         SYNOPSYS_UNCONNECTED_6, SYNOPSYS_UNCONNECTED_7,
         SYNOPSYS_UNCONNECTED_8, SYNOPSYS_UNCONNECTED_9,
         SYNOPSYS_UNCONNECTED_10, SYNOPSYS_UNCONNECTED_11,
         SYNOPSYS_UNCONNECTED_12, SYNOPSYS_UNCONNECTED_13,
         SYNOPSYS_UNCONNECTED_14, SYNOPSYS_UNCONNECTED_15,
         SYNOPSYS_UNCONNECTED_16, SYNOPSYS_UNCONNECTED_17,
         SYNOPSYS_UNCONNECTED_18, SYNOPSYS_UNCONNECTED_19,
         SYNOPSYS_UNCONNECTED_20, SYNOPSYS_UNCONNECTED_21,
         SYNOPSYS_UNCONNECTED_22, SYNOPSYS_UNCONNECTED_23;
  wire   [2:0] state;
  assign pack_soc_avg[15] = lmu_count_fault;
  assign pack_soh_avg[15] = lmu_count_fault;
  assign supervisor_code[3] = lmu_count_fault;
  assign supervisor_code[4] = lmu_count_fault;
  assign allowed_current[9] = lmu_count_fault;
  assign allowed_current[10] = lmu_count_fault;
  assign allowed_current[11] = lmu_count_fault;
  assign allowed_current[12] = lmu_count_fault;
  assign allowed_current[13] = lmu_count_fault;
  assign allowed_current[14] = lmu_count_fault;
  assign allowed_current[15] = lmu_count_fault;

  bms_master_control_unit_enhanced_bms_spi_master_0 u_spi_master ( .clk(clk), 
        .rst_n(n166), .start(spi_start), .slave_sel({lmu_count_fault, 
        lmu_count_fault}), .tx_byte({spi_tx_byte_4_, lmu_count_fault, 
        lmu_count_fault, lmu_count_fault, lmu_count_fault, lmu_count_fault, 
        n141, n130}), .miso(lmu_count_fault), .done(spi_done), .rx_byte({
        SYNOPSYS_UNCONNECTED_1, SYNOPSYS_UNCONNECTED_2, SYNOPSYS_UNCONNECTED_3, 
        SYNOPSYS_UNCONNECTED_4, SYNOPSYS_UNCONNECTED_5, SYNOPSYS_UNCONNECTED_6, 
        SYNOPSYS_UNCONNECTED_7, SYNOPSYS_UNCONNECTED_8}), .sclk(spi_sclk), 
        .mosi(spi_mosi), .cs_n(spi_cs_n) );
  bms_master_control_unit_enhanced_bms_current_limit_supervisor_0 u_curr_sup ( 
        .clk(clk), .rst_n(n159), .pack_current({pack_current[15:2], 
        lmu_count_fault, lmu_count_fault}), .max_temp_seen({n98, n95, 
        max_temp_seen[9:7], n133, max_temp_seen[5:4], n101, max_temp_seen[2:0]}), .active_lmu_count({lmu_count_fault, lmu_count_fault, n213, n213}), 
        .global_fault_in(n109), .current_warn(current_warn), .current_trip(
        current_trip), .thermal_warn(thermal_warn), .thermal_trip(thermal_trip), .allowed_current({SYNOPSYS_UNCONNECTED_9, SYNOPSYS_UNCONNECTED_10, 
        SYNOPSYS_UNCONNECTED_11, SYNOPSYS_UNCONNECTED_12, 
        SYNOPSYS_UNCONNECTED_13, SYNOPSYS_UNCONNECTED_14, 
        SYNOPSYS_UNCONNECTED_15, allowed_current[8:0]}), .supervisor_code({
        supervisor_code[7:5], SYNOPSYS_UNCONNECTED_16, SYNOPSYS_UNCONNECTED_17, 
        supervisor_code[2:0]}) );
  bms_master_control_unit_enhanced_SNPS_CLOCK_GATE_HIGH_bms_master_control_unit_enhanced_0 clk_gate_max_temp_seen_reg ( 
        .CLK(clk), .EN(state[2]), .ENCLK(net893), .TE(lmu_count_fault) );
  bms_master_control_unit_enhanced_SNPS_CLOCK_GATE_HIGH_bms_master_control_unit_enhanced_2 clk_gate_spi_slave_sel_reg ( 
        .CLK(clk), .EN(n82), .ENCLK(net899), .TE(lmu_count_fault) );
  bms_master_control_unit_enhanced_SNPS_CLOCK_GATE_HIGH_bms_master_control_unit_enhanced_1 clk_gate_state_reg ( 
        .CLK(clk), .EN(n83), .ENCLK(net904), .TE(lmu_count_fault) );
  bms_master_control_unit_enhanced_bms_master_control_unit_enhanced_DP_OP_27J1_123_5989_J1_0_0 DP_OP_27J1_123_5989 ( 
        .I1(lmu0_soh), .I2(lmu1_soh), .I3(lmu2_soh), .O1({N103, N102, N101, 
        N100, N99, N98, N97, N96, N95, N94, N93, N92, N91, N90, N89, N88}) );
  bms_master_control_unit_enhanced_bms_master_control_unit_enhanced_DP_OP_26J1_122_5989_J1_0_0 DP_OP_26J1_122_5989 ( 
        .I1(lmu0_soc), .I2(lmu1_soc), .I3(lmu2_soc), .O1({N55, N54, N53, N52, 
        N51, N50, N49, N48, N47, N46, N45, N44, N43, N42, N41, N40}) );
  bms_master_control_unit_enhanced_bms_master_control_unit_enhanced_DW_cmp_J1_0_0 gte_x_5 ( 
        .A(lmu1_temp_die), .B(lmu2_temp_die), .TC(lmu_count_fault), .GE_LT(
        n213), .GE_GT_EQ(n213), .GE_LT_GT_LE(N123) );
  bms_master_control_unit_enhanced_bms_master_control_unit_enhanced_DW_cmp_J1_1_0 gte_x_4 ( 
        .A(lmu0_temp_die), .B(lmu2_temp_die), .TC(lmu_count_fault), .GE_LT(
        n213), .GE_GT_EQ(n213), .GE_LT_GT_LE(N121) );
  bms_master_control_unit_enhanced_bms_master_control_unit_enhanced_DW_cmp_J1_2_0 gte_x_3 ( 
        .A(lmu0_temp_die), .B(lmu1_temp_die), .TC(lmu_count_fault), .GE_LT(
        n213), .GE_GT_EQ(n213), .GE_LT_GT_LE(N120) );
  bms_master_control_unit_enhanced_bms_master_control_unit_enhanced_DW_div_uns_J1_0_0 div_2 ( 
        .a({N103, N102, N101, N100, N99, N98, N97, N96, N95, N94, N93, N92, 
        N91, N90, N89, N88}), .b({n213, n213}), .quotient({
        SYNOPSYS_UNCONNECTED_18, N118, N117, N116, N115, N114, N113, N112, 
        N111, N110, N109, N108, N107, N106, N105, N104}), .remainder({
        SYNOPSYS_UNCONNECTED_19, SYNOPSYS_UNCONNECTED_20}) );
  bms_master_control_unit_enhanced_bms_master_control_unit_enhanced_DW_div_uns_J1_1_0 div_1 ( 
        .a({N55, N54, N53, N52, N51, N50, N49, N48, N47, N46, N45, N44, N43, 
        N42, N41, N40}), .b({n213, n213}), .quotient({SYNOPSYS_UNCONNECTED_21, 
        N70, N69, N68, N67, N66, N65, N64, N63, N62, N61, N60, N59, N58, N57, 
        N56}), .remainder({SYNOPSYS_UNCONNECTED_22, SYNOPSYS_UNCONNECTED_23})
         );
  SAEDRVT14_FSDPRBQ_V2LP_2 global_fault_reg ( .D(N138), .SI(lmu_count_fault), 
        .SE(lmu_count_fault), .CK(net893), .RD(n179), .Q(n214) );
  SAEDRVT14_FSDPRBQ_V2LP_2 max_temp_seen_reg_3_ ( .D(N129), .SI(
        lmu_count_fault), .SE(lmu_count_fault), .CK(net893), .RD(n157), .Q(
        n220) );
  SAEDRVT14_FSDPRBQ_V2LP_2 max_temp_seen_reg_11_ ( .D(N137), .SI(
        lmu_count_fault), .SE(lmu_count_fault), .CK(net893), .RD(n169), .Q(
        n217) );
  SAEDRVT14_FSDPRBQ_V2LP_2 max_temp_seen_reg_5_ ( .D(N131), .SI(
        lmu_count_fault), .SE(lmu_count_fault), .CK(net893), .RD(n185), .Q(
        max_temp_seen[5]) );
  SAEDRVT14_FSDPRBQ_V2LP_2 poll_busy_reg ( .D(n3), .SI(lmu_count_fault), .SE(
        lmu_count_fault), .CK(clk), .RD(n173), .Q(poll_busy) );
  SAEDRVT14_FSDPRBQ_V2LP_2 max_temp_seen_reg_7_ ( .D(N133), .SI(
        lmu_count_fault), .SE(lmu_count_fault), .CK(net893), .RD(n120), .Q(
        max_temp_seen[7]) );
  SAEDRVT14_FSDPRBQ_V2LP_2 state_reg_2_ ( .D(N157), .SI(lmu_count_fault), .SE(
        lmu_count_fault), .CK(net904), .RD(n121), .Q(state[2]) );
  SAEDRVT14_FSDPRBQ_V2LP_2 pack_soh_avg_reg_0_ ( .D(N104), .SI(lmu_count_fault), .SE(lmu_count_fault), .CK(net893), .RD(n182), .Q(pack_soh_avg[0]) );
  SAEDRVT14_FSDPRBQ_V2LP_2 pack_soh_avg_reg_1_ ( .D(N105), .SI(lmu_count_fault), .SE(lmu_count_fault), .CK(net893), .RD(n172), .Q(pack_soh_avg[1]) );
  SAEDRVT14_FSDPRBQ_V2LP_2 pack_soh_avg_reg_2_ ( .D(N106), .SI(lmu_count_fault), .SE(lmu_count_fault), .CK(net893), .RD(n118), .Q(pack_soh_avg[2]) );
  SAEDRVT14_FSDPRBQ_V2LP_2 pack_soh_avg_reg_3_ ( .D(N107), .SI(lmu_count_fault), .SE(lmu_count_fault), .CK(net893), .RD(n184), .Q(pack_soh_avg[3]) );
  SAEDRVT14_FSDPRBQ_V2LP_2 pack_soh_avg_reg_4_ ( .D(N108), .SI(lmu_count_fault), .SE(lmu_count_fault), .CK(net893), .RD(rst_n), .Q(pack_soh_avg[4]) );
  SAEDRVT14_FSDPRBQ_V2LP_2 pack_soh_avg_reg_5_ ( .D(N109), .SI(lmu_count_fault), .SE(lmu_count_fault), .CK(net893), .RD(n175), .Q(pack_soh_avg[5]) );
  SAEDRVT14_FSDPRBQ_V2LP_2 pack_soh_avg_reg_6_ ( .D(N110), .SI(lmu_count_fault), .SE(lmu_count_fault), .CK(net893), .RD(n186), .Q(pack_soh_avg[6]) );
  SAEDRVT14_FSDPRBQ_V2LP_2 pack_soh_avg_reg_7_ ( .D(N111), .SI(lmu_count_fault), .SE(lmu_count_fault), .CK(net893), .RD(n171), .Q(pack_soh_avg[7]) );
  SAEDRVT14_FSDPRBQ_V2LP_2 pack_soh_avg_reg_8_ ( .D(N112), .SI(lmu_count_fault), .SE(lmu_count_fault), .CK(net893), .RD(n118), .Q(pack_soh_avg[8]) );
  SAEDRVT14_FSDPRBQ_V2LP_2 pack_soh_avg_reg_9_ ( .D(N113), .SI(lmu_count_fault), .SE(lmu_count_fault), .CK(net893), .RD(n175), .Q(pack_soh_avg[9]) );
  SAEDRVT14_FSDPRBQ_V2LP_2 pack_soh_avg_reg_10_ ( .D(N114), .SI(
        lmu_count_fault), .SE(lmu_count_fault), .CK(net893), .RD(n176), .Q(
        pack_soh_avg[10]) );
  SAEDRVT14_FSDPRBQ_V2LP_2 pack_soh_avg_reg_11_ ( .D(N115), .SI(
        lmu_count_fault), .SE(lmu_count_fault), .CK(net893), .RD(n161), .Q(
        pack_soh_avg[11]) );
  SAEDRVT14_FSDPRBQ_V2LP_2 pack_soh_avg_reg_12_ ( .D(N116), .SI(
        lmu_count_fault), .SE(lmu_count_fault), .CK(net893), .RD(n157), .Q(
        pack_soh_avg[12]) );
  SAEDRVT14_FSDPRBQ_V2LP_2 pack_soh_avg_reg_13_ ( .D(N117), .SI(
        lmu_count_fault), .SE(lmu_count_fault), .CK(net893), .RD(n121), .Q(
        pack_soh_avg[13]) );
  SAEDRVT14_FSDPRBQ_V2LP_2 pack_soh_avg_reg_14_ ( .D(N118), .SI(
        lmu_count_fault), .SE(lmu_count_fault), .CK(net893), .RD(n186), .Q(
        pack_soh_avg[14]) );
  SAEDRVT14_FSDPRBQ_V2LP_2 pack_soc_avg_reg_0_ ( .D(N56), .SI(lmu_count_fault), 
        .SE(lmu_count_fault), .CK(net893), .RD(n180), .Q(pack_soc_avg[0]) );
  SAEDRVT14_FSDPRBQ_V2LP_2 pack_soc_avg_reg_1_ ( .D(N57), .SI(lmu_count_fault), 
        .SE(lmu_count_fault), .CK(net893), .RD(n158), .Q(pack_soc_avg[1]) );
  SAEDRVT14_FSDPRBQ_V2LP_2 pack_soc_avg_reg_2_ ( .D(N58), .SI(lmu_count_fault), 
        .SE(lmu_count_fault), .CK(net893), .RD(n185), .Q(pack_soc_avg[2]) );
  SAEDRVT14_FSDPRBQ_V2LP_2 pack_soc_avg_reg_3_ ( .D(N59), .SI(lmu_count_fault), 
        .SE(lmu_count_fault), .CK(net893), .RD(n122), .Q(pack_soc_avg[3]) );
  SAEDRVT14_FSDPRBQ_V2LP_2 pack_soc_avg_reg_4_ ( .D(N60), .SI(lmu_count_fault), 
        .SE(lmu_count_fault), .CK(net893), .RD(n179), .Q(pack_soc_avg[4]) );
  SAEDRVT14_FSDPRBQ_V2LP_2 pack_soc_avg_reg_5_ ( .D(N61), .SI(lmu_count_fault), 
        .SE(lmu_count_fault), .CK(net893), .RD(n165), .Q(pack_soc_avg[5]) );
  SAEDRVT14_FSDPRBQ_V2LP_2 pack_soc_avg_reg_6_ ( .D(N62), .SI(lmu_count_fault), 
        .SE(lmu_count_fault), .CK(net893), .RD(n175), .Q(pack_soc_avg[6]) );
  SAEDRVT14_FSDPRBQ_V2LP_2 pack_soc_avg_reg_7_ ( .D(N63), .SI(lmu_count_fault), 
        .SE(lmu_count_fault), .CK(net893), .RD(n167), .Q(pack_soc_avg[7]) );
  SAEDRVT14_FSDPRBQ_V2LP_2 pack_soc_avg_reg_8_ ( .D(N64), .SI(lmu_count_fault), 
        .SE(lmu_count_fault), .CK(net893), .RD(n177), .Q(pack_soc_avg[8]) );
  SAEDRVT14_FSDPRBQ_V2LP_2 pack_soc_avg_reg_9_ ( .D(N65), .SI(lmu_count_fault), 
        .SE(lmu_count_fault), .CK(net893), .RD(n176), .Q(pack_soc_avg[9]) );
  SAEDRVT14_FSDPRBQ_V2LP_2 pack_soc_avg_reg_10_ ( .D(N66), .SI(lmu_count_fault), .SE(lmu_count_fault), .CK(net893), .RD(n163), .Q(pack_soc_avg[10]) );
  SAEDRVT14_FSDPRBQ_V2LP_2 pack_soc_avg_reg_11_ ( .D(N67), .SI(lmu_count_fault), .SE(lmu_count_fault), .CK(net893), .RD(n181), .Q(pack_soc_avg[11]) );
  SAEDRVT14_FSDPRBQ_V2LP_2 pack_soc_avg_reg_12_ ( .D(N68), .SI(lmu_count_fault), .SE(lmu_count_fault), .CK(net893), .RD(n181), .Q(pack_soc_avg[12]) );
  SAEDRVT14_FSDPRBQ_V2LP_2 pack_soc_avg_reg_13_ ( .D(N69), .SI(lmu_count_fault), .SE(lmu_count_fault), .CK(net893), .RD(n171), .Q(pack_soc_avg[13]) );
  SAEDRVT14_FSDPRBQ_V2LP_2 pack_soc_avg_reg_14_ ( .D(N70), .SI(lmu_count_fault), .SE(lmu_count_fault), .CK(net893), .RD(n165), .Q(pack_soc_avg[14]) );
  SAEDRVT14_FSDPRBQ_V2LP_2 spi_start_reg ( .D(n82), .SI(lmu_count_fault), .SE(
        lmu_count_fault), .CK(clk), .RD(n171), .Q(spi_start) );
  SAEDRVT14_FSDPRBQ_V2LP_2 spi_tx_byte_reg_4_ ( .D(n213), .SI(lmu_count_fault), 
        .SE(lmu_count_fault), .CK(net899), .RD(n168), .Q(spi_tx_byte_4_) );
  SAEDRVT14_FSDPRBQ_V2LP_2 max_temp_seen_reg_4_ ( .D(N130), .SI(
        lmu_count_fault), .SE(lmu_count_fault), .CK(net893), .RD(n116), .Q(
        max_temp_seen[4]) );
  SAEDRVT14_FSDPRBQ_V2LP_2 state_reg_0_ ( .D(N153), .SI(lmu_count_fault), .SE(
        lmu_count_fault), .CK(net904), .RD(n169), .Q(state[0]) );
  SAEDRVT14_FSDPRBQ_V2LP_2 global_fault_code_reg_3_ ( .D(n88), .SI(
        lmu_count_fault), .SE(lmu_count_fault), .CK(net893), .RD(n176), .Q(
        global_fault_code[3]) );
  SAEDRVT14_FSDPRBQ_V2LP_2 global_fault_code_reg_0_ ( .D(n85), .SI(
        lmu_count_fault), .SE(lmu_count_fault), .CK(net893), .RD(n165), .Q(
        global_fault_code[0]) );
  SAEDRVT14_FSDPRBQ_V2LP_2 global_fault_code_reg_6_ ( .D(n91), .SI(
        lmu_count_fault), .SE(lmu_count_fault), .CK(net893), .RD(n117), .Q(
        global_fault_code[6]) );
  SAEDRVT14_FSDPRBQ_V2LP_2 global_fault_code_reg_2_ ( .D(n87), .SI(
        lmu_count_fault), .SE(lmu_count_fault), .CK(net893), .RD(n161), .Q(
        global_fault_code[2]) );
  SAEDRVT14_FSDPRBQ_V2LP_2 max_temp_seen_reg_0_ ( .D(N126), .SI(
        lmu_count_fault), .SE(lmu_count_fault), .CK(net893), .RD(n173), .Q(
        max_temp_seen[0]) );
  SAEDRVT14_FSDPRBQ_V2LP_2 global_fault_code_reg_1_ ( .D(n86), .SI(
        lmu_count_fault), .SE(lmu_count_fault), .CK(net893), .RD(n182), .Q(
        global_fault_code[1]) );
  SAEDRVT14_FSDPRBQ_V2LP_2 max_temp_seen_reg_6_ ( .D(N132), .SI(
        lmu_count_fault), .SE(lmu_count_fault), .CK(net893), .RD(n162), .Q(
        n219) );
  SAEDRVT14_FSDPRBQ_V2LP_2 max_temp_seen_reg_10_ ( .D(N136), .SI(
        lmu_count_fault), .SE(lmu_count_fault), .CK(net893), .RD(n177), .Q(
        n218) );
  SAEDRVT14_FSDPRBQ_V2LP_2 global_fault_code_reg_7_ ( .D(n92), .SI(
        lmu_count_fault), .SE(lmu_count_fault), .CK(net893), .RD(n163), .Q(
        global_fault_code[7]) );
  SAEDRVT14_FSDPRBQ_V2LP_2 max_temp_seen_reg_1_ ( .D(N127), .SI(
        lmu_count_fault), .SE(lmu_count_fault), .CK(net893), .RD(n168), .Q(
        max_temp_seen[1]) );
  SAEDRVT14_FSDPRBQ_V2LP_2 max_temp_seen_reg_8_ ( .D(N134), .SI(
        lmu_count_fault), .SE(lmu_count_fault), .CK(net893), .RD(n122), .Q(
        max_temp_seen[8]) );
  SAEDRVT14_FSDPRBQ_V2LP_2 global_fault_code_reg_5_ ( .D(n90), .SI(
        lmu_count_fault), .SE(lmu_count_fault), .CK(net893), .RD(n184), .Q(
        global_fault_code[5]) );
  SAEDRVT14_FSDPRBQ_V2LP_2 max_temp_seen_reg_2_ ( .D(N128), .SI(
        lmu_count_fault), .SE(lmu_count_fault), .CK(net893), .RD(n117), .Q(
        max_temp_seen[2]) );
  SAEDRVT14_FSDPRBQ_V2LP_2 max_temp_seen_reg_9_ ( .D(N135), .SI(
        lmu_count_fault), .SE(lmu_count_fault), .CK(net893), .RD(n161), .Q(
        max_temp_seen[9]) );
  SAEDRVT14_FSDPRBQ_V2LP_2 global_fault_code_reg_4_ ( .D(n89), .SI(
        lmu_count_fault), .SE(lmu_count_fault), .CK(net893), .RD(n163), .Q(
        global_fault_code[4]) );
  SAEDRVT14_FSDPRBQ_V2LP_1 state_reg_1_ ( .D(N155), .SI(lmu_count_fault), .SE(
        lmu_count_fault), .CK(net904), .RD(n116), .Q(state[1]) );
  SAEDRVT14_FSDPRBQ_V2_1 active_lmu_id_reg_0_ ( .D(N159), .SI(lmu_count_fault), 
        .SE(lmu_count_fault), .CK(net899), .RD(n180), .Q(n216) );
  SAEDRVT14_FSDPRBQ_V2_1 active_lmu_id_reg_1_ ( .D(N161), .SI(lmu_count_fault), 
        .SE(lmu_count_fault), .CK(net899), .RD(n120), .Q(n215) );
  SAEDLVT14_TIE1_4 U117 ( .X(n213) );
  SAEDLVT14_TIE0_V1_2 U118 ( .X(lmu_count_fault) );
  SAEDRVT14_INV_0P5 U119 ( .A(n218), .X(n93) );
  SAEDRVT14_INV_0P5 U120 ( .A(n93), .X(max_temp_seen[10]) );
  SAEDRVT14_INV_0P5 U121 ( .A(n93), .X(n95) );
  SAEDRVT14_INV_0P5 U122 ( .A(n217), .X(n96) );
  SAEDRVT14_INV_0P5 U123 ( .A(n96), .X(max_temp_seen[11]) );
  SAEDRVT14_INV_0P5 U124 ( .A(n96), .X(n98) );
  SAEDRVT14_INV_0P5 U125 ( .A(n220), .X(n99) );
  SAEDRVT14_INV_0P5 U126 ( .A(n99), .X(max_temp_seen[3]) );
  SAEDRVT14_INV_0P5 U127 ( .A(n99), .X(n101) );
  SAEDRVT14_INV_0P5 U128 ( .A(n202), .X(n102) );
  SAEDRVT14_INV_0P5 U129 ( .A(n102), .X(n103) );
  SAEDRVT14_INV_0P5 U130 ( .A(n102), .X(n104) );
  SAEDRVT14_INV_0P5 U131 ( .A(n102), .X(n105) );
  SAEDRVT14_INV_0P5 U132 ( .A(n102), .X(n106) );
  SAEDRVT14_INV_0P5 U133 ( .A(n214), .X(n107) );
  SAEDRVT14_INV_0P5 U134 ( .A(n107), .X(global_fault) );
  SAEDRVT14_INV_0P5 U135 ( .A(n107), .X(n109) );
  SAEDRVT14_INV_0P5 U136 ( .A(n201), .X(n110) );
  SAEDRVT14_INV_0P5 U137 ( .A(n110), .X(n111) );
  SAEDRVT14_INV_0P5 U138 ( .A(n110), .X(n112) );
  SAEDRVT14_INV_0P5 U139 ( .A(n110), .X(n113) );
  SAEDRVT14_INV_0P5 U140 ( .A(n110), .X(n114) );
  SAEDRVT14_INV_0P5 U141 ( .A(n158), .X(n115) );
  SAEDRVT14_INV_0P5 U142 ( .A(n115), .X(n116) );
  SAEDRVT14_INV_0P5 U143 ( .A(n115), .X(n117) );
  SAEDRVT14_INV_0P5 U144 ( .A(n115), .X(n118) );
  SAEDRVT14_INV_0P5 U145 ( .A(n172), .X(n119) );
  SAEDRVT14_INV_0P5 U146 ( .A(n119), .X(n120) );
  SAEDRVT14_INV_0P5 U147 ( .A(n119), .X(n121) );
  SAEDRVT14_INV_0P5 U148 ( .A(n119), .X(n122) );
  SAEDRVT14_INV_0P5 U149 ( .A(lmu0_fault), .X(n123) );
  SAEDRVT14_INV_0P5 U150 ( .A(n123), .X(n124) );
  SAEDRVT14_INV_0P5 U151 ( .A(n123), .X(n125) );
  SAEDRVT14_INV_0P5 U152 ( .A(n123), .X(n126) );
  SAEDRVT14_INV_0P5 U153 ( .A(n123), .X(n127) );
  SAEDRVT14_INV_0P5 U154 ( .A(n216), .X(n128) );
  SAEDRVT14_INV_0P5 U155 ( .A(n128), .X(active_lmu_id[0]) );
  SAEDRVT14_INV_0P5 U156 ( .A(n128), .X(n130) );
  SAEDRVT14_INV_0P5 U157 ( .A(n219), .X(n131) );
  SAEDRVT14_INV_0P5 U158 ( .A(n131), .X(max_temp_seen[6]) );
  SAEDRVT14_INV_0P5 U159 ( .A(n131), .X(n133) );
  SAEDRVT14_INV_0P5 U160 ( .A(n138), .X(n134) );
  SAEDRVT14_INV_0P5 U161 ( .A(n134), .X(n135) );
  SAEDRVT14_INV_0P5 U162 ( .A(n134), .X(n136) );
  SAEDRVT14_INV_0P5 U163 ( .A(n134), .X(n137) );
  SAEDRVT14_INV_0P5 U164 ( .A(rst_n), .X(n138) );
  SAEDRVT14_INV_0P5 U165 ( .A(n215), .X(n139) );
  SAEDRVT14_INV_0P5 U166 ( .A(n139), .X(active_lmu_id[1]) );
  SAEDRVT14_INV_0P5 U167 ( .A(n139), .X(n141) );
  SAEDRVT14_INV_0P5 U168 ( .A(n208), .X(n142) );
  SAEDRVT14_INV_0P5 U169 ( .A(n142), .X(n143) );
  SAEDRVT14_INV_0P5 U170 ( .A(n142), .X(n144) );
  SAEDRVT14_INV_0P5 U171 ( .A(n142), .X(n145) );
  SAEDRVT14_INV_0P5 U172 ( .A(n142), .X(n146) );
  SAEDRVT14_INV_0P5 U173 ( .A(n199), .X(n147) );
  SAEDRVT14_INV_0P5 U174 ( .A(n147), .X(n148) );
  SAEDRVT14_INV_0P5 U175 ( .A(n147), .X(n149) );
  SAEDRVT14_INV_0P5 U176 ( .A(n147), .X(n150) );
  SAEDRVT14_INV_0P5 U177 ( .A(n147), .X(n151) );
  SAEDRVT14_INV_0P5 U178 ( .A(n207), .X(n152) );
  SAEDRVT14_INV_0P5 U179 ( .A(n152), .X(n153) );
  SAEDRVT14_INV_0P5 U180 ( .A(n152), .X(n154) );
  SAEDRVT14_INV_0P5 U181 ( .A(n152), .X(n155) );
  SAEDRVT14_INV_0P5 U182 ( .A(n152), .X(n156) );
  SAEDRVT14_INV_0P5 U183 ( .A(n164), .X(n157) );
  SAEDRVT14_INV_0P5 U184 ( .A(n160), .X(n158) );
  SAEDRVT14_INV_0P5 U185 ( .A(n160), .X(n159) );
  SAEDRVT14_CLKSPLT_1 U186 ( .CK(n174), .CKOUTB(n161), .CKOUT(n160) );
  SAEDRVT14_INV_0P5 U187 ( .A(n160), .X(n162) );
  SAEDRVT14_INV_0P5 U188 ( .A(n183), .X(n163) );
  SAEDRVT14_CLKSPLT_1 U189 ( .CK(n135), .CKOUTB(n165), .CKOUT(n164) );
  SAEDRVT14_INV_0P5 U190 ( .A(n164), .X(n166) );
  SAEDRVT14_INV_0P5 U191 ( .A(n164), .X(n167) );
  SAEDRVT14_INV_0P5 U192 ( .A(n170), .X(n168) );
  SAEDRVT14_INV_0P5 U193 ( .A(n138), .X(n169) );
  SAEDRVT14_CLKSPLT_1 U194 ( .CK(n136), .CKOUTB(n171), .CKOUT(n170) );
  SAEDRVT14_INV_0P5 U195 ( .A(n170), .X(n172) );
  SAEDRVT14_INV_0P5 U196 ( .A(n183), .X(n173) );
  SAEDRVT14_CLKSPLT_1 U197 ( .CK(n137), .CKOUTB(n175), .CKOUT(n174) );
  SAEDRVT14_INV_0P5 U198 ( .A(n174), .X(n176) );
  SAEDRVT14_INV_0P5 U199 ( .A(n178), .X(n177) );
  SAEDRVT14_INV_0P5 U200 ( .A(n175), .X(n178) );
  SAEDRVT14_INV_0P5 U201 ( .A(n178), .X(n179) );
  SAEDRVT14_INV_0P5 U202 ( .A(n178), .X(n180) );
  SAEDRVT14_INV_0P5 U203 ( .A(n178), .X(n181) );
  SAEDRVT14_INV_0P5 U204 ( .A(n178), .X(n182) );
  SAEDRVT14_INV_0P5 U205 ( .A(rst_n), .X(n183) );
  SAEDRVT14_INV_0P5 U206 ( .A(n183), .X(n184) );
  SAEDRVT14_INV_0P5 U207 ( .A(n183), .X(n185) );
  SAEDRVT14_INV_0P5 U208 ( .A(n183), .X(n186) );
  SAEDRVT14_ND2_ECO_1 U209 ( .A1(start_poll), .A2(n211), .X(n205) );
  SAEDRVT14_ND2_MM_0P5 U210 ( .A1(N120), .A2(N121), .X(n198) );
  SAEDRVT14_INV_0P5 U211 ( .A(n198), .X(n199) );
  SAEDRVT14_AN2_0P5 U212 ( .A1(N123), .A2(n198), .X(n207) );
  SAEDRVT14_AN2_0P5 U213 ( .A1(n206), .A2(lmu2_fault), .X(n201) );
  SAEDRVT14_NR2_1 U214 ( .A1(lmu1_fault), .A2(n124), .X(n206) );
  SAEDRVT14_AN2_0P5 U215 ( .A1(state[1]), .A2(N153), .X(N161) );
  SAEDRVT14_ND2_CDC_1 U216 ( .A1(state[1]), .A2(state[0]), .X(n200) );
  SAEDRVT14_NR2_1 U217 ( .A1(state[2]), .A2(n200), .X(N157) );
  SAEDRVT14_NR2_1 U218 ( .A1(state[2]), .A2(state[0]), .X(N153) );
  SAEDRVT14_INV_0P5 U219 ( .A(state[1]), .X(n211) );
  SAEDRVT14_INV_0P5 U220 ( .A(state[0]), .X(n210) );
  SAEDRVT14_AOI21_0P5 U221 ( .A1(n211), .A2(n210), .B(state[2]), .X(n209) );
  SAEDRVT14_AN3_0P5 U222 ( .A1(start_poll), .A2(N153), .A3(n211), .X(n212) );
  SAEDRVT14_AO21_U_0P5 U223 ( .A1(n209), .A2(poll_busy), .B(n212), .X(n3) );
  SAEDRVT14_AN2B_MM_1 U224 ( .B(lmu1_fault), .A(n125), .X(n202) );
  SAEDRVT14_AO222_1 U225 ( .A1(n124), .A2(lmu0_fault_code[7]), .B1(
        lmu2_fault_code[7]), .B2(n111), .C1(n103), .C2(lmu1_fault_code[7]), 
        .X(n92) );
  SAEDRVT14_AO222_1 U226 ( .A1(n127), .A2(lmu0_fault_code[1]), .B1(n106), .B2(
        lmu1_fault_code[1]), .C1(n114), .C2(lmu2_fault_code[1]), .X(n86) );
  SAEDRVT14_AO222_1 U227 ( .A1(n126), .A2(lmu0_fault_code[5]), .B1(n105), .B2(
        lmu1_fault_code[5]), .C1(n112), .C2(lmu2_fault_code[5]), .X(n90) );
  SAEDRVT14_AO222_1 U228 ( .A1(n124), .A2(lmu0_fault_code[0]), .B1(n104), .B2(
        lmu1_fault_code[0]), .C1(n112), .C2(lmu2_fault_code[0]), .X(n85) );
  SAEDRVT14_AO222_1 U229 ( .A1(n125), .A2(lmu0_fault_code[6]), .B1(n106), .B2(
        lmu1_fault_code[6]), .C1(n113), .C2(lmu2_fault_code[6]), .X(n91) );
  SAEDRVT14_AO222_1 U230 ( .A1(n126), .A2(lmu0_fault_code[3]), .B1(n104), .B2(
        lmu1_fault_code[3]), .C1(n113), .C2(lmu2_fault_code[3]), .X(n88) );
  SAEDRVT14_AO222_1 U231 ( .A1(n127), .A2(lmu0_fault_code[4]), .B1(n103), .B2(
        lmu1_fault_code[4]), .C1(n111), .C2(lmu2_fault_code[4]), .X(n89) );
  SAEDRVT14_AO222_1 U232 ( .A1(n125), .A2(lmu0_fault_code[2]), .B1(n105), .B2(
        lmu1_fault_code[2]), .C1(n114), .C2(lmu2_fault_code[2]), .X(n87) );
  SAEDRVT14_ND2_CDC_1 U233 ( .A1(n211), .A2(n210), .X(n203) );
  SAEDRVT14_AOI21_0P5 U234 ( .A1(spi_done), .A2(n203), .B(state[2]), .X(n204)
         );
  SAEDRVT14_OAI21_0P5 U235 ( .A1(state[0]), .A2(n205), .B(n204), .X(n83) );
  SAEDRVT14_NR2_1 U236 ( .A1(n148), .A2(N123), .X(n208) );
  SAEDRVT14_AO222_1 U237 ( .A1(n149), .A2(lmu0_temp_die[0]), .B1(n156), .B2(
        lmu1_temp_die[0]), .C1(n143), .C2(lmu2_temp_die[0]), .X(N126) );
  SAEDRVT14_NR3_0P5 U238 ( .A1(n210), .A2(state[1]), .A3(state[2]), .X(N159)
         );
  SAEDRVT14_ND2B_U_0P5 U239 ( .A(lmu2_fault), .B(n206), .X(N138) );
  SAEDRVT14_AO222_1 U240 ( .A1(n149), .A2(lmu0_temp_die[1]), .B1(n143), .B2(
        lmu2_temp_die[1]), .C1(lmu1_temp_die[1]), .C2(n156), .X(N127) );
  SAEDRVT14_AO222_1 U241 ( .A1(n151), .A2(lmu0_temp_die[2]), .B1(n145), .B2(
        lmu2_temp_die[2]), .C1(lmu1_temp_die[2]), .C2(n153), .X(N128) );
  SAEDRVT14_AO222_1 U242 ( .A1(n151), .A2(lmu0_temp_die[3]), .B1(n146), .B2(
        lmu2_temp_die[3]), .C1(lmu1_temp_die[3]), .C2(n154), .X(N129) );
  SAEDRVT14_AO222_1 U243 ( .A1(n148), .A2(lmu0_temp_die[4]), .B1(n146), .B2(
        lmu2_temp_die[4]), .C1(lmu1_temp_die[4]), .C2(n154), .X(N130) );
  SAEDRVT14_AO222_1 U244 ( .A1(n148), .A2(lmu0_temp_die[5]), .B1(n144), .B2(
        lmu2_temp_die[5]), .C1(lmu1_temp_die[5]), .C2(n155), .X(N131) );
  SAEDRVT14_AO222_1 U245 ( .A1(n150), .A2(lmu0_temp_die[6]), .B1(n144), .B2(
        lmu2_temp_die[6]), .C1(lmu1_temp_die[6]), .C2(n156), .X(N132) );
  SAEDRVT14_AO222_1 U246 ( .A1(n150), .A2(lmu0_temp_die[7]), .B1(n146), .B2(
        lmu2_temp_die[7]), .C1(lmu1_temp_die[7]), .C2(n155), .X(N133) );
  SAEDRVT14_AO222_1 U247 ( .A1(n150), .A2(lmu0_temp_die[8]), .B1(n144), .B2(
        lmu2_temp_die[8]), .C1(lmu1_temp_die[8]), .C2(n155), .X(N134) );
  SAEDRVT14_AO222_1 U248 ( .A1(n151), .A2(lmu0_temp_die[9]), .B1(n143), .B2(
        lmu2_temp_die[9]), .C1(lmu1_temp_die[9]), .C2(n153), .X(N135) );
  SAEDRVT14_AO222_1 U249 ( .A1(n149), .A2(lmu0_temp_die[10]), .B1(n145), .B2(
        lmu2_temp_die[10]), .C1(lmu1_temp_die[10]), .C2(n154), .X(N136) );
  SAEDRVT14_AO222_1 U250 ( .A1(n148), .A2(lmu0_temp_die[11]), .B1(n145), .B2(
        lmu2_temp_die[11]), .C1(lmu1_temp_die[11]), .C2(n153), .X(N137) );
  SAEDRVT14_OA21_1 U251 ( .A1(n211), .A2(n210), .B(n209), .X(N155) );
  SAEDRVT14_AO21_U_0P5 U252 ( .A1(N155), .A2(spi_done), .B(n212), .X(n82) );
endmodule

