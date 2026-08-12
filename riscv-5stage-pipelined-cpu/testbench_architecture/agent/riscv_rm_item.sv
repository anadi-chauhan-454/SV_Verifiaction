class riscv_rm_item #(int WIDTH=32, int REG_ADDR=5) extends uvm_sequence_item;
  
  bit [WIDTH-1:0] exp_pcW_cpu;
  bit [WIDTH-1:0] exp_instrW_cpu;
  
  bit exp_wd_reg_cpu;
  bit [REG_ADDR-1:0] exp_wda_reg_cpu;
  bit [WIDTH-1:0] exp_wd_cpu;
  
  bit exp_mr_cpu;
  bit exp_mw_cpu;
  bit [WIDTH-1:0] exp_maddr_cpu;
  bit [WIDTH-1:0] exp_mwdata_cpu;
  bit [WIDTH-1:0] exp_mrdata_cpu;
  bit exp_valid_cpu;
  bit exp_mem_valid_cpu;

  `uvm_object_param_utils_begin(riscv_rm_item #(WIDTH, REG_ADDR))
  
  `uvm_field_int(exp_pcW_cpu, UVM_ALL_ON)
  `uvm_field_int(exp_instrW_cpu, UVM_ALL_ON)
  `uvm_field_int(exp_wd_reg_cpu, UVM_ALL_ON)
  `uvm_field_int(exp_wda_reg_cpu, UVM_ALL_ON)
  `uvm_field_int(exp_wd_cpu, UVM_ALL_ON)
  `uvm_field_int(exp_mr_cpu, UVM_ALL_ON)
  `uvm_field_int(exp_mw_cpu, UVM_ALL_ON)
  `uvm_field_int(exp_maddr_cpu, UVM_ALL_ON)
  `uvm_field_int(exp_mwdata_cpu, UVM_ALL_ON)
  `uvm_field_int(exp_mrdata_cpu, UVM_ALL_ON)
  `uvm_field_int(exp_valid_cpu, UVM_ALL_ON)
  `uvm_field_int(exp_mem_valid_cpu, UVM_ALL_ON)
  
  `uvm_object_utils_end
  
  function new(string name="riscv_rm_item");
    super.new(name);
  endfunction
endclass
