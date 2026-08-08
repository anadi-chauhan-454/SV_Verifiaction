//register file
module riscv_reg_file #(int WIDTH=32, int REG_ADDR=5)
  (
    input logic clk,
    input logic rst_n,
    input logic [REG_ADDR-1:0] rda1,
    input logic [REG_ADDR-1:0] rda2,
    input logic [REG_ADDR-1:0] wda,
    input logic [WIDTH-1:0]    wd,
    input logic wen,
    
    output logic [WIDTH-1:0] rd1,
    output logic [WIDTH-1:0] rd2
  );
  
  localparam NUM_REGS = 1 << REG_ADDR;
  
  logic [WIDTH-1:0] reg_mem [0:NUM_REGS-1];
  
  always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n)
      reg_mem <= '{default: '0};
    else begin
      if(wen && (wda != '0))
        reg_mem[wda] <= wd;
    end
  end
  
  assign rd1 = (rda1 != '0) ? reg_mem[rda1] : '0;
  assign rd2 = (rda2 != '0) ? reg_mem[rda2] : '0;
endmodule
      
