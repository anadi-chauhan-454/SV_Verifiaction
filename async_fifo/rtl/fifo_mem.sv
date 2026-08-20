module fifo_mem #(
  int DWIDTH = 16,
  int DEPTH  = 16,
  int PWIDTH = $clog2(DEPTH) + 1
)
(
  input logic wclk,
  input logic wen,
  input logic [PWIDTH-1:0] bwptr,
  input logic full,

  input logic rclk,
  input logic rrst_n,
  input logic ren,
  input logic [PWIDTH-1:0] brptr,
  input logic empty,

  input  logic [DWIDTH-1:0] data_in,
  output logic [DWIDTH-1:0] data_out
);

  localparam int ADDR_WIDTH = $clog2(DEPTH);
  logic [DWIDTH-1:0] fifo_mem [0:DEPTH-1];

  always_ff @(posedge wclk) begin
    if (wen && !full)
      fifo_mem[bwptr[ADDR_WIDTH-1:0]] <= data_in;
  end

  always_ff @(posedge rclk or negedge rrst_n) begin
    if (!rrst_n) begin
      data_out <= '0;
    end
    else if (ren && !empty) begin
      data_out <= fifo_mem[brptr[ADDR_WIDTH-1:0]];
    end

  end

endmodule
