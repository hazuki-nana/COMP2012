`timescale 1ns / 1ps

`include "defines.vh"

module miniLA_SoC (
    input  wire         fpga_rst,   // High active
    input  wire         fpga_clk,

    input  wire [23:0]  sw,
    input  wire [ 4:0]  button,
    output wire [ 7:0]  dig_en,
    output wire         DN_A,
    output wire         DN_B,
    output wire         DN_C,
    output wire         DN_D,
    output wire         DN_E,
    output wire         DN_F,
    output wire         DN_G,
    output wire         DN_DP,
    output wire [23:0]  led

`ifdef RUN_TRACE
    ,// Debug Interface
    output wire         debug_wb_have_inst, // 当前时钟周期是否有指令写回 (对单周期CPU，可在复位后恒置1)
    output wire [31:0]  debug_wb_pc,        // 当前写回的指令的PC (若wb_have_inst=0，此项可为任意值)
    output              debug_wb_ena,       // 指令写回时，寄存器堆的写使能 (若wb_have_inst=0，此项可为任意值)
    output wire [ 4:0]  debug_wb_reg,       // 指令写回时，写入的寄存器号 (若wb_ena或wb_have_inst=0，此项可为任意值)
    output wire [31:0]  debug_wb_value      // 指令写回时，写入寄存器的值 (若wb_ena或wb_have_inst=0，此项可为任意值)
`endif
);

    wire        pll_lock;
    wire        pll_clk;
    wire        cpu_clk;

    // Interface between CPU and IROM
`ifdef RUN_TRACE
    wire [15:0] inst_addr;
`else
    wire [13:0] inst_addr;
`endif
    wire [31:0] inst;

    // Interface between CPU and Bridge
    wire [31:0] Bus_rdata;
    wire [31:0] Bus_addr;
    wire        Bus_we;
    wire [31:0] Bus_wdata;
    
    // Interface between bridge and DRAM
    // wire         rst_bridge2dram;
    wire         clk_bridge2dram;
    wire [31:0]  addr_bridge2dram;
    wire [31:0]  rdata_dram2bridge;
    wire         we_bridge2dram;
    wire [31:0]  wdata_bridge2dram;
    
    // Interface between bridge and peripherals
    // TODO: 在此定义总线桥与外设I/O接口电路模块的连接信号
    wire rst_to_dig;
    wire clk_bridge2dig;
    wire [31:0] addr_bridge2dig;
    wire we_bridge2dig;
    wire [31:0] wdata_bridge2dig;
    
    wire rst_to_led;
    wire clk_bridge2led;
    wire [31:0] addr_bridge2led;
    wire we_bridge2led;
    wire [31:0] wdata_bridge2led;
    
    wire rst_to_sw;
    wire clk_bridge2sw;
    wire [31:0] addr_bridge2sw;
    wire [31:0] rdata_bridge2sw;
    
    wire rst_to_btn;
    wire clk_bridge2btn;
    wire [31:0] addr_bridge2btn;
    wire [31:0] rdata_bridge2btn;
    //
    

    
`ifdef RUN_TRACE
    // Trace调试时，直接使用外部输入时钟
    assign cpu_clk = fpga_clk;
