class uart_tr #(int WIDTH=8);
  
  static int unsigned count = 0;
  int unsigned txn_id;
  time timestamp;
  
  rand bit [WIDTH-1:0] data_in;
  rand bit parity_en;
  rand bit parity_type;
  rand bit stop_bits;
  rand bit tx_start;
  rand bit rx;
  
  bit [WIDTH-1:0] data_out;
  bit tx;
  bit tx_busy;
  bit tx_done;
  bit rx_busy;
  bit rx_done;
  
  bit frame_error;
  bit parity_error;
  
  bit serial_stream[$]; 
  
  rand bit inject_parity_err;
  rand bit inject_frame_err;
  
  constraint c_default {
    tx_start dist {0 := 3, 1 := 97};
    rx dist {0 := 97, 1 := 3};
    inject_parity_err dist {0 := 90, 1 := 10};
    inject_frame_err  dist {0 := 95, 1 := 5};
  }
  
  
  function new();
    txn_id = count++;
    timestamp = $time;
  endfunction
  
  function string convert2string();
    return $sformatf("ID=%0d, time=%0t, | data_in=%0d, parity_en=%0d, parity_type=%0d, stop_bits=%0d, tx_start=%0d, rx=%0d, | data_out=%0d, tx=%0d, tx_busy=%0d, tx_done=%0d, rx_busy=%0d, rx_done=%0d, frame_error=%0d, parity_error=%0d, Stream Size=%0d",
                     txn_id, timestamp, data_in, parity_en, parity_type, stop_bits, tx_start, rx, data_out, tx, tx_busy, tx_done, rx_busy, rx_done, frame_error, parity_error, serial_stream.size());
  endfunction
  
  function string sprint();
    return convert2string();
  endfunction
  
  function void display(string prefix="");
    if(prefix=="")
      $display("%s",convert2string());
    else
      $display("[%s] %s", prefix, convert2string());
  endfunction
  
  function uart_tr #(WIDTH) copy();
    uart_tr copy_obj;
    copy_obj = new();
    
    copy_obj.data_in = this.data_in; 
    copy_obj.parity_en = this.parity_en;
    copy_obj.parity_type = this.parity_type;
    copy_obj.stop_bits = this.stop_bits;
    copy_obj.tx_start = this.tx_start;
    copy_obj.rx = this.rx;
    
    copy_obj.inject_parity_err = this.inject_parity_err;
    copy_obj.inject_frame_err  = this.inject_frame_err;
    
    copy_obj.data_out = this.data_out;
    copy_obj.tx = this.tx;
    copy_obj.tx_busy = this.tx_busy;
    copy_obj.tx_done = this.tx_done;
    copy_obj.rx_busy = this.rx_busy;
    copy_obj.rx_done = this.rx_done;
    
    copy_obj.frame_error = this.frame_error;
    copy_obj.parity_error = this.parity_error;
    
    copy_obj.serial_stream = this.serial_stream;
    
    copy_obj.txn_id = this.txn_id;
	copy_obj.timestamp = this.timestamp;
    
    return copy_obj;
  endfunction

  function bit compare(uart_tr #(WIDTH) tr);
    if (this.tx_start) begin
      return (this.serial_stream == tr.serial_stream);
    end else begin
      return (this.data_out     == tr.data_out)     &&
             (this.frame_error  == tr.frame_error)  &&
             (this.parity_error == tr.parity_error);
    end
  endfunction
endclass
  
