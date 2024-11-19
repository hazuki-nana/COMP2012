`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/12 12:36:10
// Design Name: 
// Module Name: LED
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


module LED(
    input wire clk,rst,we,
    input wire [31:0] addr_to_led,
    input wire [23:0] wdata_from_bridge,
    output reg [23:0] data_past
    );
    
    always@(posedge clk or posedge rst)begin
        if(rst) data_past <= 0;
        else data_past <= wdata_from_bridge;
    end

endmodule

