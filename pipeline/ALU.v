`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/11 22:32:52
// Design Name: 
// Module Name: ALU
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


module ALU(
    input  wire [3:0] op,      
    input  wire [31:0] A,
    input  wire [31:0] B,
    output reg [31:0] C,
    output reg f
    );
    
    reg com_res = 0;
    always@(*)begin
        f = 0;
        case(op)
            4'b0000:C = A + B;
            4'b0001:C = A + (~B + 1'b1);
            4'b0010:C = A & B;
            4'b0011:C = A | B;
            4'b0100:C = A ^ B;
            4'b0101:C = A << B[4:0];
            4'b0110:C = A >> B[4:0];
            4'b0111:C = $signed(A) >>> B[4:0];
            4'b1001:begin C = {31'b0,A < B}; f = (A < B);end
            4'b1000:begin
                case (A[31])
                    1'b1: begin
                        if (B[31] == 1'b0)
                            com_res = 1;
                        else
                            com_res = (A[30:0] < B[30:0]);
                    end
                    1'b0: begin
                        if (B[31] == 1'b1)
                            com_res = 0;
                        else
                            com_res = (A[30:0] < B[30:0]);
                    end
                    default: com_res = 0;
                endcase
                C = {31'b0,com_res};
                f = com_res;
            end 
            4'b1010:begin C = {31'b0,A == B}; f = (A == B); end
            4'b1011:begin C = {31'b0,~(A == B)}; f =  ~(A == B); end
            4'b1101:begin C = {31'b0,A >= B}; f = (A >= B); end
            4'b1100:begin
                case (A[31])
                    1'b1: begin
                        if (B[31] == 1'b0)
                            com_res = 0;
                        else
                            com_res = (A[30:0] >= B[30:0]);
                    end
                    1'b0: begin
                        if (B[31] == 1'b1)
                            com_res = 1;
                        else
                            com_res = (A[30:0] >= B[30:0]);
                    end
                    default: com_res = 0;
                endcase
                C = {31'b0,com_res};
                f = com_res;
             end
         endcase
    end
    
    
endmodule
