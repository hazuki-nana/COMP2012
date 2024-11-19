`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/12 01:45:47
// Design Name: 
// Module Name: CTRL
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


module CTRL(
    input wire [31:15] opcode,
    output reg [1:0] npc_op,
    output reg npc_sel,
    output reg [1:0] rf_we,
    output reg [1:0] rf_wsel,
    output reg [2:0] sext_op,
    output reg [3:0] alu_op,
    output reg alu_asel,
    output reg [1:0] alu_bsel,
    output reg [1:0] ram_we,
    output reg [2:0] ram_rsel
    );
    
    always@(*)begin
        if(opcode[31:26] == 6'b010101)begin
            {npc_op,npc_sel,rf_we,rf_wsel,sext_op,alu_op,alu_asel,alu_bsel,ram_we,ram_rsel} = 
            {22'b1101111101000000000000};
        end
        else if(opcode[31:26] == 6'b010100)begin
            {npc_op,npc_sel,rf_we,rf_wsel,sext_op,alu_op,alu_asel,alu_bsel,ram_we,ram_rsel} = 
            {22'b1100000101000000000000};
        end
        else if(opcode[31:26] == 6'b010011)begin
            {npc_op,npc_sel,rf_we,rf_wsel,sext_op,alu_op,alu_asel,alu_bsel,ram_we,ram_rsel} = 
            {22'b1011011100000000100000};
        end
        else if(opcode[31:26] == 6'b011011)begin
            {npc_op,npc_sel,rf_we,rf_wsel,sext_op,alu_op,alu_asel,alu_bsel,ram_we,ram_rsel} = 
            {22'b0100000100110101000000};
        end
        else if(opcode[31:26] == 6'b011001)begin
            {npc_op,npc_sel,rf_we,rf_wsel,sext_op,alu_op,alu_asel,alu_bsel,ram_we,ram_rsel} = 
            {22'b0100000100110001000000};
        end
        else if(opcode[31:26] == 6'b011010)begin
            {npc_op,npc_sel,rf_we,rf_wsel,sext_op,alu_op,alu_asel,alu_bsel,ram_we,ram_rsel} = 
            {22'b0100000100100101000000};
        end
        else if(opcode[31:26] == 6'b011000)begin
            {npc_op,npc_sel,rf_we,rf_wsel,sext_op,alu_op,alu_asel,alu_bsel,ram_we,ram_rsel} = 
            {22'b0100000100100001000000};
        end
        else if(opcode[31:26] == 6'b010111)begin
            {npc_op,npc_sel,rf_we,rf_wsel,sext_op,alu_op,alu_asel,alu_bsel,ram_we,ram_rsel} = 
            {22'b0100000100101101000000};
        end
        else if(opcode[31:26] == 6'b010110)begin
            {npc_op,npc_sel,rf_we,rf_wsel,sext_op,alu_op,alu_asel,alu_bsel,ram_we,ram_rsel} = 
            {22'b0100000100101001000000};
        end
        else if(opcode[31:25] == 7'b0001110)begin
            {npc_op,npc_sel,rf_we,rf_wsel,sext_op,alu_op,alu_asel,alu_bsel,ram_we,ram_rsel} = 
            {22'b0001000011000010100000};
        end
        else if(opcode[31:25] == 7'b0001010)begin
            {npc_op,npc_sel,rf_we,rf_wsel,sext_op,alu_op,alu_asel,alu_bsel,ram_we,ram_rsel} = 
            {22'b0001010011000000000000};
        end 
        else if(opcode[31:22] == 10'b0010100110)begin
            {npc_op,npc_sel,rf_we,rf_wsel,sext_op,alu_op,alu_asel,alu_bsel,ram_we,ram_rsel} = 
            {22'b0000000001000000111000};
        end
        else if(opcode[31:22] == 10'b0010100101)begin
            {npc_op,npc_sel,rf_we,rf_wsel,sext_op,alu_op,alu_asel,alu_bsel,ram_we,ram_rsel} = 
            {22'b0000000001000000110000};
        end
        else if(opcode[31:22] == 10'b0010100100)begin
            {npc_op,npc_sel,rf_we,rf_wsel,sext_op,alu_op,alu_asel,alu_bsel,ram_we,ram_rsel} = 
            {22'b0000000001000000101000};
        end
        else if(opcode[31:22] == 10'b0010100010)begin
            {npc_op,npc_sel,rf_we,rf_wsel,sext_op,alu_op,alu_asel,alu_bsel,ram_we,ram_rsel} = 
            {22'b0001001001000000100100};
        end
        else if(opcode[31:22] == 10'b0010101001)begin
            {npc_op,npc_sel,rf_we,rf_wsel,sext_op,alu_op,alu_asel,alu_bsel,ram_we,ram_rsel} = 
            {22'b0001001001000000100011};
        end
        else if(opcode[31:22] == 10'b0010100001)begin
            {npc_op,npc_sel,rf_we,rf_wsel,sext_op,alu_op,alu_asel,alu_bsel,ram_we,ram_rsel} = 
            {22'b0001001001000000100010};
        end
        else if(opcode[31:22] == 10'b0010101000)begin
            {npc_op,npc_sel,rf_we,rf_wsel,sext_op,alu_op,alu_asel,alu_bsel,ram_we,ram_rsel} = 
            {22'b0001001001000000100001};
        end
        else if(opcode[31:22] == 10'b0010100000)begin
            {npc_op,npc_sel,rf_we,rf_wsel,sext_op,alu_op,alu_asel,alu_bsel,ram_we,ram_rsel} = 
            {22'b0001001001000000100000};
        end
        else if(opcode[31:22] == 10'b0000001001)begin
            {npc_op,npc_sel,rf_we,rf_wsel,sext_op,alu_op,alu_asel,alu_bsel,ram_we,ram_rsel} = 
            {22'b0001000001100100100000};
        end
        else if(opcode[31:22] == 10'b0000001000)begin
            {npc_op,npc_sel,rf_we,rf_wsel,sext_op,alu_op,alu_asel,alu_bsel,ram_we,ram_rsel} = 
            {22'b0001000001100000100000};
        end
        else if(opcode[31:22] == 10'b0000001111)begin
            {npc_op,npc_sel,rf_we,rf_wsel,sext_op,alu_op,alu_asel,alu_bsel,ram_we,ram_rsel} = 
            {22'b0001000010010000100000};
        end
        else if(opcode[31:22] == 10'b0000001110)begin
            {npc_op,npc_sel,rf_we,rf_wsel,sext_op,alu_op,alu_asel,alu_bsel,ram_we,ram_rsel} = 
            {22'b0001000010001100100000};
        end
        else if(opcode[31:22] == 10'b0000001101)begin
            {npc_op,npc_sel,rf_we,rf_wsel,sext_op,alu_op,alu_asel,alu_bsel,ram_we,ram_rsel} = 
            {22'b0001000010001000100000};
        end
        else if(opcode[31:22] == 10'b0000001010)begin
            {npc_op,npc_sel,rf_we,rf_wsel,sext_op,alu_op,alu_asel,alu_bsel,ram_we,ram_rsel} = 
            {22'b0001000001000000100000};
        end
        else if(opcode[31:15] == 17'b00000000010010001)begin
            {npc_op,npc_sel,rf_we,rf_wsel,sext_op,alu_op,alu_asel,alu_bsel,ram_we,ram_rsel} = 
            {22'b0001000000011100100000};
        end
        else if(opcode[31:15] == 17'b00000000010001001)begin
            {npc_op,npc_sel,rf_we,rf_wsel,sext_op,alu_op,alu_asel,alu_bsel,ram_we,ram_rsel} = 
            {22'b0001000000011000100000};
        end
        else if(opcode[31:15] == 17'b00000000010000001)begin
            {npc_op,npc_sel,rf_we,rf_wsel,sext_op,alu_op,alu_asel,alu_bsel,ram_we,ram_rsel} = 
            {22'b0001000000010100100000};
        end
        else if(opcode[31:15] == 17'b00000000000100101)begin
            {npc_op,npc_sel,rf_we,rf_wsel,sext_op,alu_op,alu_asel,alu_bsel,ram_we,ram_rsel} = 
            {22'b0001000000100100000000};
        end
        else if(opcode[31:15] == 17'b00000000000100100)begin
            {npc_op,npc_sel,rf_we,rf_wsel,sext_op,alu_op,alu_asel,alu_bsel,ram_we,ram_rsel} = 
            {22'b0001000000100000000000};
        end
        else if(opcode[31:15] == 17'b00000000000110000)begin
            {npc_op,npc_sel,rf_we,rf_wsel,sext_op,alu_op,alu_asel,alu_bsel,ram_we,ram_rsel} = 
            {22'b0001000000011100000000};
        end
        else if(opcode[31:15] == 17'b00000000000101111)begin
            {npc_op,npc_sel,rf_we,rf_wsel,sext_op,alu_op,alu_asel,alu_bsel,ram_we,ram_rsel} = 
            {22'b0001000000011000000000};
        end
        else if(opcode[31:15] == 17'b00000000000101110)begin
            {npc_op,npc_sel,rf_we,rf_wsel,sext_op,alu_op,alu_asel,alu_bsel,ram_we,ram_rsel} = 
            {22'b0001000000010100000000};
        end
        else if(opcode[31:15] == 17'b00000000000101011)begin
            {npc_op,npc_sel,rf_we,rf_wsel,sext_op,alu_op,alu_asel,alu_bsel,ram_we,ram_rsel} = 
            {22'b0001000000010000000000};
        end
        else if(opcode[31:15] == 17'b00000000000101010)begin
            {npc_op,npc_sel,rf_we,rf_wsel,sext_op,alu_op,alu_asel,alu_bsel,ram_we,ram_rsel} = 
            {22'b0001000000001100000000};
        end
        else if(opcode[31:15] == 17'b00000000000101001)begin
            {npc_op,npc_sel,rf_we,rf_wsel,sext_op,alu_op,alu_asel,alu_bsel,ram_we,ram_rsel} = 
            {22'b0001000000001000000000};
        end
        else if(opcode[31:15] == 17'b00000000000100010)begin
            {npc_op,npc_sel,rf_we,rf_wsel,sext_op,alu_op,alu_asel,alu_bsel,ram_we,ram_rsel} = 
            {22'b0001000000000100000000};
        end
        else if(opcode[31:15] == 17'b00000000000100000) begin
            {npc_op,npc_sel,rf_we,rf_wsel,sext_op,alu_op,alu_asel,alu_bsel,ram_we,ram_rsel} = 
            {22'b0001000000000000000000};
        end
        else {npc_op,npc_sel,rf_we,rf_wsel,sext_op,alu_op,alu_asel,alu_bsel,ram_we,ram_rsel} = 
            {22'b0};
    end
endmodule
