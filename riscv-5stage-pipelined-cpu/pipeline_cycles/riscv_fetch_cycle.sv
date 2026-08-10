`include "riscv_mux.sv"
`include "riscv_pc.sv"
`include "riscv_im.sv"
`include "riscv_pca.sv"

module riscv_fetch_cycle #(int WIDTH=32)
  (
    input logic clk,
    input logic rst_n,
    input logic imem_wen,
    input logic [WIDTH-1:0] imem_wda, 
    input logic [WIDTH-1:0] imem_wd,
    input logic mux_selM,
    input logic pc_write,
    input logic IF_ID_write,
    input logic [WIDTH-1:0] mux_1inM,
    
    output logic [WIDTH-1:0] pcD,
    output logic [WIDTH-1:0] instrD,
    output logic validD
  );
  
  logic [WIDTH-1:0] pc_add_outF;
  logic [WIDTH-1:0] pc_nextF;
  logic [WIDTH-1:0] pcF;
  logic [WIDTH-1:0] instrF;
  logic validF;
  
  riscv_32mux #(.WIDTH(WIDTH)) pc_mux(
    .a(pc_add_outF),
    .b(mux_1inM),
    .sel(mux_selM),
    .out(pc_nextF)
  );
  
  riscv_pc #(.WIDTH(WIDTH)) pc(
    .clk(clk),
    .rst_n(rst_n),
    .pc_write(pc_write),
    .pc_next(pc_nextF),
    .pc(pcF)
  );
  
  riscv_im #(.WIDTH(WIDTH)) im(
    .clk(clk),
    .imem_wen(imem_wen),
    .imem_wda(imem_wda),
    .imem_wd(imem_wd),
    .raddr(pcF),
    .instr(instrF)
  );
  
  riscv_pca #(.WIDTH(WIDTH)) adder(
    .in(pcF),
    .out(pc_add_outF)
  );
  
  always_ff @(posedge clk or  negedge rst_n) begin
    if(!rst_n) begin
      validF <= 0;
      pcD <= '0;
      instrD <= '0;
      validD <= 0;
    end
    else if(IF_ID_write) begin
      pcD <= pcF;
      instrD <= instrF;
      validF <=1;
      validD <= validF;
    end
  end
endmodule
    
    
