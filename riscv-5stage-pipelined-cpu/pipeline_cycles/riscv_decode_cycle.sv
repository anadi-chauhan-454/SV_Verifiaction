import riscv_rpkg::*;

`include "riscv_cu.sv"
`include "riscv_reg_file.sv"
`include "riscv_imm_gen.sv"

module riscv_decode_cycle #(
  int WIDTH=32, 
  int REG_ADDR=5
)
  (
    input logic clk,
    input logic rst_n,
    input logic [WIDTH-1:0]    instrD,
    input logic [WIDTH-1:0]    pcD,
    input logic [WIDTH-1:0]    wdW,
    input logic [REG_ADDR-1:0] wdaW,
    input logic                wenW,
    input logic                flushE,
    input logic                validD,
    
    output logic [WIDTH-1:0] pcE,
    output logic [WIDTH-1:0] instrE,
    output logic [WIDTH-1:0] rd1E,
    output logic [WIDTH-1:0] rd2E,
    output logic [WIDTH-1:0] immE,
    output logic [2:0]       funct3E,
    output logic [6:0]       funct7E,
    output logic             reg_file_selE,
    output logic             wd_regE,
    output logic             alu_srcE,
    output alu_op_sel alu_opE,
    output logic             wmE,
    output logic             mem_selE,
    output logic             mem_readE,
    output logic             branchE,
    output logic             validE,
    
    output logic [REG_ADDR-1:0] rda1E,
    output logic [REG_ADDR-1:0] rda2E,
    output logic [REG_ADDR-1:0] wdaE
  );
  
  logic reg_file_selD, wd_regD, alu_srcD;
  logic wmD, mem_selD, mem_readD;
  logic branchD;
  logic [WIDTH-1:0] immD;
  logic [WIDTH-1:0] rd1D, rd2D;
  
  opcode_sel opcode;
  imm_states imm_srcD;
  alu_op_sel alu_opD;
  
  assign opcode = opcode_sel'(instrD[6:0]);
  
  riscv_cu cu(
    .opcode(opcode),
    .reg_file_sel(reg_file_selD),
    .wd_reg(wd_regD),
    .alu_src(alu_srcD),
    .alu_op(alu_opD),
    .wm(wmD),
    .mem_sel(mem_selD),
    .mem_read(mem_readD),
    .branch(branchD),
    .imm_src(imm_srcD)
  );
  
  riscv_reg_file #(.WIDTH(WIDTH),
                   .REG_ADDR(REG_ADDR)) 
  reg_file(
    .clk(clk),
    .rst_n(rst_n),
    .rda1(instrD[25:21]),
    .rda2(instrD[20:16]),
    .wda(wdaW),
    .wd(wdW),
    .wen(wenW),
    .rd1(rd1D),
    .rd2(rd2D)
  );
  
  riscv_imm_gen #(.WIDTH(WIDTH)) imm_gen(
    .instruction(instrD),
    .imm_src(imm_srcD),
    .imm(immD)
  );
  
  always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
      pcE           <= '0;
      instrE        <= '0;
      rd1E          <= '0;
      rd2E          <= '0;
      immE          <= '0;
      funct3E       <= '0;
      funct7E       <= '0;
      reg_file_selE <= 0;
      wd_regE       <= 0;
      alu_srcE      <= 0;
      alu_opE       <= '0;
      wmE           <= 0;
      mem_selE      <= 0;
      mem_readE     <= 0;
      branchE       <= 0;
      validE        <= 0;
      rda1E         <= '0;
      rda2E         <= '0;
      wdaE          <= '0;
    end
    else if(flushE) begin
      pcE           <= '0;
      instrE        <= '0;
      rd1E          <= '0;
      rd2E          <= '0;
      immE          <= '0;
      funct3E       <= '0;
      funct7E       <= '0;
      reg_file_selE <= 0;
      wd_regE       <= 0;
      alu_srcE      <= 0;
      alu_opE       <= '0;
      wmE           <= 0;
      mem_selE      <= 0;
      mem_readE     <= 0;
      branchE       <= 0;
      validE        <= 0;
      rda1E         <= '0;
      rda2E         <= '0;
      wdaE          <= '0;
    end
    else begin
      pcE           <= pcD;
      instrE        <= instrD;
      rd1E          <= rd1D;
      rd2E          <= rd2D;
      immE          <= immD;
      funct3E       <= instrD[14:12];
      funct7E       <= instrD[31:25];
      reg_file_selE <= reg_file_selD;
      wd_regE       <= wd_regD;
      alu_srcE      <= alu_srcD;
      alu_opE       <= alu_opD;
      wmE           <= wmD;
      mem_selE      <= mem_selD;
      mem_readE     <= mem_readD;
      branchE       <= branchD;
      validE        <= validD;
      rda1E         <= instrD[25:21];
      rda2E         <= instrD[20:16];
      wdaE          <= instrD[15:11];
    end
  end
endmodule
    
    
    
