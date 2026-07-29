module uart_assertions #(
    parameter int WIDTH = 8
) (
    input logic clk,
    input logic rst_n,

    input logic parity_en,
    input logic parity_type,
    input logic stop_bits,
    input logic tx_start,
    input logic baud_tick,

    input logic [3:0]            current_state,
    input logic [$clog2(WIDTH):0] bit_count,

    input logic tx,
    input logic tx_busy,
    input logic tx_done,

    input logic rx,
    input logic rx_busy,
    input logic rx_done,
    input logic frame_error,
    input logic parity_error
);

  localparam logic [3:0] IDLE   = 4'b0000;
  localparam logic [3:0] START  = 4'b0001;
  localparam logic [3:0] DATA   = 4'b0010;
  localparam logic [3:0] PARITY = 4'b0011;
  localparam logic [3:0] STOP   = 4'b0100;
  
    property tx_rx_not_together;
      @(posedge clk) disable iff (!rst_n) !(tx_start && !rx);
  endproperty
  a_tx_rx_not_together: assert property (tx_rx_not_together)
    else $error("[SVA FAIL] Half-Duplex Violation: tx and rx active concurrently!");

  property tx_rx_busy_not_together;
    @(posedge clk) disable iff (!rst_n) !(tx_busy && rx_busy);
  endproperty
    a_tx_busy_rx_not_together: assert property (tx_rx_busy_not_together)
    else $error("[SVA FAIL] Half-Duplex Violation: tx_busy and rx_busy active concurrently!");

  property rxbusy_no_txstart;
    @(posedge clk) disable iff (!rst_n) rx_busy |-> !tx_start;
  endproperty
  a_rxbusy_no_txstart: assert property (rxbusy_no_txstart)
    else $error("[SVA FAIL] Half-Duplex Violation: tx_start issued while rx_busy is active!");

  property txdone_rxbusy_no;
    @(posedge clk) disable iff (!rst_n) tx_done |=> !rx_busy;
  endproperty
  a_txdone_rxbusy_no: assert property (txdone_rxbusy_no)
    else $error("[SVA FAIL] Half-Duplex Violation: RX started without bus turnaround time!");

  property transmission_start;
    @(posedge clk) disable iff (!rst_n) (current_state == START) |-> (tx == 1'b0);
  endproperty
  a_transmission_start: assert property (transmission_start)
    else $error("[SVA FAIL] Start bit (logic 0) was not driven on tx line during START!");

  property done_busy_rx;
    @(posedge clk) disable iff (!rst_n) rx_done |=> !rx_busy;
  endproperty
  a_done_busy_rx: assert property (done_busy_rx)
    else $error("[SVA FAIL] rx_busy remained HIGH after rx_done!");

  property frame_parity_rx;
    @(posedge clk) disable iff (!rst_n) (frame_error || parity_error) |-> !rx_done;
  endproperty
  a_frame_parity_rx: assert property (frame_parity_rx)
    else $error("[SVA FAIL] rx_done asserted simultaneously with frame_error or parity_error!");

  c_tx_transaction: cover property (
    @(posedge clk) disable iff (!rst_n) tx_start ##1 tx_busy [*1:$] ##1 tx_done
  );

  c_rx_transaction: cover property (
    @(posedge clk) disable iff (!rst_n) $rose(rx_busy) ##1 rx_busy [*1:$] ##1 rx_done
  );

  c_parity_path: cover property (
    @(posedge clk) disable iff (!rst_n) parity_en && (current_state == PARITY)
  );

  c_parity_error: cover property (
    @(posedge clk) disable iff (!rst_n) parity_error
  );

  c_frame_error: cover property (
    @(posedge clk) disable iff (!rst_n) frame_error
  );

  c_2_stop_bits: cover property (
    @(posedge clk) disable iff (!rst_n) stop_bits && (current_state == STOP)
  );

endmodule
