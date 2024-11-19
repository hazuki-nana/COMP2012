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
               4'd0  : seg  =  8'b1100_0000;    //显示数字0
               4'd1  : seg  =  8'b1111_1001;    //显示数字1
               4'd2  : seg  =  8'b1010_0100;    //显示数字2
               4'd3  : seg  =  8'b1011_0000;    //显示数字3
               4'd4  : seg  =  8'b1001_1001;    //显示数字4
               4'd5  : seg  =  8'b1001_0010;    //显示数字5
               4'd6  : seg  =  8'b1000_0010;    //显示数字6
               4'd7  : seg  =  8'b1111_1000;    //显示数字7
               4'd8  : seg  =  8'b1000_0000;    //显示数字8
               4'd9  : seg  =  8'b1001_0000;    //显示数字9
               default:seg  =  8'b1111_1111;
           endcase
    end
endmodule

