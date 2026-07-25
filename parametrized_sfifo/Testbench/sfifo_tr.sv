class sfifo_tr#(
  parameter int DWIDTH = 8
);
  
  static int unsigned count = 0;
  int unsigned txn_id;
  time timestamp;
  
  rand bit wen;
  rand bit ren;
  rand bit [DWIDTH-1:0] data_in;
  bit [DWIDTH-1:0] data_out;
  status_flag_t flags;
  
  function new();
    txn_id = count++;
    timestamp = $time;
  endfunction
  
  function string convert2string();
    return $sformatf(
    		"ID=%0d, TIME=%0t, | wen=%0d, ren=%0d, dataIn=%0d, | dataOut=%0d, full=%0d, empty=%0d, overflow=%0d, underflow=%0d",
      	         txn_id, timestamp, wen, ren, data_in, data_out, flags.full, flags.empty, flags.overflow, flags.underflow
    );
  endfunction
  
  function string sprint();
    return convert2string();
  endfunction
  
  function void display(string prefix="");
    if(prefix=="")
      $display("%s", convert2string());
    else
      $display("[%s] %s", prefix, convert2string());
  endfunction
  
  function sfifo_tr #(DWIDTH) copy();
    sfifo_tr #(DWIDTH) copy_obj;
    copy_obj = new();
    
    copy_obj.wen = this.wen;
    copy_obj.ren = this.ren;
    copy_obj.data_in = this.data_in;
    copy_obj.data_out = this.data_out;
    copy_obj.flags = this.flags;
    copy_obj.txn_id = this.txn_id;
    copy_obj.timestamp = this.timestamp;
    
    return copy_obj;
  endfunction
  
  function bit compare(sfifo_tr #(DWIDTH) tr);
    return (this.data_out == tr.data_out &&
            this.flags == tr.flags);
  endfunction
endclass
  
    
