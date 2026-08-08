//Main Control

import riscv_rpkg::*;

module riscv_cu
  (
    input opcode_sel opcode,
    
    output logic reg_file_sel,
    output logic wd_reg,
    output logic alu_src,
    output alu_op_sel alu_op,
    output logic wm,
    output logic mem_sel,
    output logic mem_read,
    output logic branch,
    output imm_states imm_src
  );
  
  always_comb begin
    
    reg_file_sel = 0;
    wd_reg = 0;
    alu_src = 0;
    alu_op = '0;
    wm = 0;
    mem_sel = 0;
    mem_read = 0;
    branch = 0;
    imm_src = '0;
    
    unique case(opcode)
      R_TYPE: begin
        reg_file_sel = 1;
        alu_op = 2'b10;
        wd_reg = 1;
      end
      
      I_TYPE: begin
        reg_file_sel = 1;
        alu_src = 1;
        alu_op = 2'b11;
        wd_reg = 1;
        imm_src = 2'b00;
      end
      
      LOAD: begin
        reg_file_sel = 1;
        alu_src = 1;
        alu_op = 2'b00;
        mem_read = 1;
        wd_reg = 1;
        mem_sel = 1;
        imm_src = 3'b000;
      end
      
      STORE:begin
        alu_src = 1;
        wm =1;
        alu_op = 2'b00;
        imm_src = 3'b001;
      end
      
      BRANCH: begin
        branch = 1;
        alu_op = 2'b01;
        imm_src = 3'b010;
      end
      
      default: ;
    endcase
  end
endmodule
        
    
    
