package alu_pkg;

typedef struct packed {
    logic carry;
    logic negative;
    logic overflow;
    logic zero;
} status_flags_t;

typedef enum logic [3:0] {
    ALU_ADD,
    ALU_SUB,
    ALU_AND,
    ALU_OR,
    ALU_XOR,
    ALU_SLEFT,
    ALU_SRIGHT
} alu_opt_t;

    `include "alu_tr.sv"
    `include "alu_gen.sv"
    `include "alu_drv.sv"
    `include "alu_mon.sv"
    `include "alu_rm.sv"
    `include "alu_scb.sv"
    `include "alu_env.sv"
    `include "alu_test.sv"
endpackage
