`include "riscv_mux.sv"

module riscv_write_back_cycle #(int WIDTH=32,
                               int REG_ADDR=5)
  (
    input logic [WIDTH-1:0] alu_outW,
    input logic [REG_ADDR-1:0] wda_regW,
    input logic wd_regW,
    input logic mem_selW,
    input logic [WIDTH-1:0] read_dataW,
    input logic validW,
    input logic [WIDTH-1:0] pcW,
    input logic [WIDTH-1:0] instrW,
    
    output logic wd_regD,
    output logic [REG_ADDR-1:0] wda_regD,
    output logic [WIDTH-1:0] wdD,
    output logic wd_reg_cpu,
    output logic [REG_ADDR-1:0]wda_reg_cpu,
    output logic [WIDTH-1:0] wd_cpu,
    output logic valid_cpu,
    output logic [WIDTH-1:0] pcW_cpu,
    output logic [WIDTH-1:0] instrW_cpu
  );
  
  logic [WIDTH-1:0] wdW;
  
  riscv_32mux #(.WIDTH(WIDTH)) wb_mux(
    .a(alu_outW),
    .b(read_dataW),
    .sel(mem_selW),
    .out(wdW)
  );
  
  assign wd_reg_cpu = wd_regW;
  assign wda_reg_cpu = wda_regW;
  assign wd_cpu = wdW;
  assign valid_cpu = validW;
  
  assign pcW_cpu = pcW;
  assign instrW_cpu = instrW;
  
  assign wd_regD = wd_regW;
  assign wda_regD = wda_regW;
  assign wdD = wdW;
endmodule
  
