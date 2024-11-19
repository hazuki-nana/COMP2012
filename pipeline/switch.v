`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/12 14:31:33
// Design Name: 
// Module Name: switch
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


module switch(
    input wire clk,rst,
    input wire [31:0] addr_to_sw,
    input wire [23:0] sw,
    output wire [31:0] rdata_from_sw
    );
    
    assign rdata_from_sw = rst?0:{8'b0,sw};
endmodule
