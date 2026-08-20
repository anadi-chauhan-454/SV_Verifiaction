module read_pointer_handler #(int PWIDTH=5)
  (
    input logic  rclk, rrst_n,
    input logic  ren,
    input logic  [PWIDTH-1:0] gwptr_sync,
    output logic [PWIDTH-1:0] brptr, grptr,
    output logic empty
  );
  
  logic [PWIDTH-1:0] brptr_next, grptr_next;
  logic r_empty;
  
  assign brptr_next = brptr + (ren && !empty);
  assign grptr_next = {brptr_next[PWIDTH-1], brptr_next[PWIDTH-1:1]^brptr_next[PWIDTH-2:0]};
  
  assign r_empty = (gwptr_sync == grptr_next);
  
  always_ff @(posedge rclk or negedge rrst_n) begin
    if(!rrst_n) begin
      brptr <= '0;
      grptr <= '0;
      empty <=  1'b1;
    end
    else begin
      brptr <= brptr_next;
      grptr <= grptr_next;
      empty <= r_empty;
    end
  end
endmodule
