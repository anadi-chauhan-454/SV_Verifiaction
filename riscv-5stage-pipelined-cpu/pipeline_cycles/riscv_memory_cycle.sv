`include "riscv_dm.sv"

module riscv_memory_cycle #(int WIDTH=32,
                            int REG_ADDR =5)
  (
    input logic clk,
    input logic rst_n,
    input logic [WIDTH-1:0] alu_outM,
    input logic [WIDTH-1:0] rd2M, 
    input logic [REG_ADDR-1:0] wda_regM, 
    input logic [WIDTH-1:0] pc_mux_2inM, 
    input logic [2:0] funct3M,
    input logic [WIDTH-1:0] pcM,
    input logic [WIDTH-1:0] instrM,
    
    input logic zeroM,
    input logic branchM,
    input logic wd_regM,
    input logic mem_selM,
    input logic mem_readM,
    input logic wmM,
    input logic validM,
    
    output logic [WIDTH-1:0] pcW,
    output logic [WIDTH-1:0] instrW,
    output logic [WIDTH-1:0] alu_outW,
    output logic [REG_ADDR-1:0] wda_regW,
    output logic wd_regW,
    output logic mem_selW,
    output logic [WIDTH-1:0] read_dataW,
    output logic pc_mux_selF,
    output logic [WIDTH-1:0] pc_mux_2inF,
    output logic validW,
    output logic mr_cpu,
    output logic mw_cpu,
    output logic [WIDTH-1:0] maddr_cpu,
    output logic [WIDTH-1:0] mwdata_cpu,
    output logic [WIDTH-1:0] mrdata_cpu,
    output logic mem_valid_cpu
  );
  
  logic [WIDTH-1:0] read_dataM;
  logic pc_mux_selM;
  
  
  assign mr_cpu = mem_readM;
  assign mw_cpu = wmM;
  assign maddr_cpu = alu_outM;
  assign mwdata_cpu = rd2M;
  assign mrdata_cpu = read_dataM;
  assign mem_valid_cpu = validM;
  
  assign pc_mux_selM = branchM & zeroM;
  
  riscv_dm #(.WIDTH(WIDTH)) dm(
    .clk(clk),
    .address(alu_outM),
    .w_data(rd2M),
    .mem_read(mem_readM),
    .mem_write(wmM),
    .funct3(funct3M),
    .r_data(read_dataM)
  );
  
  always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
      pcW <= '0;
      instrW <= '0;
      alu_outW <= '0;
      wda_regW <= '0;
      wd_regW <= 0;
      mem_selW <= 0;
      read_dataW <= 0;
      pc_mux_selF <= 0;
      pc_mux_2inF <= '0;
      validW <= 0;
    end
    else begin
      pcW <= pcM;
      instrW <= instrM;
      alu_outW <= alu_outM;
      wda_regW <= wda_regM;
      wd_regW <= wd_regM;
      mem_selW <= mem_selM;
      read_dataW <= read_dataM;
      pc_mux_selF <= pc_mux_selM;
      pc_mux_2inF <= pc_mux_2inM;
      validW <= validM;
    end
  end
endmodule
      
