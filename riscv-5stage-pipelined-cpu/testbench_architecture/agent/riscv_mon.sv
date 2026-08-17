class riscv_mon_item #(int WIDTH=32, int REG_ADDR=5) extends uvm_sequence_item;
  
  bit [WIDTH-1:0] pcW_cpu;
  bit [WIDTH-1:0] instrW_cpu;
  
  bit wd_reg_cpu;
  bit [REG_ADDR-1:0] wda_reg_cpu;
  bit [WIDTH-1:0] wd_cpu;
  
  bit mr_cpu;
  bit mw_cpu;
  bit [WIDTH-1:0] maddr_cpu;
  bit [WIDTH-1:0] mwdata_cpu;
  bit [WIDTH-1:0] mrdata_cpu;
  bit valid_cpu;
  bit mem_valid_cpu;
  
  `uvm_object_param_utils_begin(riscv_mon_item #(WIDTH, REG_ADDR))
  
  `uvm_field_int(pcW_cpu, UVM_ALL_ON)
  `uvm_field_int(instrW_cpu, UVM_ALL_ON)
  `uvm_field_int(wd_reg_cpu, UVM_ALL_ON)
  `uvm_field_int(wda_reg_cpu, UVM_ALL_ON)
  `uvm_field_int(wd_cpu, UVM_ALL_ON)
  `uvm_field_int(mr_cpu, UVM_ALL_ON)
  `uvm_field_int(mw_cpu, UVM_ALL_ON)
  `uvm_field_int(maddr_cpu, UVM_ALL_ON)
  `uvm_field_int(mwdata_cpu, UVM_ALL_ON)
  `uvm_field_int(mrdata_cpu, UVM_ALL_ON)
  `uvm_field_int(valid_cpu, UVM_ALL_ON)
  `uvm_field_int(mem_valid_cpu, UVM_ALL_ON)
  
  `uvm_object_utils_end
  
  function new(string name="riscv_mon_item");
    super.new(name);
  endfunction
  
  function string convert2string();
    return $sformatf("pcW=%0d, instrW=%0d, wd_reg=%0d, wda_reg=%0d, wd=%0d, mr=%0d, mw=%0d, maddr=%0d,     					   mwdata=%0d, mrdata=%0d, valid=%0d, mem_valid=%0d",
                      pcW_cpu, instrW_cpu, wd_reg_cpu, wda_reg_cpu, wd_cpu, mr_cpu, mw_cpu, maddr_cpu, 						  mwdata_cpu, mrdata_cpu, valid_cpu, mem_valid_cpu);
  endfunction
  
endclass
  
