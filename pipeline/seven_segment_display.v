`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/12 12:40:07
// Design Name: 
// Module Name: seven_segment_display
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


module seven_segment_display(
    input wire [3:0] data,
    output reg [7:0] seg
);
always @(*)
    begin
       case(data)
               4'd0  : seg  =  8'b1100_0000;    //��ʾ����0
               4'd1  : seg  =  8'b1111_1001;    //��ʾ����1
               4'd2  : seg  =  8'b1010_0100;    //��ʾ����2
               4'd3  : seg  =  8'b1011_0000;    //��ʾ����3
               4'd4  : seg  =  8'b1001_1001;    //��ʾ����4
               4'd5  : seg  =  8'b1001_0010;    //��ʾ����5
               4'd6  : seg  =  8'b1000_0010;    //��ʾ����6
               4'd7  : seg  =  8'b1111_1000;    //��ʾ����7
               4'd8  : seg  =  8'b1000_0000;    //��ʾ����8
               4'd9  : seg  =  8'b1001_0000;    //��ʾ����9
               default:seg  =  8'b1111_1111;
           endcase
    end
endmodule

