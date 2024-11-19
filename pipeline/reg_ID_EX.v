`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/15 18:30:04
// Design Name: 
// Module Name: reg_ID_EX
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


module reg_ID_EX(
    input wire clk,rst,flush,
    input wire [31:0] in_pc,in_pc4,in_ext,
    input wire [31:0] in_rD1,in_rD2,in_rd,
    input wire [3:0] in_alu_op,
    input wire in_alu_asel,wire [1:0]in_alu_bsel,
    input wire [4:0] in_rR1,in_rR2,in_wR,
    input wire [2:0] in_ram_rsel,wire [1:0] in_ram_we,
    input wire [1:0] in_rf_we,in_rf_wsel,
    input wire [1:0] in_npc_op,wire in_npc_sel,
    input wire in_flag,
    
    output reg [31:0] out_pc,out_pc4,out_ext,
    output reg [4:0] out_rR1,out_rR2,out_wR,
    output reg [31:0] out_rD1,out_rD2,out_rd,
    output reg [3:0] out_alu_op,
    output reg out_alu_asel, reg [1:0]out_alu_bsel,
    output reg [2:0] out_ram_rsel,reg [1:0] out_ram_we,
    output reg [1:0] out_rf_we,out_rf_wsel,
    output reg [1:0] out_npc_op,reg out_npc_sel,
    output reg out_flag
    );
    
    always@(posedge clk or posedge rst)begin
        if(rst)begin
            out_pc <= 0;
            out_pc4 <= 0;
            out_ext <= 0;
            
            out_rR1 <= 0;
            out_rR2 <= 0;
            out_wR <= 0;
            
            out_rD1 <= 0;
            out_rD2 <= 0;
            out_rd <= 0;
            
            out_alu_op <= 0;
            out_alu_asel <= 0;
            out_alu_bsel <= 0;
            
            out_ram_rsel <= 0;
            out_ram_we <= 0;
            
            out_rf_we <= 0;
            out_rf_wsel <= 0;
            
            out_npc_op <= 0;
            out_npc_sel <= 0;
            
            out_flag <= 0;
        end
        else if(flush)begin
            out_rf_we <= 0;
            out_ram_we <= 0;
            out_flag <= 0;
            out_npc_op <= 0;
        end
        else begin
            out_pc <= in_pc;
            out_pc4 <= in_pc4;
            out_ext <= in_ext;
            
            out_rR1 <= in_rR1;
            out_rR2 <= in_rR2;
            out_wR <= in_wR;
            
            out_rD1 <= in_rD1;
            out_rD2 <= in_rD2;
            out_rd <= in_rd;
            
            out_alu_op <= in_alu_op;
            out_alu_asel <= in_alu_asel;
            out_alu_bsel <= in_alu_bsel;
            
            out_ram_rsel <= in_ram_rsel;
            out_ram_we <= in_ram_we;
            
            out_rf_we <= in_rf_we;
            out_rf_wsel <= in_rf_wsel;
            
            out_npc_op <= in_npc_op;
            out_npc_sel <= in_npc_sel;
            out_flag <= in_flag;
        end
    end
    
endmodule
