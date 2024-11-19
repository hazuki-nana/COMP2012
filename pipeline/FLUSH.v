`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/15 22:23:36
// Design Name: 
// Module Name: FLUSH
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


module FLUSH(
    input wire ALU_f,
    input [1:0] npc_op,
    output wire flush,
    output reg pc_sel
    );
    
    assign flush = (npc_op == 2'b01 && ALU_f == 1'b1) || (npc_op == 2'b10) || (npc_op == 2'b11);
    always@(*)begin
        if(npc_op == 2'b01)
            if(ALU_f) pc_sel = 1;
            else pc_sel = 0;
        else if(npc_op == 2'b11)
            pc_sel = 1;
        else pc_sel = 0;
    end
    
endmodule
