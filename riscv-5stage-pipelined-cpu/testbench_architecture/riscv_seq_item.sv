import riscv_pkg::*;

class riscv_seq_item #(int WIDTH=32, int REG_ADDR=5) extends uvm_sequence_item;
  
  rand bit imem_wen;
  
  rand bit [WIDTH-1:0] imem_wda;
  bit [WIDTH-1:0] imem_wd;
  
  rand opcode_sel opcode;
  rand bit [REG_ADDR-1:0] rs1;
  rand bit [REG_ADDR-1:0] rs2;
  rand bit [REG_ADDR-1:0] rd;
  rand bit [2:0] funct3;
  rand bit [6:0] funct7;
  rand bit [WIDTH-1:0] imm;
  
 `uvm_object_param_utils_begin(riscv_seq_item #(WIDTH, REG_ADDR))
  
  `uvm_field_int(imem_wen, UVM_ALL_ON)
  `uvm_field_int(imem_wda, UVM_ALL_ON)
  `uvm_field_int(imem_wd,  UVM_ALL_ON)
  `uvm_field_enum(opcode_sel, opcode, UVM_ALL_ON)
  `uvm_field_int(rs1, UVM_ALL_ON)
  `uvm_field_int(rs2, UVM_ALL_ON)
  `uvm_field_int(rd, UVM_ALL_ON)
  `uvm_field_int(funct3, UVM_ALL_ON)
  `uvm_field_int(funct7, UVM_ALL_ON)
  `uvm_field_int(imm, UVM_ALL_ON)
  
  `uvm_object_utils_end
  
  function new(string name="riscv_seq_item");
    super.new(name);
  endfunction
  
  function void encode();
	 imem_wd = {funct7,rs2,rs1,funct3,rd,opcode};
  endfunction
  
  function string convert2string();
    return $sformatf("imem_wn=%0d, imem_wda=%0d, imem_wd=%0d, opcode=%0s, rs1=%0d, rs2=%0d, rd=%0d,      					   funct3=%0d, funct7=%0d, imm=%0d",
                      imem_wen, imem_wda, imem_wd, opcode.name(), rs1, rs2, rd, funct3, funct7, imm);
  endfunction
  
  function void post_randomize();
    encode();
  endfunction
  
endclass
    
  
  
