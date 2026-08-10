import riscv_rpkg::*;

module riscv_alu_cu
  (
    input alu_op_sel aluc_op,
    input logic [2:0] funct3,
    input logic [6:0] funct7,
    output alu_sel alu_control
  );

  always_comb begin
    alu_control = 4'b1111;
    
    unique case(aluc_op)
      ADD: alu_control = 4'b0000;
      SUB: alu_control = 4'b0001;
      
      RC_TYPE, IC_TYPE: begin
        case (funct3)

          3'b000: begin
            if (aluc_op == R_TYPE && funct7[5])
              alu_control = 4'b0001; 
            else
              alu_control = 4'b0000; 
          end

          3'b111: alu_control = 4'b0010;
          3'b110: alu_control = 4'b0011;
          3'b100: alu_control = 4'b0100;
          3'b001: alu_control = 4'b0101;

          3'b101: begin
            if (funct7[5])
              alu_control = 4'b0111; 
            else
              alu_control = 4'b0110; 
          end
          default: alu_control = 4'b1111;
        endcase
      end
      default: alu_control = 4'b1111;
    endcase
  end
endmodule
      
      
