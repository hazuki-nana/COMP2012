`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/11 20:33:08
// Design Name: 
// Module Name: RF
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


module RF(
    input wire clk,
    input wire [4:0] rR1,rR2,wR, 
    input wire [1:0] we, 
    input wire [31:0] wD,
    output wire [31:0] rD1,rD2,rd
    );
    
    
    reg [31:0] reg32s[0:31];
    assign rD1 = reg32s[rR1];
    assign rD2 = reg32s[rR2];
    assign rd = reg32s[wR];
    
    integer i;
    initial begin
        for (i = 0; i < 32; i = i + 1) begin
            reg32s[i] = 32'b0; // 对数组的每个元素赋值
        end
    end

    always @(posedge clk) begin
        if (&we) reg32s[1] <= wD;
        if (|we && wR != 5'b0) reg32s[wR] <= wD;
    end

endmodule
