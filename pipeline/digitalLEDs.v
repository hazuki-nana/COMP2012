`timescale 1ns / 1ps
module digitalLEDs #(
    parameter END=200000-1
)(
    input wire rst_to_dig,
    input wire clk_to_dig,
    input  wire [31:0] addr_to_dig,
    input wire we_to_dig,
    input wire [31:0] wdata_to_dig,
    output wire [7:0] dig_en,
    output wire [7:0] dig_cx
    );
    
    reg [31:0] dig_content;
    
    always @(*) begin
        if (rst_to_dig) dig_content = 32'b0;
        else if(we_to_dig) dig_content = wdata_to_dig;
    end
    

    wire [7:0] dk[7:0];
    led_driver #(END) u_led_driver(
                        .clk(clk_to_dig), 
                        .reset(rst_to_dig), 
                        .dk7(dk[7]), 
                        .dk6(dk[6]), 
                        .dk5(dk[5]), 
                        .dk4(dk[4]), 
                        .dk3(dk[3]), 
                        .dk2(dk[2]), 
                        .dk1(dk[1]), 
                        .dk0(dk[0]), 
                        .led_en(dig_en), 
                        .led_cx(dig_cx));
    
    translate u_translate(
                    .clk(clk_to_dig),
                    .reset(rst_to_dig),
                    .ens(8'b00000000),
                    .show_content(dig_content),
                    .dk0(dk[0]),
                    .dk1(dk[1]),
                    .dk2(dk[2]),
                    .dk3(dk[3]),
                    .dk4(dk[4]),
                    .dk5(dk[5]),
                    .dk6(dk[6]),
                    .dk7(dk[7]));

endmodule