package sfifo_pkg;

typedef struct packed{
 logic full;
  logic empty;
  logic overflow;
  logic underflow;
}status_flag_t;

    `include "sfifo_tr.sv"
    `include "sfifo_gen.sv"
    `include "sfifo_drv.sv"
    `include "sfifo_mon.sv"
    `include "sfifo_rm.sv"
    `include "sfifo_scb.sv"
    `include "sfifo_env.sv"
    `include "sfifo_test.sv"
endpackage
