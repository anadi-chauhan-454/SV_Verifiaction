module riscv_pc #(int WIDTH=32)
  (
    input logic clk,
    input logic rst_n,
    input logic pc_write,
    input logic [WIDTH-1:0] pc_next,
    output logic [WIDTH-1:0] pc
  );
  
  always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n)
      pc <= '0;
    else if(pc_write)
      pc <= pc_next;
  end
endmodule
      
