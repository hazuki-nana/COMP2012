`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/11 23:25:43
// Design Name: 
// Module Name: mux_4to1
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

module mux_4to1(
    input [1:0] rsel,
    input [31:0] r0,
    input [31:0] r1,
    input [31:0] r2,
    input [31:0] r3,
    output [31:0] q
    );

assign q = (rsel == 2'b00) ? r0 : (
           (rsel == 2'b01) ? r1 : (
           (rsel == 2'b10) ? r2 : r3));    

endmodule
