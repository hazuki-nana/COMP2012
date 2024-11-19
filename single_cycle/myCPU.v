`timescale 1ns / 1ps

`include "defines.vh"

module myCPU (
    input  wire         cpu_rst,
    input  wire         cpu_clk,

    // Interface to IROM
`ifdef RUN_TRACE
    output wire [15:0]  inst_addr,
`else
    output wire [13:0]  inst_addr,
`endif
    input  wire [31:0]  inst,
    
    // Interface to Bridge
    output wire [31:0]  Bus_addr,
    input  wire [31:0]  Bus_rdata,
    output wire         Bus_we,
    output wire [31:0]  Bus_wdata

`ifdef RUN_TRACE
    ,// Debug Interface
    output wire         debug_wb_have_inst,
    output wire [31:0]  debug_wb_pc,
    output              debug_wb_ena,
    output wire [ 4:0]  debug_wb_reg,
    output wire [31:0]  debug_wb_value
`endif
);

    // TODO: 完成你自己的单周期CPU设计
    wire [31:0] PC_pc;
    wire [31:0] NPC_npc;
    wire [31:0] NPC_pc4;
    wire [31:0] IROM_inst;
    wire [31:0] RF_rD1;
    wire [31:0] RF_rD2;
    wire [31:0] RF_rd;
    wire [31:0] SEXT_ext;
    wire [31:0] ALU_C;
    wire ALU_f;
    
    wire [1:0] Ctrl_rf_we;
    wire [1:0] rf_wsel;
    wire [1:0] ram_we;
    wire [1:0] npc_op;
    wire [2:0] sext_op;
    wire [3:0] Ctrl_alu_op;
    wire       Ctrl_alu_asel;
    wire [1:0] Ctrl_alu_bsel;
    wire [1:0] Ctrl_ram_we;
    wire [2:0] Ctrl_ram_rsel;
    
    wire [31:0] offset;
    wire npc_sel;
    wire [31:0] data_from_dram;
    wire [31:0] data_to_dram;
    
    
    PC U_PC (
        .rst        (cpu_rst),              // input  wire
        .clk        (cpu_clk),              // input  wire
        .din        (NPC_npc),              // input  wire [31:0]
        .pc         (PC_pc)                 // output reg  [31:0]
    );
    
    NPC U_NPC (
        .pc         (PC_pc),                // input  wire [31:0]
        .offset(npc_sel?ALU_C:SEXT_ext),
        .br(ALU_f),
        .op(npc_op),
        .npc        (NPC_npc),              // output wire [31:0]
        .pc4(NPC_pc4)
    );
    
    //irom
    assign inst_addr = PC_pc[15:2];
    assign IROM_inst = inst;
    
    
    RF U_RF (
        .clk        (cpu_clk),              // input  wire

        .rR1        (IROM_inst[9:5]),     // input  wire [ 4:0]
        .rD1        (RF_rD1),               // output reg  [31:0]
        
        .rR2        (IROM_inst[14:10]),     // input  wire [ 4:0]
        .rD2        (RF_rD2),               // output reg  [31:0]
        
        .we         (Ctrl_rf_we),           // input  wire
        .wR         (IROM_inst[4:0]),      // input  wire [ 4:0]
        .rd(RF_rd),
        .wD         (rf_wsel[1]?(rf_wsel[0]?NPC_pc4:SEXT_ext):(rf_wsel[0]?data_from_dram:ALU_C))                 // input  wire [31:0]
    );
    
    SEXT U_SEXT (
        .din        (IROM_inst[25:0]),  // 
        .op (sext_op),
        .ext        (SEXT_ext)              // output wire [31:0]
    );
    
    ALU U_ALU (
        .op         (Ctrl_alu_op),          // input  wire [ 0:0]
        .A          (Ctrl_alu_asel?PC_pc:RF_rD1),               // input  wire [31:0]
        .B          (Ctrl_alu_bsel[1] ? RF_rd :(Ctrl_alu_bsel[0]? SEXT_ext:RF_rD2)),     // input  wire [31:0]
        .C          (ALU_C),             // output wire [31:0]
        .f(ALU_f)
    );
    
    //bridge
    assign Bus_we = (|Ctrl_ram_we);
    assign Bus_addr = {ALU_C[31:2],2'b0};
    assign Bus_wdata = data_to_dram;
    
    LO_SA_DRAM U_LSD(
        .Ctrl_ram_we(Ctrl_ram_we),
        .Ctrl_ram_rsel(Ctrl_ram_rsel),
        .ALU_C(ALU_C),
        .Bus_rdata(Bus_rdata),
        .RF_rd(RF_rd),
        .data_to_dram(data_to_dram),
        .data_from_dram(data_from_dram)
    );
    
   
    
    CTRL U_Ctrl (
        .opcode     (IROM_inst[31:15]),       // input  wire [6:0]
        .npc_op(npc_op),
        .npc_sel(npc_sel),
        .rf_we      (Ctrl_rf_we),           // output wire
        .rf_wsel(rf_wsel),
        .sext_op(sext_op),
        .alu_op     (Ctrl_alu_op),          // output wire
        .alu_asel   (Ctrl_alu_asel),        // output wire
        .alu_bsel(Ctrl_alu_bsel),
        .ram_we     (Ctrl_ram_we),           // output wire
        .ram_rsel(Ctrl_ram_rsel)
    );
    
    reg [31:0] pc_past;
    reg rf_we_past;
    reg [4:0] wb_reg_past;
    reg [31:0] wb_data_past;
    always@(posedge cpu_clk or posedge cpu_rst)begin
        if(cpu_rst)begin
            pc_past <= 0;
            rf_we_past <= 0;
            wb_reg_past <= 0;
            wb_data_past <= 0;
        end
        else begin
            pc_past <= PC_pc;
            rf_we_past <= |Ctrl_rf_we;
            wb_reg_past <= IROM_inst[4:0];
            wb_data_past <=(rf_wsel[1]?(rf_wsel[0]?NPC_pc4:SEXT_ext):(rf_wsel[0]?data_from_dram:ALU_C));
        end
    end
    
    //

`ifdef RUN_TRACE
    // Debug Interface
    assign debug_wb_have_inst = 1;
    assign debug_wb_pc        = pc_past;//给上一条指令的pc
    assign debug_wb_ena       = rf_we_past;
    assign debug_wb_reg       = wb_reg_past;
    assign debug_wb_value     = wb_data_past;
`endif

endmodule
