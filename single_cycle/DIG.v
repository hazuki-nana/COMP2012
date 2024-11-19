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


module DIG#(
    parameter [29:0] led_time =30'd200000
)(
    input wire clk,s1,
    input wire [31:0] data_from_bridge2,addr_to_dig,
    input wire we_to_dig,
    output reg [7:0] sel,
    output reg [7:0] seg
    );

reg [31:0] data_past;

wire [3:0] cntc;
wire [29:0] cnt;
reg flag;
reg [3:0] cnt_sel;
reg [7:0] sel_reg;
wire [7:0] led1;
wire [7:0] led2;
wire [7:0] led3;
wire [7:0] led4;
wire [7:0] led5;
wire [7:0] led6;
wire [7:0] led7;
wire [7:0] led8;
wire rst = ~s1;
assign cntc=cnt_sel;
counter cou_inst(
    .clk(clk),
    .rst(s1),
    .button(1'b1),
    .cnt_max(led_time),
    .cnt(cnt)
);

always@(posedge clk or posedge s1)begin
    if(s1) data_past <= 0;
    else if (we_to_dig) data_past <= data_from_bridge2;
end

always @(posedge clk or posedge s1)begin
    if (s1) flag<=1'b0;
    else if (cnt==led_time) flag<=1'b1;
    else flag<=1'b0;
end

always @(posedge clk or posedge s1)begin
    if (s1) cnt_sel<=4'b0;
    else if ((cnt_sel==4'd8)&&(flag==1'b1)) cnt_sel<=4'b0;
    else if (flag==1'b1) cnt_sel<=cnt_sel+4'b1;
    else cnt_sel<=cnt_sel;
end 

always @(posedge clk or posedge s1)begin
    if (s1) sel_reg<=8'b0;
    else if ((cnt_sel==4'b0)&&(flag==1'b1)) sel_reg<=8'b1;
    else if (flag) sel_reg<=sel_reg<<1;
    else sel_reg<=sel_reg;
end

always @(posedge clk or posedge s1)begin
    if (s1) sel<=8'b0;
    else sel<=~sel_reg;
end

always @(posedge clk or posedge s1)begin
    if (s1) seg<=8'b0;
    else
        case(cnt_sel)
            4'd1:seg<=led1;
            4'd2:seg<=led2;
            4'd3:seg<=led3;
            4'd4:seg<=led4;
            4'd5:seg<=led5;
            4'd6:seg<=led6;
            4'd7:seg<=led7;
            4'd8:seg<=led8;
        endcase
end

seven_segment_display disp1(
    .data(data_past[3:0]),
    .seg(led1)
);
seven_segment_display disp2(
    .data(data_past[7:4]),
    .seg(led2)
);
seven_segment_display disp3(
    .data(data_past[11:8]),
    .seg(led3)
);
seven_segment_display disp4(
    .data(data_past[15:12]),
    .seg(led4)
);
seven_segment_display disp5(
    .data(data_past[19:16]),
    .seg(led5)
);
seven_segment_display disp6(
    .data(data_past[23:20]),
    .seg(led6)
);
seven_segment_display disp7(
    .data(data_past[27:24]),
    .seg(led7)
);
seven_segment_display disp8(
    .data(data_past[31:28]),
    .seg(led8)
);

endmodule

