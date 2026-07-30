class uart_cov#(int WIDTH=8); 
  uart_tr #(WIDTH) tr; 
  
  covergroup uart_cg with function sample(uart_tr #(WIDTH) tr); 
    
    data_cp: coverpoint tr.data_in{ 
      bins zero = {8'h00}; 
      bins max = {8'hFF}; 
      bins low[] = {[8'h01:8'h3F]}; 
      bins mid[] = {[8'h40:8'hBF]}; 
      bins high[] = {[8'hC0:8'hFE]}; 
    }; 
    
    parity_cp: coverpoint tr.parity_en;
    
    parity_type_cp: coverpoint tr.parity_type; 
    
    stop_cp: coverpoint tr.stop_bits; 
    
    frame_error_cp: coverpoint tr.frame_error; 
    
    parity_error_cp: coverpoint tr.parity_error; 
    
    tx_done_cp: coverpoint tr.tx_done; 
    
    rx_done_cp: coverpoint tr.rx_done; 
    
    parity_stop_cross: cross parity_cp, stop_cp; 
    
    parity_type_cross: cross parity_cp, parity_type_cp; 
    
    frame_stop_cross: cross frame_error_cp, stop_cp; 
  endgroup 
  
  function new(); 
    uart_cg = new(); 
  endfunction 
  
  function void write(uart_tr #(WIDTH) tr); 
    uart_cg.sample(tr); 
  endfunction
endclass
