`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/11 20:48:35
// Design Name: 
// Module Name: d_filp_flop
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



module d_flip_flop(
    input wire clk,en,
    input wire [31:0] data,
    output reg [31:0] q
);
    always @(posedge clk) begin
        if (en)  q<=data;
    end
endmodule
