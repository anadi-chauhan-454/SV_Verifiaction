class asfifo_tr #(int DWIDTH=16);
  
  static int unsigned count = 0;
  int unsigned txn_id;
  time timestamp;
  
  //write transactions
  rand bit wen;
  rand bit [DWIDTH-1:0] data_in;
  
  //read transactions
  rand bit ren;
  
  
  //outputs
  bit full;
  bit empty;
  
  bit [DWIDTH-1:0] data_out;
  
  function new();
    txn_id = count++;
    timestamp = $time;
  endfunction
  
  constraint read_write_en {
    !(wen && ren);
  }
  
  constraint write_only {
    wen dist{0 := 10, 1 := 90};
    ren == 0;
  }
  
  constraint read_only {
    wen == 0;
    ren dist{0 := 40, 1 := 60};
  }
  
  constraint no_write {
    !(wen && full);
  }
  
  constraint no_read {
    !(ren && empty);
  }
  
  
  function string convert2string();
    return $sformatf("Id=%0d, time=%0t | wen=%0d, in=%0h, | ren=%0d, | full=%0d, empty=%0d, | out=%0h",
                      txn_id,  timestamp, wen,     data_in,  ren,       full,     empty,       data_out
                    );
  endfunction
  
  function string sprint();
    return convert2string();
  endfunction
  
  function void display(string prefix="");
    if(prefix.len() == 0)
      $display("%s", sprint());
    else
      $display("[%s] %s", prefix, sprint());
  endfunction
  
  function asfifo_tr #(DWIDTH) copy();
    asfifo_tr copy_obj;
    copy_obj = new();
    
    copy_obj.wen = this.wen;
    copy_obj.data_in = this.data_in;
    
    copy_obj.ren = this.ren;
    
    copy_obj.full = this.full;
    copy_obj.empty = this.empty;
    
    copy_obj.data_out = this.data_out;
    
    copy_obj.txn_id = this.txn_id;
    copy_obj.timestamp = this.timestamp;
    
    return copy_obj;
  endfunction
  
            
  
  function bit rcompare(asfifo_tr #(DWIDTH) tr);
    return (this.data_out == tr.data_out &&
            this.empty == tr.empty);
  endfunction
  
    function bit wcompare(asfifo_tr #(DWIDTH) tr);
    return (this.full == tr.full);
  endfunction
endclass
    
