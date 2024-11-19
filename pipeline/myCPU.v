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
    
    //pipeline
    wire flush;
    wire pc_sel;
    
    wire [31:0] IF_ID_pc,IF_ID_pc4,IF_ID_inst;
    
    wire [31:0] ID_EX_pc,ID_EX_pc4,ID_EX_ext;
    wire [4:0] ID_EX_rR1,ID_EX_rR2,ID_EX_wR;
    wire [31:0] ID_EX_rD1,ID_EX_rD2,ID_EX_rd;
    wire [3:0] ID_EX_alu_op;
    wire ID_EX_alu_asel;wire [1:0]ID_EX_alu_bsel;
    wire [2:0] ID_EX_ram_rsel;wire [1:0] ID_EX_ram_we;
    wire [1:0] ID_EX_rf_we,ID_EX_rf_wsel;
    wire [1:0] ID_EX_npc_op; wire ID_EX_npc_sel;
    
    wire [31:0] EX_MEM_pc,EX_MEM_pc4,EX_MEM_ext;
    wire [4:0] EX_MEM_wR; wire [31:0]EX_MEM_rd;
    wire [2:0] EX_MEM_ram_rsel;wire [1:0] EX_MEM_ram_we;
    wire [1:0] EX_MEM_rf_we,EX_MEM_rf_wsel;
    wire [1:0] EX_MEM_npc_op;wire EX_MEM_npc_sel;
    wire [31:0] EX_MEM_ALU_C;wire EX_MEM_ALU_f;
    
    wire [31:0] MEM_wD;
    
    wire [1:0] MEM_WB_rf_we;
    wire [31:0] MEM_WB_wD;
    wire [4:0] MEM_WB_wR;
    wire [31:0] MEM_WB_pc;
    
    //标志位
     wire IF_ID_flag,ID_EX_flag,EX_MEM_flag,MEM_WB_flag;
    
    
    //前递
    wire [1:0] for_alu_asel;
    wire[2:0] for_alu_bsel; 
    wire EX_to_dram_sel, MEM_to_dram_sel;
    FOR U_for(
        .in_alu_asel(ID_EX_alu_asel),
        .in_alu_bsel(ID_EX_alu_bsel),
        .rR1(ID_EX_rR1),
        .rR2(ID_EX_rR2),
        .EX_MEM_wR(EX_MEM_wR),
        .MEM_WB_wR(MEM_WB_wR),
        .EX_MEM_rf_we(EX_MEM_rf_we),
        .MEM_WB_rf_we(MEM_WB_rf_we),
        .ID_EX_wR(ID_EX_wR),
        .ID_EX_ram_we(ID_EX_ram_we),
        .EX_MEM_ram_we(EX_MEM_ram_we),
        
        .out_alu_asel(for_alu_asel),
        .out_alu_bsel(for_alu_bsel),
        .EX_to_dram_sel(EX_to_dram_sel),
        .MEM_to_dram_sel(MEM_to_dram_sel)
    );
    
    ///IF
    PC U_PC (
        .rst        (cpu_rst),              // input  wire
        .clk        (cpu_clk),              // input  wire
        .din        (NPC_npc),              // input  wire [31:0]
        .pc         (PC_pc)                 // output reg  [31:0]
    );
    
    
    NPC U_NPC (
        .pc         (pc_sel?EX_MEM_pc:PC_pc),                // input  wire [31:0]
        .offset(EX_MEM_npc_sel?EX_MEM_ALU_C:EX_MEM_ext),
        .br(EX_MEM_ALU_f),
        .op(EX_MEM_npc_op),
        .npc        (NPC_npc),              // output wire [31:0]
        .pc4(NPC_pc4)
    );
    
    //irom
    assign inst_addr = PC_pc[15:2];
    assign IROM_inst = inst;
    
    
    
    reg_IF_ID U_ID(
        .clk(cpu_clk),
        .rst(cpu_rst),
        .flush(flush),
        .in_pc(PC_pc),
        .in_inst(IROM_inst),
        .in_pc4(NPC_pc4),
        .out_pc(IF_ID_pc),
        .out_pc4(IF_ID_pc4),
        .out_inst(IF_ID_inst),
        .flag(IF_ID_flag)
    );
    
    ///ID
    CTRL U_Ctrl (
        .opcode     (IF_ID_inst[31:15]),       // input  wire [6:0]
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
    
    RF U_RF (
        .clk        (cpu_clk),              // input  wire

        .rR1        (IF_ID_inst[9:5]),     // input  wire [ 4:0]
        .rD1        (RF_rD1),               // output reg  [31:0]
        
        .rR2        (IF_ID_inst[14:10]),     // input  wire [ 4:0]
        .rD2        (RF_rD2),               // output reg  [31:0]
        
        .rRD(IF_ID_inst[4:0]),
        .rd(RF_rd), // input  wire [ 4:0]
        
        .we         (EX_MEM_rf_we),           // input  wire
        .wR         (EX_MEM_wR),      //?
        
        .wD         (MEM_wD)                 // input  wire [31:0]
    );
    
    SEXT U_SEXT (
        .din        (IF_ID_inst[25:0]),  // 
        .op (sext_op),
        .ext        (SEXT_ext)              // output wire [31:0]
    );
    
    
    reg_ID_EX U_IE(
        .clk(cpu_clk),
        .rst(cpu_rst),
        .flush(flush),
        .in_pc(IF_ID_pc),
        .in_pc4(IF_ID_pc4),
        .in_ext(SEXT_ext),
        .in_rR1(IF_ID_inst[9:5]),
        .in_rR2(IF_ID_inst[14:10]),
        .in_wR(IF_ID_inst[4:0]),
        .in_rD1(RF_rD1),
        .in_rD2(RF_rD2),
        .in_rd(RF_rd),
        .in_alu_op(Ctrl_alu_op),
        .in_alu_asel(Ctrl_alu_asel),
        .in_alu_bsel(Ctrl_alu_bsel),
        .in_ram_rsel(Ctrl_ram_rsel),
        .in_ram_we(Ctrl_ram_we),
        .in_rf_we(Ctrl_rf_we),
        .in_rf_wsel(rf_wsel),
        .in_npc_op(npc_op),
        .in_npc_sel(npc_sel),
        .in_flag(IF_ID_flag),
        
        .out_pc(ID_EX_pc),
        .out_pc4(ID_EX_pc4),
        .out_ext(ID_EX_ext),
        .out_rR1(ID_EX_rR1),
        .out_rR2(ID_EX_rR2),
        .out_wR(ID_EX_wR),
        .out_rD1(ID_EX_rD1),
        .out_rD2(ID_EX_rD2),
        .out_rd(ID_EX_rd),
        .out_alu_op(ID_EX_alu_op),
        .out_alu_asel(ID_EX_alu_asel),
        .out_alu_bsel(ID_EX_alu_bsel),
        .out_ram_rsel(ID_EX_ram_rsel),
        .out_ram_we(ID_EX_ram_we),
        .out_rf_we(ID_EX_rf_we),
        .out_rf_wsel(ID_EX_rf_wsel),
        .out_npc_op(ID_EX_npc_op),
        .out_npc_sel(ID_EX_npc_sel),
        .out_flag(ID_EX_flag)
    );
    
    //EX
    ALU U_ALU (
        .op         (ID_EX_alu_op),          // input  wire [ 0:0]
        .A          (for_alu_asel[1]?(for_alu_asel[0]?MEM_WB_wD:MEM_wD):(for_alu_asel[0]?ID_EX_pc:ID_EX_rD1)),               // input  wire [31:0]
        .B          (for_alu_bsel[2]? MEM_WB_wD:(for_alu_bsel[1]?(for_alu_bsel[0]?MEM_wD:ID_EX_rd):(for_alu_bsel[0]?ID_EX_ext:ID_EX_rD2))),     // input  wire [31:0]
        .C          (ALU_C),             // output wire [31:0]
        .f(ALU_f)
    );
    
    
    reg_EX_MEM U_EM(
        .clk(cpu_clk),
        .rst(cpu_rst),
        .flush(flush),
        .in_pc(ID_EX_pc),
        .in_pc4(ID_EX_pc4),
        .in_ext(ID_EX_ext),
        .in_wR(ID_EX_wR),
        .in_rd(EX_to_dram_sel?MEM_WB_wD:ID_EX_rd),
        .in_ram_rsel(ID_EX_ram_rsel),
        .in_ram_we(ID_EX_ram_we),
        .in_rf_we(ID_EX_rf_we),
        .in_rf_wsel(ID_EX_rf_wsel),
        .in_npc_op(ID_EX_npc_op),
        .in_npc_sel(ID_EX_npc_sel),
        .in_ALU_C(ALU_C),
        .in_ALU_f(ALU_f),
        .in_flag(ID_EX_flag),
        
        .out_pc(EX_MEM_pc),
        .out_pc4(EX_MEM_pc4),
        .out_ext(EX_MEM_ext),
        .out_wR(EX_MEM_wR),
        .out_rd(EX_MEM_rd),
        .out_ram_rsel(EX_MEM_ram_rsel),
        .out_ram_we(EX_MEM_ram_we),
        .out_rf_we(EX_MEM_rf_we),
        .out_rf_wsel(EX_MEM_rf_wsel),
        .out_npc_op(EX_MEM_npc_op),
        .out_npc_sel(EX_MEM_npc_sel),
        .out_ALU_C(EX_MEM_ALU_C),
        .out_ALU_f(EX_MEM_ALU_f),
        .out_flag(EX_MEM_flag)
    );
    
    FLUSH U_flush(
        .ALU_f(EX_MEM_ALU_f),
        .npc_op(EX_MEM_npc_op),
        .flush(flush),
        .pc_sel(pc_sel)
    );
    
    //MEM
    //bridge
    assign Bus_we = (|EX_MEM_ram_we);
    assign Bus_addr = {EX_MEM_ALU_C[31:2],2'b0};
    assign Bus_wdata = data_to_dram;
    
    LO_SA_DRAM U_LSD(
        .Ctrl_ram_we(EX_MEM_ram_we),
        .Ctrl_ram_rsel(EX_MEM_ram_rsel),
        .ALU_C(EX_MEM_ALU_C),
        .Bus_rdata(Bus_rdata),
        .RF_rd(MEM_to_dram_sel?MEM_WB_wD:EX_MEM_rd),
        .data_to_dram(data_to_dram),
        .data_from_dram(data_from_dram)
    );
    
    assign MEM_wD = EX_MEM_rf_wsel[1]?(EX_MEM_rf_wsel[0]?EX_MEM_pc4:EX_MEM_ext):(EX_MEM_rf_wsel[0]?data_from_dram:EX_MEM_ALU_C);
    reg_MEM_WB U_MW(
        .clk(cpu_clk),
        .rst(cpu_rst),
        .in_rf_we(EX_MEM_rf_we),
        .ram_wD(MEM_wD),
        .in_wR(EX_MEM_wR),
        .in_pc(EX_MEM_pc),
        .in_flag(EX_MEM_flag),
        
        .out_rf_we(MEM_WB_rf_we),
        .MEM_WB_wD(MEM_WB_wD),
        .out_wR(MEM_WB_wR),
        .out_pc(MEM_WB_pc),
        .out_flag(MEM_WB_flag)
    );
    
    
    //调试
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
    assign debug_wb_have_inst = MEM_WB_flag;
    assign debug_wb_pc        = MEM_WB_pc;
    assign debug_wb_ena       = (|MEM_WB_rf_we);
    assign debug_wb_reg       = MEM_WB_wR;
    assign debug_wb_value     = MEM_WB_wD;
`endif

endmodule
