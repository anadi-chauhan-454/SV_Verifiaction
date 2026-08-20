`include "asfifo_pkg.sv"
`include "asfifo_if.sv"
`include "asfifo_assertions.sv"
`include "asfifo_bind.sv"

module tb_top;
  localparam int DWIDTH = 16;
  localparam int DEPTH = 16;
  localparam int PWIDTH = 5;
  
  localparam int WCLK = 10;
  localparam int RCLK = 5;
  
  import asfifo_pkg::*;
  
  logic wclk, wrst_n;
  logic rclk, rrst_n;
  
  initial begin
    wclk = 0;
    rclk = 0;
  end
  
  always #(WCLK) wclk = ~wclk;
  always #(RCLK) rclk = ~rclk;
  
  initial begin 
    wrst_n = 0;
    repeat(2) @(posedge wclk);
    wrst_n = 1;
  end
  
  initial begin 
    rrst_n = 0;
    repeat(2) @(posedge rclk);
    rrst_n = 1;
  end
  
  asfifo_if #(DWIDTH) vif(
    .wclk(wclk),
    .rclk(rclk),
    .wrst_n(wrst_n),
    .rrst_n(rrst_n)
  );
  
  asfifo_top #(.DWIDTH(DWIDTH),
               .DEPTH(DEPTH),
               .PWIDTH(PWIDTH)
              ) dut (
    .wclk(vif.wclk),
    .wrst_n(vif.wrst_n),
    .wen(vif.wen),
    .data_in(vif.data_in),
    .rclk(vif.rclk),
    .rrst_n(vif.rrst_n),
    .ren(vif.ren),
    .empty(vif.empty),
    .full(vif.full),
    .data_out(vif.data_out)
  );
  
  asfifo_base_test #(DWIDTH) test;
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0,tb_top);
  end
  
  initial begin
    //asfifo_sanity_test #(DWIDTH) test_inst;
    asfifo_random_test #(DWIDTH) test_inst;
    //asfifo_read_only_test #(DWIDTH) test_inst;
    //asfifo_write_only_test #(DWIDTH) test_inst;
    test_inst = new(vif);
    test  = test_inst;

    test.run();
  end

endmodule
    
  
