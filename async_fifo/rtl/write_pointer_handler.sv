module write_pointer_handler #(int PWIDTH=4)
  (
    input logic  wclk, wrst_n,
    input logic  wen,
    input logic  [PWIDTH-1:0] grptr_sync,
    output logic [PWIDTH-1:0] bwptr, gwptr,
    output logic full
  );
  
  logic [PWIDTH-1:0] bwptr_next, gwptr_next;
  logic w_full;
  
  assign bwptr_next = bwptr + (wen && !full);
  assign gwptr_next = {bwptr_next[PWIDTH-1], bwptr_next[PWIDTH-1:1] ^ bwptr_next[PWIDTH-2:0]};
  
  assign w_full = (grptr_sync == {~gwptr_next[PWIDTH-1:PWIDTH-2],gwptr_next[PWIDTH-3:0]});
  
  always_ff @(posedge wclk or negedge wrst_n) begin
    if(!wrst_n) begin
      bwptr <= '0;
      gwptr <= '0;
      full  <=  1'b0;
    end
    else begin
      bwptr <= bwptr_next;
      gwptr <= gwptr_next;
      full  <= w_full;
    end
  end
endmodule
      
