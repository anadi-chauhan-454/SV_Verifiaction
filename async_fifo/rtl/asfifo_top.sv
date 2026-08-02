`include "write_pointer_handler.sv"
`include "read_pointer_handler.sv"
`include "ff_synchronizer.sv"
`include "fifo_mem.sv"

module asfifo_top #(
     int DWIDTH = 8,
     int DEPTH  = 8,
     int PWIDTH = 4
)(
    input  logic wclk,
    input  logic wrst_n,
    input  logic wen,
    input  logic [DWIDTH-1:0] data_in,

    input  logic rclk,
    input  logic rrst_n,
    input  logic ren,

    output logic empty,
    output logic full,
    output logic [DWIDTH-1:0] data_out
);

logic [PWIDTH-1:0] bwptr, brptr;
logic [PWIDTH-1:0] gwptr, grptr;
logic [PWIDTH-1:0] gwptr_sync, grptr_sync;

two_ff_synchronizer #(
    .PWIDTH(PWIDTH)
) W2FF (
    .clk(wclk),
    .rst_n(wrst_n),
    .iptr(grptr),
    .optr(grptr_sync)
);

two_ff_synchronizer #(
    .PWIDTH(PWIDTH)
) R2FF (
    .clk(rclk),
    .rst_n(rrst_n),
    .iptr(gwptr),
    .optr(gwptr_sync)
);

write_pointer_handler #(
    .PWIDTH(PWIDTH)
) WPTH (
    .wclk(wclk),
    .wrst_n(wrst_n),
    .wen(wen),
    .grptr_sync(grptr_sync),
    .bwptr(bwptr),
    .gwptr(gwptr),
    .full(full)
);

read_pointer_handler #(
    .PWIDTH(PWIDTH)
) RPTH (
    .rclk(rclk),
    .rrst_n(rrst_n),
    .ren(ren),
    .gwptr_sync(gwptr_sync),
    .brptr(brptr),
    .grptr(grptr),
    .empty(empty)
);

fifo_mem #(
    .DWIDTH(DWIDTH),
    .DEPTH(DEPTH),
    .PWIDTH(PWIDTH)
) FMEM (
    .wclk(wclk),
    .wen(wen),
    .bwptr(bwptr),
    .full(full),
    .rclk(rclk),
    .rrst_n(rrst_n),
    .ren(ren),
    .brptr(brptr),
    .empty(empty),
    .data_in(data_in),
    .data_out(data_out)
);

endmodule
