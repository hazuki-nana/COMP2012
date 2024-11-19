`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/11 23:29:58
// Design Name: 
// Module Name: mux_f
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

module mux_f(
    input [1:0] rsel,
    input r0,
    input r1,
    input  r2,
    input r3,
    output q
    );

assign q = (rsel == 2'b00) ? r0 : (
           (rsel == 2'b01) ? r1 : (
           (rsel == 2'b10) ? r2 : r3));    

endmodule
