
interface sfifo_if#(
  parameter int DWIDTH = 8
)
  (
    input logic clk, 
    input logic rst_n
  );

  import sfifo_pkg::*;
  
  logic wen;
  logic ren;
  logic [DWIDTH-1:0] data_in;
  logic [DWIDTH-1:0] data_out;
  status_flag_t flags;
  
  clocking sfifo_cb @(posedge clk);
    default input #1step output #1;
    input  flags;
    input  data_out;
    output data_in;
    output wen, ren;
  endclocking

  clocking sfifo_mon_cb @(posedge clk);
    default input #1ns output #1ns;
    input wen, ren, data_in, data_out, flags;
  endclocking
  
	property p_reset_status;
      @(posedge clk) $fell(rst_n) |=> (flags.empty && !flags.full && !flags.overflow && !flags.underflow);
	endproperty
	assert property (p_reset_status) else $error("Reset state mismatch!");

	property p_underflow_rdwnempty;
  		@(posedge clk) disable iff (!rst_n)
      (flags.empty && ren) |=> flags.underflow;
	endproperty
	assert property (p_underflow_rdwnempty) else $error("Underflow flag failed to assert!");

	property p_overflow_wrwnfull;
  		@(posedge clk) disable iff (!rst_n)
      (flags.full && wen && !ren) |=> flags.overflow;
	endproperty
	assert property (p_overflow_wrwnfull) else $error("Overflow flag failed to assert!");

	property p_full_empty_mutually_exclusive;
  		@(posedge clk) disable iff (!rst_n)
      !(flags.full && flags.empty);
	endproperty
	assert property (p_full_empty_mutually_exclusive) else $fatal("FIFO is full and empty simultaneously!");

	property p_data_out_no_unknown;
  		@(posedge clk) disable iff (!rst_n)
  		!$isunknown(data_out);
	endproperty
	assert property (p_data_out_no_unknown) else $error("X detected on data_out bus!");
	  

  modport dut(
    input clk, rst_n, wen, ren, data_in, 
    output data_out, flags
  );
  
  modport testb(clocking sfifo_cb, input rst_n);
endinterface
  
  
  
  
  
