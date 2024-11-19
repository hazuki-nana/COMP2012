`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/13 19:27:30
// Design Name: 
// Module Name: LO_SA_DRAM
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


module LO_SA_DRAM(
    input wire [1:0] Ctrl_ram_we,
    input  wire [2:0] Ctrl_ram_rsel,
    input wire [31:0] Bus_rdata,RF_rd,
    input wire [31:0] ALU_C,
    output reg [31:0] data_to_dram,data_from_dram
    );
    
    always@(*)begin
        if(ALU_C[1:0] == 2'b00)
            if(Ctrl_ram_we == 2'b01) data_to_dram = {Bus_rdata[31:8],RF_rd[7:0]};
            else if (Ctrl_ram_we == 2'b10) data_to_dram = {Bus_rdata[31:16],RF_rd[15:0]};
            else if (Ctrl_ram_we == 2'b11) data_to_dram = RF_rd;
            else data_to_dram = Bus_rdata;
        else if(ALU_C[1:0] == 2'b01)
            if(Ctrl_ram_we == 2'b01) data_to_dram = {Bus_rdata[31:16],RF_rd[7:0],Bus_rdata[7:0]};
            else data_to_dram = Bus_rdata;
        else if(ALU_C[1:0] == 2'b10)
            if(Ctrl_ram_we == 2'b01) data_to_dram = {Bus_rdata[31:24],RF_rd[7:0],Bus_rdata[15:0]};
            else if (Ctrl_ram_we == 2'b10) data_to_dram = {RF_rd[15:0],Bus_rdata[15:0]};
            else data_to_dram = Bus_rdata;
        else
            if(Ctrl_ram_we == 2'b01) data_to_dram = {RF_rd[7:0],Bus_rdata[23:0]};
            else data_to_dram = Bus_rdata;
    end
    always@(*)begin
        if(ALU_C[1:0] == 2'b00)
            if(Ctrl_ram_rsel == 3'b000) data_from_dram = {{24{Bus_rdata[7]}},Bus_rdata[7:0]};
            else if (Ctrl_ram_rsel == 3'b001) data_from_dram = {24'b0,Bus_rdata[7:0]};
            else if (Ctrl_ram_rsel == 3'b010) data_from_dram = {{16{Bus_rdata[15]}},Bus_rdata[15:0]};
            else if (Ctrl_ram_rsel == 3'b011) data_from_dram = {16'b0,Bus_rdata[15:0]};
            else data_from_dram = Bus_rdata;
        else if(ALU_C[1:0] == 2'b01)
            if(Ctrl_ram_rsel == 3'b000) data_from_dram = {{24{Bus_rdata[15]}},Bus_rdata[15:8]};
            else if (Ctrl_ram_rsel == 3'b001) data_from_dram = {24'b0,Bus_rdata[15:8]};
            else data_from_dram = Bus_rdata;
        else if(ALU_C[1:0] == 2'b10)
            if(Ctrl_ram_rsel == 3'b000) data_from_dram = {{24{Bus_rdata[23]}},Bus_rdata[23:16]};
            else if (Ctrl_ram_rsel == 3'b001) data_from_dram = {24'b0,Bus_rdata[23:16]};
            else if (Ctrl_ram_rsel == 3'b010) data_from_dram = {{16{Bus_rdata[31]}},Bus_rdata[31:16]};
            else if (Ctrl_ram_rsel == 3'b011) data_from_dram = {16'b0,Bus_rdata[31:16]};
            else data_from_dram = Bus_rdata;
        else 
            if(Ctrl_ram_rsel == 3'b000) data_from_dram = {{24{Bus_rdata[31]}},Bus_rdata[31:24]};
            else if (Ctrl_ram_rsel == 3'b001) data_from_dram = {24'b0,Bus_rdata[31:24]};
            else data_from_dram = Bus_rdata;
    end
endmodule
