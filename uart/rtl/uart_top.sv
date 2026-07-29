`include "baud_tick_gen.sv"
`include "uart_tx.sv"
`include "uart_rx.sv"
module uart_top #(
  parameter int WIDTH = 8,
  parameter int CLK_FREQ = 50_000_000,
  parameter int BAUD_RATE = 9600
)
  (
    input logic clk,
    input logic rst_n,
    
    input logic [WIDTH-1:0] data_in,
    output logic [WIDTH-1:0] data_out,
    input logic tx_start,
    
    output logic tx,
    input logic rx,
    
    input logic parity_en,
    input logic parity_type,
    input logic stop_bits,
    
    output logic tx_busy,
    output logic tx_done,
    output logic rx_busy,
    output logic rx_done,
    
    output logic frame_error,
    output logic parity_error
  );
  
  logic baud_tick;
  logic baud_en;
  
  
  assign baud_en = tx_busy | rx_busy;
  
  baud_tick_gen #(.CLK_FREQ(CLK_FREQ), .BAUD_RATE(BAUD_RATE))
  u_baud_gen (
    .clk(clk),
    .rst_n(rst_n),
    .en(baud_en),
    .baud_tick(baud_tick)
  );
  
  uart_tx #(.WIDTH(WIDTH))
  u_tx (
    .clk(clk),
    .rst_n(rst_n),
    .data_in(data_in),
    .baud_tick(baud_tick),
    .tx_start(tx_start),
    .parity_en(parity_en),
    .parity_type(parity_type),
    .stop_bits(stop_bits),
    .tx(tx),
    .tx_busy(tx_busy),
    .tx_done(tx_done)
  );
  
    uart_rx #(.WIDTH(WIDTH))
    u_rx (
      .clk(clk),
      .rst_n(rst_n),
      .rx(rx),
      .parity_type(parity_type),
      .parity_en(parity_en),
      .stop_bits(stop_bits),
      .baud_tick(baud_tick),
      .data_out(data_out),
      .rx_busy(rx_busy),
      .rx_done(rx_done),
      .frame_error(frame_error),
      .parity_error(parity_error)
  );
  
  
endmodule
  

  
  
