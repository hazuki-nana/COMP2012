`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/11 19:31:35
// Design Name: 
// Module Name: PC
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


module PC(
    input wire clk,
    input wire rst,
    input wire [31:0] din,
    output reg [31:0] pc
    );
    
always@(posedge clk or posedge rst) begin
    if(rst) pc <= -4;//-4£¿
    else pc <= din;
end

endmodule