`else
    // 下板时，使用PLL分频后的时钟
    assign cpu_clk = pll_clk & pll_lock;
    cpuclk Clkgen (
        // .resetn     (!fpga_rst),
        .clk_in1    (fpga_clk),
        .clk_out1   (pll_clk),
        .locked     (pll_lock)
    );
`endif
    
    myCPU Core_cpu (
        .cpu_rst            (fpga_rst),
        .cpu_clk            (cpu_clk),

        // Interface to IROM
        .inst_addr          (inst_addr),
        .inst               (inst),

        // Interface to Bridge
        .Bus_addr           (Bus_addr),
        .Bus_rdata          (Bus_rdata),
        .Bus_we             (Bus_we),
        .Bus_wdata          (Bus_wdata)

`ifdef RUN_TRACE
        ,// Debug Interface
        .debug_wb_have_inst (debug_wb_have_inst),
        .debug_wb_pc        (debug_wb_pc),
        .debug_wb_ena       (debug_wb_ena),
        .debug_wb_reg       (debug_wb_reg),
        .debug_wb_value     (debug_wb_value)
`endif
    );
    
    IROM Mem_IROM (
        .a          (inst_addr),
        .spo        (inst)
    );
    
    Bridge Bridge (       
        // Interface to CPU
        .rst_from_cpu       (fpga_rst),
        .clk_from_cpu       (cpu_clk),
        .addr_from_cpu      (Bus_addr),
        .we_from_cpu        (Bus_we),
        .wdata_from_cpu     (Bus_wdata),
        .rdata_to_cpu       (Bus_rdata),
        
        // Interface to DRAM
        // .rst_to_dram    (rst_bridge2dram),
        .clk_to_dram        (clk_bridge2dram),
        .addr_to_dram       (addr_bridge2dram),
        .rdata_from_dram    (rdata_dram2bridge),
        .we_to_dram         (we_bridge2dram),
        .wdata_to_dram      (wdata_bridge2dram),
        
        // Interface to digs
        .rst_to_dig         (rst_to_dig),
        .clk_to_dig         (clk_bridge2dig),
        .addr_to_dig        (addr_bridge2dig),
        .we_to_dig          (we_bridge2dig),
        .wdata_to_dig       (wdata_bridge2dig),

        // Interface to LEDs
        .rst_to_led         (rst_to_led),
        .clk_to_led         (clk_bridge2led),
        .addr_to_led        (addr_bridge2led),
        .we_to_led          (we_bridge2led),
        .wdata_to_led       (wdata_bridge2led),

        // Interface to switches
        .rst_to_sw          (rst_to_sw),
        .clk_to_sw          (clk_bridge2sw),
        .addr_to_sw         (addr_bridge2sw),
        .rdata_from_sw      (rdata_bridge2sw),

        // Interface to buttons
        .rst_to_btn         (rst_to_btn),
        .clk_to_btn         (clk_bridge2btn),
        .addr_to_btn        (addr_bridge2btn),
        .rdata_from_btn     (rdata_bridge2btn)
    );

    DRAM Mem_DRAM (
        .clk        (clk_bridge2dram),
        .a          (addr_bridge2dram[15:2]),
        .spo        (rdata_dram2bridge),
        .we         (we_bridge2dram),
        .d          (wdata_bridge2dram)
    );
    
    // TODO: 在此实例化你的外设I/O接口电路模块
    
    DIG U_dig(
        .clk(clk_bridge2dig),
        .s1(rst_to_dig),
        .data_from_bridge2(wdata_bridge2dig),
        .addr_to_dig(addr_bridge2dig),
        .we_to_dig(we_bridge2dig),
        .sel(dig_en),
        .seg({DN_DP,DN_G,DN_F,DN_E,DN_D,DN_C,DN_B,DN_A})
    );
    
    LED U_led(
        .clk(clk_bridge2led),
        .rst(rst_to_led),
        .addr_to_led(addr_bridge2led),
        .we(we_bridge2led),
        .wdata_from_bridge(wdata_bridge2led),
        .data_past(led)
    );

//    digitalLEDs u(
//         .rst_to_dig(rst_to_dig),
//        .clk_to_dig(clk_bridge2dig),
//    .addr_to_dig(addr_bridge2dig),
//    .we_to_dig(we_bridge2dig),
//    .wdata_to_dig(wdata_bridge2dig),
//    .dig_en(dig_en),
//   .dig_cx(({DN_DP,DN_G,DN_F,DN_E,DN_D,DN_C,DN_B,DN_A}))
//    );
    
    switch U_switch(
        .clk(clk_bridge2btn),
        .rst(rst_to_sw),
        .addr_to_sw(addr_bridge2sw),
        .sw(sw),
        .rdata_from_sw(rdata_bridge2sw)
    );
    
    button U_button(
        .rst        (rst_to_btn),
        .clk         (clk_bridge2btn),
        .addr_to_btn        (addr_bridge2btn),
        .button(button),
        .rdata_to_bridge     (rdata_bridge2btn)
    );
    //


endmodule
