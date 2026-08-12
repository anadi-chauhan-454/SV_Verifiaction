interface riscv_if #(int WIDTH=32,
                    int REG_ADDR=5) (
  input logic clk,
  input logic rst_n);
  
  logic imem_wen;
  logic [WIDTH-1:0] imem_wda; 
  logic [WIDTH-1:0] imem_wd; 
  
  logic [WIDTH-1:0] pcW_cpu;
  logic [WIDTH-1:0] instrW_cpu;
  logic wd_reg_cpu;
  logic [REG_ADDR-1:0]wda_reg_cpu;
  logic [WIDTH-1:0] wd_cpu;
  logic mr_cpu;
  logic mw_cpu;
  logic [WIDTH-1:0] maddr_cpu;
  logic [WIDTH-1:0] mwdata_cpu;
  logic [WIDTH-1:0] mrdata_cpu;
  logic valid_cpu;
  logic mem_valid_cpu;
  
  clocking drv_cb @(posedge clk);
    default input #1step output #1;
    output imem_wen;
    output imem_wda; 
    output imem_wd; 
    input pcW_cpu;
    input instrW_cpu;
    input wd_reg_cpu;
    input wda_reg_cpu;
	input wd_cpu;
    input mr_cpu;
    input mw_cpu;
    input maddr_cpu;
    input mwdata_cpu;
    input mrdata_cpu;
    input valid_cpu;
    input mem_valid_cpu;
  endclocking
  
  clocking mon_cb @(posedge clk);
    default input #1step;
    input imem_wen;
    input imem_wda; 
    input imem_wd; 
    input pcW_cpu;
    input instrW_cpu;
    input wd_reg_cpu;
    input wda_reg_cpu;
	input wd_cpu;
    input mr_cpu;
    input mw_cpu;
    input maddr_cpu;
    input mwdata_cpu;
    input mrdata_cpu;
    input valid_cpu;
     input mem_valid_cpu;
  endclocking
    
  
endinterface
