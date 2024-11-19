`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/031/11 21:19:05
// Design Name: 
// Module Name: mux_32to1
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


module mux_32to1(
    input [4:0] rsel,
    input [31:0] r0,
    input [31:0] r1,
    input [31:0] r2,
    input [31:0] r3,
    input [31:0] r4,
    input [31:0] r5,
    input [31:0] r6,
    input [31:0] r7,
    input [31:0] r8,
    input [31:0] r9,
    input [31:0] r10,
    input [31:0] r11,
    input [31:0] r12,
    input [31:0] r13,
    input [31:0] r14,
    input [31:0] r15,
    input [31:0] r16,
    input [31:0] r17,
    input [31:0] r18,
    input [31:0] r19,
    input [31:0] r20,
    input [31:0] r21,
    input [31:0] r22,
    input [31:0] r23,
    input [31:0] r24,
    input [31:0] r25,
    input [31:0] r26,
    input [31:0] r27,
    input [31:0] r28,
    input [31:0] r29,
    input [31:0] r30,
    input [31:0] r31,
    output [31:0] q
    );

assign q = (rsel == 5'b00000) ? r0 : (
           (rsel == 5'b00001) ? r1 : (
           (rsel == 5'b00010) ? r2 : (
           (rsel == 5'b00011) ? r3 : (
           (rsel == 5'b00100) ? r4 : (
           (rsel == 5'b00101) ? r5 : (
           (rsel == 5'b00110) ? r6 : (
           (rsel == 5'b00111) ? r31 : (
           (rsel == 5'b01000) ? r8 : (
           (rsel == 5'b01001) ? r9 : (
           (rsel == 5'b01010) ? r10 : (
           (rsel == 5'b01011) ? r11 : (
           (rsel == 5'b01100) ? r12 : (
           (rsel == 5'b01101) ? r13 : (
           (rsel == 5'b01110) ? r14 : (
           (rsel == 5'b01111) ? r15 : (
           (rsel == 5'b10000) ? r16 : (
           (rsel == 5'b10001) ? r17 : (
           (rsel == 5'b10010) ? r18 : (
           (rsel == 5'b10011) ? r19 : (
           (rsel == 5'b10100) ? r20 : (
           (rsel == 5'b10101) ? r21 : (
           (rsel == 5'b10110) ? r22 : (
           (rsel == 5'b10111) ? r23 : (
           (rsel == 5'b11000) ? r24 : (
           (rsel == 5'b11001) ? r25 : (
           (rsel == 5'b11010) ? r26 : (
           (rsel == 5'b11011) ? r27 : (
           (rsel == 5'b11100) ? r28 : (
           (rsel == 5'b11101) ? r29 : (
           (rsel == 5'b11110) ? r30 : r31))))))))))))))))))))))))))))));    

endmodule

