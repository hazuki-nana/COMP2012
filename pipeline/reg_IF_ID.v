`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/15 14:34:49
// Design Name: 
// Module Name: reg_IF_ID
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


module reg_IF_ID(
    input wire clk,rst,flush,
    input wire [31:0] in_pc,in_pc4,in_inst,
    output reg [31:0] out_pc,out_pc4,out_inst,
    output reg flag
    );
    
    always@(posedge clk or posedge rst)begin
        if(rst | flush)begin
            out_pc <= 0;
            out_pc4 <= 0;
            out_inst <= 0;
            flag <= 0;
        end
        else begin
            out_pc <= in_pc;
            out_pc4 <= in_pc4;
            out_inst <= in_inst;
            flag <= 1;
        end
    end
    
endmodule
