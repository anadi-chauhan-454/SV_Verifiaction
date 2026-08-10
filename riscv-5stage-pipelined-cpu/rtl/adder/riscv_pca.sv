//program counter adder

module riscv_pca #(int WIDTH=32)
  (
    input logic [WIDTH-1:0] in,
    output logic [WIDTH-1:0] out
  );
  
  assign out = in + WIDTH'(4);
endmodule
