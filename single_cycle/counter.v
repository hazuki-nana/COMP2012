`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/12 12:44:09
// Design Name: 
// Module Name: counter
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


module counter(
    input wire clk,
    input wire rst,
    input wire button,
    input wire [29:0] cnt_max,
    output reg [29:0] cnt
);


reg       cnt_inc;

wire rst_n = ~rst;
wire cnt_end = cnt_inc & (cnt==cnt_max);


always @ (posedge clk or negedge rst_n) begin
    if(~rst_n)   cnt_inc <= 1'b0;          
    else if(button) cnt_inc <= 1'b1;       

end

always @ (posedge clk or negedge rst_n) begin
    if(~rst_n)       cnt <= 30'd0;          
    else if(cnt_end) cnt <= 30'd0;       
    else if(cnt_inc) cnt <= cnt + 30'd1; 
end
endmodule
