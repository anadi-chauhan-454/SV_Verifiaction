interface uart_if #(parameter int WIDTH=8)
  (
    input logic clk,
    input	logic rst_n
  );
    
     logic [WIDTH-1:0] data_in;
     logic [WIDTH-1:0] data_out;
	 logic tx_start;
    
	 logic tx;
	 logic rx;
  
     logic baud_tick;
    
	 logic parity_en;
	 logic parity_type;
	 logic stop_bits;
    
	 logic tx_busy;
	 logic tx_done;
	 logic rx_busy;
	 logic rx_done;
    
     logic frame_error;
     logic parity_error;
  
  clocking uart_drv_cb @(posedge clk);
    default input #1step output #1;
    input tx_busy, tx_done, rx_busy, rx_done;
    input frame_error, parity_error;
    input tx;
    input  data_out;
    output data_in;
    output baud_tick;
    output rx;
    output tx_start;
    output parity_en, parity_type, stop_bits;
  endclocking
    
  clocking uart_mon_cb @(posedge clk);
    default input #1step output #1;
    input tx_busy, tx_done, rx_busy, rx_done;
    input frame_error, parity_error;
    input tx;
    input baud_tick;
    input data_out;
    input data_in;
    input rx;
    input tx_start;
    input parity_en, parity_type, stop_bits;
  endclocking
  
endinterface
  
  
  
