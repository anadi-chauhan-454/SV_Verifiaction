module riscv_32mux #(int WIDTH=32)
  (
    input logic [WIDTH-1:0] a,
    input logic [WIDTH-1:0] b,
    input logic sel,
    output logic [WIDTH-1:0] out
  );
  
  assign out = (sel) ? b : a;
endmodule

module riscv_3in_mux #(int WIDTH=32)
  (
    input  logic [WIDTH-1:0] a,
    input  logic [WIDTH-1:0] b,
    input  logic [WIDTH-1:0] c,
    input  logic [1:0] sel,
    output logic [WIDTH-1:0] out
  );

  assign out = (sel == 2'b00) ? a :
               (sel == 2'b01) ? b :
               (sel == 2'b10) ? c :
                              a;

endmodule
