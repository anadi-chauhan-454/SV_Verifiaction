class alu_tr#(parameter int WIDTH = 4);
  
  static int unsigned count = 0;
  int unsigned txn_id;
  time timestamp;
  
  rand bit [WIDTH-1:0] a;
  rand bit [WIDTH-1:0] b;
  rand alu_opt_t sel;
  rand bit [$clog2(WIDTH)-1:0] shamt;
  
  bit [WIDTH-1:0] result;
  status_flags_t flags;
  
    constraint c_shamt {
    shamt < WIDTH;
}
  
  function new();
    txn_id  = count++;
    timestamp = $time;
  endfunction
  
  function string convert2string();
        return $sformatf(
          "ID=%0d, TIME=%0t, | a=%0d, b=%0d, Operation = %s, shamt=%0d, | result=%0d, carry=%0d, 				   negative=%0d, overflow=%0d, zero=%0d",
      	   txn_id, timestamp, a, b, sel.name(), shamt, result, flags.carry, flags.negative, flags.overflow, 		   flags.zero	
   );
  endfunction
  
  function string sprint();
    return convert2string();
  endfunction
  
  function void display(string prefix = "");
      if (prefix == "")
        $display("%s", convert2string());
    else
        $display("[%s] %s", prefix, convert2string());
  endfunction
  

  
  function alu_tr #(WIDTH) copy();
    alu_tr #(WIDTH) copy_obj;
    copy_obj = new();
    
    copy_obj.a = this.a;
    copy_obj.b = this.b;
    copy_obj.sel = this.sel;
    copy_obj.shamt = this.shamt;
    copy_obj.result = this.result;
    copy_obj.flags = this.flags;
    
    copy_obj.txn_id = this.txn_id;
    copy_obj.timestamp = this.timestamp;
    return copy_obj;
  endfunction
  
  function bit compare(alu_tr #(WIDTH) tr);
    return (this.result == tr.result &&
            this.flags == tr.flags
           );
  endfunction
endclass
  
