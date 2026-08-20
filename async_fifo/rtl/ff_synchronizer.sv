module d_flip_flop#(int PWIDTH=5)
  (
    input logic clk, rst_n,
    input logic  [PWIDTH-1:0] in,
    output logic [PWIDTH-1:0] out
  );
  
  always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n)
      out <= '0;
    else
      out <= in;
  end
endmodule


module two_ff_synchronizer #(int PWIDTH=4)
  (
    input logic clk, rst_n,
    input  [PWIDTH-1:0] iptr,
    output [PWIDTH-1:0] optr
  );
  
  logic [PWIDTH-1:0] out1;
  
  d_flip_flop #(.PWIDTH(PWIDTH)) DFF1(clk, rst_n, iptr, out1);
  d_flip_flop #(.PWIDTH(PWIDTH)) DFF2(clk, rst_n, out1, optr);
endmodule
