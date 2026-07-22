module alu #(parameter int WIDTH = 4)
(
  input logic [WIDTH-1:0] a,
  input logic [WIDTH-1:0] b,
  input alu_pkg::alu_opt_t sel,
  input logic [$clog2(WIDTH)-1:0] shamt,
  output logic [WIDTH-1:0] result,
  output alu_pkg::status_flags_t flags
);
  import alu_pkg::*;

  logic [WIDTH:0] temp;
  
  always_comb begin
    temp   = '0;
    flags = '0;
    result = '0;

    unique case (sel)

        ALU_ADD: begin
            temp = {1'b0, a} + {1'b0, b};
          result = temp[WIDTH-1:0];

          flags.carry = temp[WIDTH];
            flags.overflow =
          (a[WIDTH-1] == b[WIDTH-1]) &&
          (result[WIDTH-1] != a[WIDTH-1]);
        end

        ALU_SUB: begin
            temp = {1'b0, a} - {1'b0, b};
          result = temp[WIDTH-1:0];

          flags.carry = temp[WIDTH];
            flags.overflow =
          (a[WIDTH-1] != b[WIDTH-1]) &&
                (result[WIDTH-1] != a[WIDTH-1]);
        end

        ALU_AND: result = a & b;
        ALU_OR : result = a | b;
        ALU_XOR: result = a ^ b;
        ALU_SLEFT: result = a << shamt;
        ALU_SRIGHT: result = a >> shamt;
        default: result = '0;
    endcase
    flags.zero     = (result == '0);
    flags.negative = result[WIDTH-1];

end
endmodule
      
    
  

