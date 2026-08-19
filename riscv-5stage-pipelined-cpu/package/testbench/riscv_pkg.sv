package riscv_pkg;

  import uvm_pkg::*;

  `include "uvm_macros.svh"

  typedef enum logic [6:0] {
        R_TYPE = 7'b0110011,
        I_TYPE = 7'b0010011,
        LOAD   = 7'b0000011,
        STORE  = 7'b0100011,
        BRANCH = 7'b1100011
    } opcode_sel;


    typedef enum logic [2:0]{
      IM_I_TYPE,
      S_TYPE,
      B_TYPE,
      U_TYPE,
      J_TYPE
    } imm_states;


    typedef enum logic [1:0]{
      ADD,
      SUB,
      RC_TYPE,
      IC_TYPE
    } aluc_op_sel;



   typedef enum logic [3:0] {
        ALU_ADD = 4'd0,
        ALU_SUB = 4'd1,
        ALU_AND = 4'd2,
        ALU_OR  = 4'd3,
        ALU_XOR = 4'd4,
        ALU_SHL = 4'd5,
        ALU_SHR = 4'd6
    } alu_sel;

   typedef struct packed {
     logic zero;
     logic carry;
     logic overflow;
     logic negative;
   } status_flags;


  `include "riscv_seq_item.sv"
   typedef riscv_seq_item #(32,5) riscv_tr;
  `include "riscv_seq.sv"
  `include "riscv_seqr.sv"
  `include "riscv_driver.sv"
  `include "riscv_mon_item.sv"
   typedef riscv_mon_item #(32,5) riscv_mon_tr;
  `include "riscv_mon.sv"
  `include "riscv_rm_item.sv"
   typedef riscv_rm_item #(32,5) rm_item;
   typedef riscv_rm_item  #(32,5) riscv_exp_tr;
  `include "riscv_ref_model.sv"
  `include "riscv_scb.sv"
  `include "riscv_agent.sv"
  `include "riscv_env.sv"
  `include "riscv_test.sv"

endpackage
