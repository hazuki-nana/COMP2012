`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/11 19:37:20
// Design Name: 
// Module Name: NPC
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


module NPC(
    input wire [31:0] pc,
    input wire [31:0] offset,
    input wire br,
    input wire [1:0] op,
    output reg [31:0] npc,
    output wire [31:0] pc4
    );
    
assign pc4 = pc + 4;
always@(*) begin
    if(op == 0) npc = pc4;
    else if(op == 1)begin
        if(br) npc = pc + offset;
        else npc = pc4;
    end 
    else if(op == 2)begin
        npc = offset;
    end
    else npc = pc + offset;
end
endmodule
