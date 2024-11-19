`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/11 21:47:18
// Design Name: 
// Module Name: SEXT
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


module SEXT(
    input  wire [25:0] din,
    input wire [2:0] op,
    output wire [31:0] ext
    );
    reg [31:0] u_ext;
    assign ext = u_ext;   
    always@(*)begin
        if(op == 3'b000) u_ext = {26'b0,din[14:10]};
        else if(op == 3'b001) u_ext = {{20{din[21]}},din[21:10]};
        else if(op == 3'b010) u_ext = {20'b0,din[21:10]};
        else if(op == 3'b011) u_ext = din[24:5]<<12;
        else if (op == 3'b100) u_ext = {{14{din[25]}},din[25:10],2'b0};
        else if (op == 3'b101) u_ext = {{6{din[9]}},din[9:0],din[25:10],2'b0};
        else u_ext = 0;
    end
    
endmodule
