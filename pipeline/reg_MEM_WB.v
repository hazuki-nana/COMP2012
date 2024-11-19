`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/15 23:33:38
// Design Name: 
// Module Name: reg_MEM_WB
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


module reg_MEM_WB(
    input wire clk,rst,
    input wire [1:0] in_rf_we,
    input wire [31:0] ram_wD,
    input wire [4:0] in_wR,
    input wire [31:0] in_pc,
    input wire in_flag,
    
    
    output reg [1:0] out_rf_we,
    output reg [31:0] MEM_WB_wD,
    output reg [4:0] out_wR,
    output reg [31:0] out_pc,
    output reg out_flag
    );
     always@(posedge clk or posedge rst)begin
        if(rst)begin
            out_rf_we <= 0;
            MEM_WB_wD <= 0;
            out_wR <= 0;
            out_pc <= 0;
            out_flag <= 0;
        end
        else begin
            out_rf_we <= in_rf_we;
            MEM_WB_wD <= ram_wD;
            out_wR <= in_wR;
            out_pc <= in_pc;
            out_flag <= in_flag;
            
        end
    end
endmodule
