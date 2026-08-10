import riscv_rpkg::*;

`include "riscv_mux.sv"
`include "riscv_alu.sv"
`include "riscv_alu_cu.sv"
`include "riscv_alu_add.sv"



module riscv_execute_cycle #(
  int WIDTH=32,
  int REG_ADDR=5
)
  (
    input logic clk,
    input logic rst_n,
    input logic [WIDTH-1:0] pcE,
    input logic [WIDTH-1:0] instrE,
    input logic [WIDTH-1:0] rd1E,
    input logic [WIDTH-1:0] rd2E,
    input logic [WIDTH-1:0] immE,
    input logic [WIDTH-1:0] wdW,
    input logic [WIDTH-1:0] alu_outME,  
    
    input logic [6:0] funct7E,
    input logic [2:0] funct3E,
    input alu_op_sel alu_opE,
    input logic [1:0] ForwardA, 
    input logic [1:0] ForwardB,
    
    input logic reg_file_selE,
    input logic wd_regE,
    input logic alu_srcE,
    input logic branchE,
    input logic wmE,
    input logic mem_selE,
    input logic mem_readE,
    input logic validE,
    input logic [REG_ADDR-1:0] rda1E,
    input logic [REG_ADDR-1:0] rda2E,
    input logic [REG_ADDR-1:0] wdaE,
    
    output logic [WIDTH-1:0] pcM,
    output logic [WIDTH-1:0] instrM,
    output logic [WIDTH-1:0] alu_outM,
    output logic [WIDTH-1:0] rd2M,
    output logic [REG_ADDR-1:0] wda_regM,
    output logic [WIDTH-1:0] pc_mux_2inM,
    output logic [2:0] funct3M,
    output logic zeroM,
    output logic branchM,
    output logic wd_regM,
    output logic mem_selM,
    output logic mem_readM,
    output logic wmM,
    output logic validM
  );
  
  logic [REG_ADDR-1:0] wda_regE;
  logic [WIDTH-1:0]    alu_in1E;  
  logic [WIDTH-1:0]    alu_imm1E;
  logic [WIDTH-1:0]    alu_in2E;
  logic [WIDTH-1:0]    alu_outE;
  logic [WIDTH-1:0]    pc_mux_2inE;
  alu_sel alu_controlE;
  status_flags flagsE;
  logic                zeroE;
  
  riscv_32mux #(.WIDTH(REG_ADDR)) reg_file_mux(
    .a(rda2E),
    .b(wdaE),
    .sel(reg_file_selE),
    .out(wda_regE)
  );
  
  riscv_3in_mux #(.WIDTH(WIDTH)) alu_in1_mux( 
    .a(rd1E), 
    .b(wdW), 
    .c(alu_outME), 
    .sel(ForwardA), 
    .out(alu_in1E) 
  ); 
  
  riscv_3in_mux #(.WIDTH(WIDTH)) alu_imm1_mux( 
    .a(rd2E), 
    .b(wdW), 
    .c(alu_outME), 
    .sel(ForwardB), 
    .out(alu_imm1E) 
  );

  riscv_32mux #(.WIDTH(WIDTH)) alu_mux(
    .a(alu_imm1E),
    .b(immE),
    .sel(alu_srcE),
    .out(alu_in2E)
  );
  
  riscv_alu_cu alu_cu(
    .aluc_op(alu_opE),
    .funct3(funct3E),
    .funct7(funct7E),
    .alu_control(alu_controlE)
  );
  
  riscv_alu #(.WIDTH(WIDTH)) alu(
    .a(alu_in1E),
    .b(alu_in2E),
    .sel(alu_controlE),
    .out(alu_outE),
    .flags(flagsE)
  );
  
  riscv_alu_add #(.WIDTH(WIDTH)) alu_add(
    .in1(pcE),
    .in2(immE),
    .out(pc_mux_2inE)
  );
  
  assign zeroE = flagsE.zero;
  
  always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
      pcM <= '0;
      instrM <= '0;
      alu_outM <= '0;
      rd2M <= '0;
      wda_regM <= '0;
      pc_mux_2inM <= '0;
      funct3M <= '0;
      zeroM <= 0;
      branchM <= 0;
      wd_regM <= 0;
      mem_selM <= 0;
      mem_readM <= 0;
      wmM <= 0;
      validM <= 0;
    end
    else begin
      pcM <= pcE;
      instrM <= instrE;
      alu_outM <= alu_outE;
      rd2M <= alu_imm1E;
      wda_regM <= wda_regE;
      pc_mux_2inM <= pc_mux_2inE;
      funct3M <= funct3E;
      zeroM <= zeroE;
      branchM <= branchE;
      wd_regM <= wd_regE;
      mem_selM <= mem_selE;
      mem_readM <= mem_readE;
      wmM <= wmE;
      validM <= validE;
    end
  end
endmodule
      
    
                
                
    
