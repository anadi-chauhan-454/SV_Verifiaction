interface asfifo_if #(int DWIDTH=16)
  (input logic wclk, rclk,
   input logic wrst_n, rrst_n);
  
  logic wen;
  logic ren;
  logic [DWIDTH-1:0] data_in;
  logic [DWIDTH-1:0] data_out;
  logic full;
  logic empty;
  
  clocking wdrv_cb @(posedge wclk);
    default input #0 output #0;
    input full;
    output data_in;
    output wen;
  endclocking
  
  clocking rdrv_cb @(posedge rclk);
    default input #0 output #0;
    input data_out;
    input empty;
    output ren;
  endclocking
  
  clocking wmon_cb @(posedge wclk);
    default input #0 output #0;
    input full;
    input data_in;
    input wen;
  endclocking
  
  clocking rmon_cb @(posedge rclk);
    default input #0 output #0;
    input data_out;
    input empty;
    input ren;
  endclocking
endinterface
