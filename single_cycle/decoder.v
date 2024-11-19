`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/11 20:52:49
// Design Name: 
// Module Name: decoder
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


module decoder(
    input wire [4:0] wsel,
    input wire eno,
    output reg [31:0] eni
);
always @(*) begin
    eni=31'b0;
    if (eno) begin
        case (wsel)
            5'b00000:eni[0]=1'b1;
            5'b00001:eni[1]=1'b1; 
            5'b00010:eni[2]=1'b1;
            5'b00011:eni[3]=1'b1;
            5'b00100:eni[4]=1'b1;
            5'b00101:eni[5]=1'b1;
            5'b00110:eni[6]=1'b1;
            5'b00111:eni[7]=1'b1; 
            5'b01000:eni[8]=1'b1;
            5'b01001:eni[9]=1'b1;
            5'b01010:eni[10]=1'b1;
            5'b01011:eni[11]=1'b1;
            5'b01100:eni[12]=1'b1;
            5'b01101:eni[13]=1'b1;
            5'b01110:eni[14]=1'b1;
            5'b01111:eni[15]=1'b1;
            5'b10000:eni[16]=1'b1;
            5'b10001:eni[17]=1'b1;
            5'b10010:eni[18]=1'b1;
            5'b10011:eni[19]=1'b1;
            5'b10100:eni[20]=1'b1;
            5'b10101:eni[21]=1'b1;
            5'b10110:eni[22]=1'b1;
            5'b10111:eni[23]=1'b1;
            5'b11000:eni[24]=1'b1;
            5'b11001:eni[25]=1'b1;
            5'b11010:eni[26]=1'b1;
            5'b11011:eni[27]=1'b1;
            5'b11100:eni[28]=1'b1;
            5'b11101:eni[29]=1'b1;
            5'b11110:eni[30]=1'b1;
            5'b11111:eni[31]=1'b1;
        endcase
        end
end
endmodule 
