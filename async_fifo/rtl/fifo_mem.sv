module fifo_mem #(
  int DWIDTH = 8,
  int DEPTH  = 8,
  int PWIDTH = 4
)
  (
    input logic wclk,
    input logic wen,
    input logic [PWIDTH-1:0] bwptr,
    input logic full,
    input logic rclk, rrst_n,
    input logic ren,
    input logic [PWIDTH-1:0] brptr,
    input logic empty,
    
    input logic  [DWIDTH-1:0] data_in, 
    output logic [DWIDTH-1:0] data_out
  );
  
  logic [DWIDTH-1:0] fifo_mem [0:DEPTH-1];
  
  always @(posedge wclk) begin
    if(wen && !full)
      fifo_mem[bwptr[PWIDTH-1:0]] <= data_in;
  end
  
  always_ff @(posedge rclk or negedge rrst_n) begin
    if(!rrst_n)
      data_out <= '0;
    else if(ren && !empty)
      data_out <= fifo_mem[brptr[PWIDTH-1:0]];
  end
endmodule
      
