import sfifo_pkg::*;

module sfifo #(
  parameter int DWIDTH = 8,
  parameter int DEPTH = 8,
  parameter int PWIDTH = $clog2(DEPTH)
)
  (
    input  logic 			  clk,
    input  logic 			  rst_n,
    input  logic   			  wen,
    input  logic   			  ren,
    input  logic [DWIDTH-1:0] data_in,
    output logic [DWIDTH-1:0] data_out,
    output status_flag_t flags
  );
  
  logic [PWIDTH:0]   wptr;
  logic [PWIDTH:0]   rptr;
  
  logic [DWIDTH-1:0] fifo[0:DEPTH-1];
  
  logic wr_en;
  logic rd_en;
  
  assign wr_en = wen && (!flags.full || ren);
  assign rd_en = ren && !flags.empty;
  
  initial begin
    if ((DEPTH & (DEPTH-1)) != 0)
        $fatal(1, "DEPTH (%0d) must be a power of 2.", DEPTH);
end
  
   
  always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
      	  data_out  <= '0;
          wptr 		<= '0;
          rptr      <= '0;
          flags.overflow  <= 1'b0;
          flags.underflow <= 1'b0;
        end
      else begin
        flags.overflow  <= wen && flags.full  && !ren;
        flags.underflow <= ren && flags.empty;
        if(wr_en) begin
              fifo[wptr[PWIDTH-1:0]] <= data_in;
              wptr <= wptr + 1;
        	end
	  	if(rd_en) begin
        data_out <= fifo[rptr[PWIDTH-1:0]];
        rptr     <= rptr + 1;
     		 end
        end
    end
  
  assign flags.full =
    (wptr[PWIDTH] != rptr[PWIDTH]) &&
    (wptr[PWIDTH-1:0] == rptr[PWIDTH-1:0]);
  assign flags.empty  = (wptr == rptr);
endmodule
