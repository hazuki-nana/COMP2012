`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/13 14:30:55
// Design Name: 
// Module Name: button
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


module button#(
    parameter [29:0] led_time=30'd1000000
)(
    input wire clk,rst,
    input wire [4:0] button,
    input wire [31:0] addr_to_btn,
    output wire [31:0] rdata_to_bridge    
);

    reg [7:0] count = 8'b0;
    wire [7:0] bcd;
    wire [29:0] cnt; 
    reg flag=1'b1;
    reg [4:0] prev_button;
    wire [4:0] button_posedge = (~prev_button) & button;  
    counter aoco_inst(
        .clk(clk),
        .rst(rst|flag),
        .button(1'b1),
        .cnt_max(led_time-1),
        .cnt(cnt)
    );
    
    assign rdata_to_bridge = {27'b0,button_posedge};
    
    always @(posedge clk, posedge rst) begin
        if (rst == 1) prev_button <= 0;
        else prev_button <= button;
    end
    
    always @(posedge clk or posedge rst) begin
        if ((cnt==led_time-1) || rst)begin flag<=1'b1;end
    end

endmodule
