`include "riscv_rpkg.sv"
`include "riscv_fetch_cycle.sv"
`include "riscv_decode_cycle.sv"
`include "riscv_execute_cycle.sv"
`include "riscv_memory_cycle.sv"
`include "riscv_write_back_cycle.sv"
`include "riscv_hazard.sv"
`include "riscv_forwading_unit.sv"

import riscv_rpkg::*;

module riscv_top #(int WIDTH=32,
                   int REG_ADDR = 5)
  (
    input logic clk,
    input logic rst_n,
    input logic imem_wen,
    input logic [WIDTH-1:0] imem_wda, 
    input logic [WIDTH-1:0] imem_wd,
    
    output logic wd_reg_cpu,
    output logic [REG_ADDR-1:0]wda_reg_cpu,
    output logic [WIDTH-1:0] wd_cpu,
    output logic mr_cpu,
    output logic mw_cpu,
    output logic [WIDTH-1:0] maddr_cpu,
    output logic [WIDTH-1:0] mwdata_cpu,
    output logic [WIDTH-1:0] mrdata_cpu,
    output logic valid_cpu,
    output logic mem_valid_cpu,
    output logic [WIDTH-1:0] pcW_cpu,
    output logic [WIDTH-1:0] instrW_cpu
  );
  //Fetch
  logic pc_write;
  logic IF_ID_write;
  logic [WIDTH-1:0] pcD;
  logic [WIDTH-1:0] instrD;
  logic validD;
  
  //Decode
  logic [WIDTH-1:0] wdW;
  logic [REG_ADDR-1:0] wdaW;
  logic wenW;
  logic flushE;
  logic [WIDTH-1:0] pcE;
  logic [WIDTH-1:0] instrE;
  logic [WIDTH-1:0] rd1E;
  logic [WIDTH-1:0] rd2E;
  logic [WIDTH-1:0] immE;
  logic [2:0] funct3E;
  logic [6:0] funct7E;
  logic reg_file_selE;
  logic wd_regE;
  logic alu_srcE;
  alu_op_sel alu_opE;
  logic wmE;
  logic mem_selE;
  logic mem_readE;
  logic branchE;
  logic [REG_ADDR-1:0] rda1E;
  logic [REG_ADDR-1:0] rda2E;
  logic [REG_ADDR-1:0] wdaE;
  logic validE;
  
  //Execute
  logic [1:0] ForwardA;
  logic [1:0] ForwardB;
  logic [WIDTH-1:0] pcM;
  logic [WIDTH-1:0] instrM;
  logic [WIDTH-1:0] alu_outM;
  logic [WIDTH-1:0] rd2M;
  logic [REG_ADDR-1:0] wda_regM;
  logic [WIDTH-1:0] pc_mux_2inM;
  logic [2:0] funct3M;
  logic zeroM;
  logic branchM;
  logic wd_regM;
  logic mem_selM;
  logic mem_readM;
  logic wmM;
  logic validM;
  
  //Memory
  logic [WIDTH-1:0] alu_outW;
  logic [REG_ADDR-1:0] wda_regW;
  logic wd_regW;
  logic mem_selW;
  logic [WIDTH-1:0] read_dataW;
  logic pc_mux_selF;
  logic [WIDTH-1:0] pc_mux_2inF; 
  logic validW;
  logic [WIDTH-1:0] pcW;
  logic [WIDTH-1:0] instrW;
  
  riscv_fetch_cycle #(.WIDTH(WIDTH)) fetch_cycle(
    .clk(clk),
    .rst_n(rst_n),
    .imem_wen(imem_wen),
    .imem_wda(imem_wda),
    .imem_wd(imem_wd),
    .mux_selM(pc_mux_selF),
    .pc_write(pc_write),
    .IF_ID_write(IF_ID_write),
    .mux_1inM(pc_mux_2inF),
    .pcD(pcD),
    .instrD(instrD),
    .validD(validD)
  );
  
  riscv_decode_cycle #(.WIDTH(WIDTH),
                       .REG_ADDR(REG_ADDR)) decode_cycle(
    .clk(clk),
    .rst_n(rst_n),
    .pcD(pcD),
    .instrD(instrD),
    .validD(validD),
    .wdW(wdW),
    .wdaW(wdaW),
    .wenW(wenW),
    .flushE(flushE), 
    .pcE(pcE),   
    .instrE(instrE),
    .rd1E(rd1E),         
    .rd2E(rd2E),         
    .immE(immE),         
    .funct3E(funct3E),      
    .funct7E(funct7E),      
    .reg_file_selE(reg_file_selE),    
    .wd_regE(wd_regE),          
    .alu_srcE(alu_srcE),         
    .alu_opE(alu_opE),      
    .wmE(wmE),              
    .mem_selE(mem_selE),         
    .mem_readE(mem_readE),        
    .branchE(branchE),          
    .rda1E(rda1E),        
    .rda2E(rda2E),        
    .wdaE(wdaE),
    .validE(validE)
  );
  
  riscv_execute_cycle #(.WIDTH(WIDTH),
                        .REG_ADDR(REG_ADDR)) execute_cycle(
    .clk(clk),
    .rst_n(rst_n),  
    .pcE(pcE), 
    .instrE(instrE),
    .rd1E(rd1E),         
    .rd2E(rd2E),         
    .immE(immE),  
    .wdW(wdW),
    .alu_outME(alu_outM),
    .funct3E(funct3E),      
    .funct7E(funct7E),
    .alu_opE(alu_opE),
    .ForwardA(ForwardA),
    .ForwardB(ForwardB),
    .reg_file_selE(reg_file_selE),    
    .wd_regE(wd_regE),          
    .alu_srcE(alu_srcE),   
    .branchE(branchE), 
    .wmE(wmE),              
    .mem_selE(mem_selE),         
    .mem_readE(mem_readE), 
    .rda1E(rda1E),
    .rda2E(rda2E),        
    .wdaE(wdaE),
    .validE(validE),
    .pcM(pcM),
    .instrM(instrM),
    .alu_outM(alu_outM),
    .rd2M(rd2M),
    .wda_regM(wda_regM),
    .pc_mux_2inM(pc_mux_2inM),
    .funct3M(funct3M),
    .zeroM(zeroM),
    .branchM(branchM),
    .wd_regM(wd_regM),
    .mem_selM(mem_selM),
    .mem_readM(mem_readM),
    .wmM(wmM),
    .validM(validM)
  );
  
  riscv_memory_cycle #(.WIDTH(WIDTH),
                       .REG_ADDR(REG_ADDR)) memory_cycle(
    .clk(clk),
    .rst_n(rst_n),
    .alu_outM(alu_outM),
    .rd2M(rd2M),
    .wda_regM(wda_regM),
    .pc_mux_2inM(pc_mux_2inM),
    .funct3M(funct3M),
    .pcM(pcM),
    .instrM(instrM),
    .zeroM(zeroM),
    .branchM(branchM),
    .wd_regM(wd_regM),
    .mem_selM(mem_selM),
    .mem_readM(mem_readM),
    .wmM(wmM),
    .validM(validM),
    .pcW(pcW),
    .instrW(instrW),
    .alu_outW(alu_outW),
    .wda_regW(wda_regW),
    .wd_regW(wd_regW),
    .mem_selW(mem_selW),
    .read_dataW(read_dataW),
    .pc_mux_selF(pc_mux_selF),
    .pc_mux_2inF(pc_mux_2inF),
    .mr_cpu(mr_cpu),
    .mw_cpu(mw_cpu),
    .maddr_cpu(maddr_cpu),
    .mwdata_cpu(mwdata_cpu),
    .mrdata_cpu(mrdata_cpu),
    .validW(validW),
    .mem_valid_cpu(mem_valid_cpu)
  );
  
  riscv_write_back_cycle #(.WIDTH(WIDTH),
                           .REG_ADDR(REG_ADDR)) write_back_cycle(
    .alu_outW(alu_outW),
    .wda_regW(wda_regW),
    .wd_regW(wd_regW),
    .mem_selW(mem_selW),
    .read_dataW(read_dataW),
    .wd_regD(wenW),
    .wda_regD(wdaW),
    .wdD(wdW),
    .validW(validW),
    .pcW(pcW),
    .instrW(instrW),
    .wd_reg_cpu(wd_reg_cpu),
    .wda_reg_cpu(wda_reg_cpu),
    .wd_cpu(wd_cpu),
    .valid_cpu(valid_cpu),
    .pcW_cpu(pcW_cpu),
    .instrW_cpu(instrW_cpu)
  );
    
  riscv_hazard #(.REG_ADDR(REG_ADDR)) hazard_unit(
    .rda1D(instrD[25:21]),
    .rda2D(instrD[20:16]),
    .wdaE(wdaE),
    .mem_readE(mem_readE),
    .pc_write(pc_write),
    .IF_ID_write(IF_ID_write),
    .flushE(flushE)
  );
  
  riscv_forwading_unit #(.REG_ADDR(REG_ADDR)) forwading_unit(
    .rda1E(rda1E),
    .rda2E(rda2E),
    .wdaM(wda_regM),
    .wdaW(wda_regW),
    .reg_writeW(wd_regW),
    .reg_writeM(wd_regM),
    .ForwardA(ForwardA),
    .ForwardB(ForwardB)
  );
  
endmodule
