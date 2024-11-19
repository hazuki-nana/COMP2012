`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/15 21:12:10
// Design Name: 
// Module Name: FOR
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module FOR(
    input wire in_alu_asel,wire [1:0] in_alu_bsel,
    input wire[4:0] rR1,rR2,
    input wire[4:0] EX_MEM_wR,MEM_WB_wR,
    input wire[1:0] EX_MEM_rf_we, MEM_WB_rf_we,
    input wire [4:0] ID_EX_wR,
    input wire [1:0] ID_EX_ram_we, EX_MEM_ram_we,
    
    output reg [1:0] out_alu_asel,reg [2:0] out_alu_bsel,
    output reg EX_to_dram_sel,MEM_to_dram_sel
    );
    
    wire EX_hazard01 = (|EX_MEM_rf_we) && (EX_MEM_wR != 0) && (rR1 == EX_MEM_wR) && (in_alu_asel == 0);
    wire EX_hazard02 = (|EX_MEM_rf_we) && (EX_MEM_wR != 0) && (rR2 == EX_MEM_wR) && (in_alu_bsel == 0);
    wire MEM_hazard01 = (|MEM_WB_rf_we) && (MEM_WB_wR != 0) && (rR1 == MEM_WB_wR) && (in_alu_asel == 0);
    wire MEM_hazard02 = (|MEM_WB_rf_we) && (MEM_WB_wR != 0) && (rR2 == MEM_WB_wR) && (in_alu_bsel == 0);
    
    wire STORE_hazard01 = (|MEM_WB_rf_we) && (|ID_EX_ram_we) && (MEM_WB_wR != 0) && (ID_EX_wR == MEM_WB_wR);
    wire STORE_hazard02 = (|MEM_WB_rf_we) && (|EX_MEM_ram_we) && (MEM_WB_wR != 0) && (EX_MEM_wR == MEM_WB_wR);
    
    wire LVRD_hazard_EX = (|EX_MEM_rf_we) && (EX_MEM_wR != 0) && (ID_EX_wR == EX_MEM_wR) && (in_alu_bsel == 2'b10);
    wire LVRD_hazard_MEM = (|MEM_WB_rf_we) && (MEM_WB_wR != 0) && (ID_EX_wR == MEM_WB_wR) && (in_alu_bsel == 2'b10);
    
    always@(*)begin
        if(EX_hazard01)
            out_alu_asel = 2'b10;
        else if (MEM_hazard01)
            out_alu_asel = 2'b11;
        else
            out_alu_asel = {1'b0,in_alu_asel};
    end
    
    always@(*)begin
        if(EX_hazard02 | LVRD_hazard_EX)
            out_alu_bsel = 3'b011;
        else if (MEM_hazard02 | LVRD_hazard_MEM)
            out_alu_bsel = 3'b100;
        else 
            out_alu_bsel = {1'b0,in_alu_bsel};
    end
    
    always@(*)begin
        if(STORE_hazard01) EX_to_dram_sel = 1;
        else EX_to_dram_sel = 0;
        if(STORE_hazard02) MEM_to_dram_sel = 1;
        else MEM_to_dram_sel = 0;
    end
    
endmodule
