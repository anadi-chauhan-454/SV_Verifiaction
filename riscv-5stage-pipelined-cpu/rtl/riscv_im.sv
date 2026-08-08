//instruction memory
module riscv_im #(int WIDTH=32)
  (
    input clk,
    input logic imem_wen,
    input logic [WIDTH-1:0] imem_wda, 
    input logic [WIDTH-1:0] imem_wd,
    input logic [WIDTH-1:0] raddr,
    output logic [WIDTH-1:0] instr
  );
  
  logic [WIDTH-1:0] mem [1023:0];
  
  always_ff @(posedge clk) begin
	if(imem_wen)
      mem[imem_wda[11:2]] <= imem_wd;
    instr <= mem[raddr[11:2]];
  end
    
endmodule

