module asfifo_assertions #(
  int PWIDTH=4
)
  (
    input logic wclk, rclk,
    input logic wrst_n, rrst_n,
    input logic full, empty,
    input logic wen , ren,
    input logic [PWIDTH-1:0] bwptr, brptr
  );
  
  property full_empty_not_together;
    @(posedge wclk or posedge rclk) disable iff(!wrst_n or !rrst_n) !(full && empty);
  endproperty
  a_full_empty: assert property(full_empty_not_together)
    else $error("FIFO cannot be FULL and EMPTY simultaneously");
    
  property write_reset;
    @(posedge wclk) !wrst_n |-> !wen;
  endproperty
  a_write_reset: assert property(write_reset)
    else $error("wen and data should be zero when reset");
    
  property read_reset;
    @(posedge rclk) !rrst_n |=> !ren;
  endproperty
  a_read_reset: assert property(read_reset)
    else $error("ren and dat out should be zero when reset");
      
  property no_write_full;
  @(posedge wclk) (full && wen) |=> $stable(bwptr);
  endproperty
  a_no_write_full: assert property(no_write_full)
    else $error("Can't write when FIFO is full");
    
  property no_read_empty;
    @(posedge rclk) (empty && ren) |=> $stable(brptr);
  endproperty
    a_no_read_empty: assert property(no_read_empty)
    else $error("Can't read when fifo is empty");
    
      
   write_full: cover property(
     @(posedge wclk) disable iff(!wrst_n) full);
     
   read_empty: cover property(
     @(posedge rclk) diasavle iff(1rrst_n) empty);
  
endmodule    
