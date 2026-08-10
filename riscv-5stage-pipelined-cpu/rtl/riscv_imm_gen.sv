import riscv_rpkg::*;

module riscv_imm_gen #(int WIDTH=32) 
 (
   input  logic [WIDTH-1:0] instruction,
   input  imm_states  imm_src,
   output logic [WIDTH-1:0] imm
 );

  always_comb begin
    imm = 32'b0;

    case (imm_src)
      IM_I_TYPE: begin
        imm = {{20{instruction[31]}}, instruction[31:20]};
      end

      S_TYPE: begin
        imm = {{20{instruction[31]}},
               instruction[31:25],
               instruction[11:7]};
      end

      B_TYPE: begin
        imm = {{19{instruction[31]}},
               instruction[31],       
               instruction[7],        
               instruction[30:25],   
               instruction[11:8],    
               1'b0};
      end

      U_TYPE: begin
        imm = {instruction[31:12], 12'b0};
      end

      J_TYPE: begin
        imm = {{11{instruction[31]}},
               instruction[31],       
               instruction[19:12],    
               instruction[20],       
               instruction[30:21],    
               1'b0};
      end
      
      default: imm = 32'b0;

    endcase
  end

endmodule
