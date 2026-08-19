class riscv_ref_model #(int WIDTH=32, int REG_ADDR=5) extends uvm_component;

  `uvm_component_param_utils(riscv_ref_model #(WIDTH, REG_ADDR))

  uvm_tlm_analysis_fifo #(riscv_seq_item #(32,5)) in_fifo;

  uvm_analysis_port #(riscv_rm_item #(32,5)) ap;

  bit [WIDTH-1:0] regs [0:(1<<REG_ADDR)-1];
  bit [WIDTH-1:0] imem [0:1023];
  bit [WIDTH-1:0] dmem [0:1023];

  bit [WIDTH-1:0] pc;

  typedef struct packed {
    bit valid;
    bit [WIDTH-1:0] pc;
    bit [WIDTH-1:0] instr;
  } if_id_t;

  typedef struct packed {
    bit valid;
    bit [WIDTH-1:0] pc;
    bit [WIDTH-1:0] instr;
    bit [WIDTH-1:0] rd1;
    bit [WIDTH-1:0] rd2;
    bit [WIDTH-1:0] imm;
    bit [REG_ADDR-1:0] rs1;
    bit [REG_ADDR-1:0] rs2;
    bit [REG_ADDR-1:0] rd;
    bit [2:0] funct3;
    bit [6:0] funct7;
    bit reg_write;
    bit mem_write;
    bit mem_read;
    bit mem_to_reg;
    bit alu_src;
    bit branch;
    bit [1:0] alu_op;
    bit reg_file_sel;
  } id_ex_t;

  typedef struct packed {
    bit valid;
    bit [WIDTH-1:0] pc;
    bit [WIDTH-1:0] instr;
    bit [WIDTH-1:0] alu_result;
    bit [WIDTH-1:0] store_data;
    bit [REG_ADDR-1:0] rd;
    bit [2:0] funct3;
    bit reg_write;
    bit mem_write;
    bit mem_read;
    bit mem_to_reg;
    bit branch;
    bit zero;
    bit [WIDTH-1:0] branch_target;
  } ex_mem_t;

  typedef struct packed {
    bit valid;
    bit [WIDTH-1:0] pc;
    bit [WIDTH-1:0] instr;
    bit [WIDTH-1:0] alu_result;
    bit [WIDTH-1:0] mem_data;
    bit [REG_ADDR-1:0] rd;
    bit reg_write;
    bit mem_to_reg;
  } mem_wb_t;


  if_id_t if_id_q;
  if_id_t if_id_d;

  id_ex_t id_ex_q;
  id_ex_t id_ex_d;

  ex_mem_t ex_mem_q;
  ex_mem_t ex_mem_d;

  mem_wb_t mem_wb_q;
  mem_wb_t mem_wb_d;


  bit [WIDTH-1:0] pc_d;

  bit stall;
  bit flush;

  bit [1:0] forward_a;
  bit [1:0] forward_b;

  bit [WIDTH-1:0] alu_a;
  bit [WIDTH-1:0] alu_b;
  bit [WIDTH-1:0] alu_b_raw;

  bit [WIDTH-1:0] alu_result;
  bit [WIDTH-1:0] branch_target;

  bit branch_taken;

  bit [WIDTH-1:0] mem_read_data;

  bit [WIDTH-1:0] wb_data;

  bit [WIDTH-1:0] rm_pcW;
  bit [WIDTH-1:0] rm_instrW;

  bit rm_wd_reg;
  bit [REG_ADDR-1:0] rm_wda_reg;
  bit [WIDTH-1:0] rm_wd;

  bit rm_mr;
  bit rm_mw;
  bit [WIDTH-1:0] rm_maddr;
  bit [WIDTH-1:0] rm_mwdata;
  bit [WIDTH-1:0] rm_mrdata;

  bit rm_valid;
  bit rm_mem_valid;

    
  function new(string name="riscv_ref_model", uvm_component parent);
    super.new(name, parent);
    pc = '0;
    foreach(regs[i])
      regs[i] = '0;
    foreach(imem[i])
      imem[i] = '0;
    foreach(dmem[i])
      dmem[i] = '0;
    clear_pipeline();
  endfunction


  function void clear_pipeline();

    if_id_q = '0;
    if_id_d = '0;

    id_ex_q = '0;
    id_ex_d = '0;

    ex_mem_q = '0;
    ex_mem_d = '0;

    mem_wb_q = '0;
    mem_wb_d = '0;

  endfunction


  function void reset();

    pc = '0;

    foreach(regs[i])
      regs[i] = '0;

    foreach(dmem[i])
      dmem[i] = '0;

    clear_pipeline();

  endfunction


  function void load_instruction(
    bit [WIDTH-1:0] address,
    bit [WIDTH-1:0] instruction
  );

    imem[address >> 2] = instruction;

  endfunction


  function void load_data(
    bit [WIDTH-1:0] address,
    bit [WIDTH-1:0] data
  );

    dmem[address >> 2] = data;

  endfunction


  function automatic bit [6:0] get_opcode(
    bit [WIDTH-1:0] instr
  );

    return instr[6:0];

  endfunction


  function automatic bit [REG_ADDR-1:0] get_rs1(
    bit [WIDTH-1:0] instr
  );

    return instr[19:15];

  endfunction


  function automatic bit [REG_ADDR-1:0] get_rs2(
    bit [WIDTH-1:0] instr
  );

    return instr[24:20];

  endfunction


  function automatic bit [REG_ADDR-1:0] get_rd(
    bit [WIDTH-1:0] instr
  );

    return instr[11:7];

  endfunction


  function automatic bit [2:0] get_funct3(
    bit [WIDTH-1:0] instr
  );

    return instr[14:12];

  endfunction


  function automatic bit [6:0] get_funct7(
    bit [WIDTH-1:0] instr
  );

    return instr[31:25];

  endfunction


  function automatic bit [WIDTH-1:0] imm_i(
    bit [WIDTH-1:0] instr
  );

    return {{20{instr[31]}},instr[31:20]};

  endfunction


  function automatic bit [WIDTH-1:0] imm_s(
    bit [WIDTH-1:0] instr
  );

    return {{20{instr[31]}},instr[31:25],instr[11:7]};

  endfunction


  function automatic bit [WIDTH-1:0] imm_b(
    bit [WIDTH-1:0] instr
  );

    return {{19{instr[31]}},
            instr[31],
            instr[7],
            instr[30:25],
            instr[11:8],
            1'b0};

  endfunction


  function automatic bit [WIDTH-1:0] decode_imm(
    bit [WIDTH-1:0] instr
  );

    case(instr[6:0])

      I_TYPE,
      LOAD:
        return imm_i(instr);

      STORE:
        return imm_s(instr);

      BRANCH:
        return imm_b(instr);

      default:
        return '0;

    endcase

  endfunction


  function automatic bit is_reg_write(
    bit [WIDTH-1:0] instr
  );

    case(instr[6:0])

      R_TYPE,
      I_TYPE,
      LOAD:
        return 1'b1;

      default:
        return 1'b0;

    endcase

  endfunction


  function automatic bit is_mem_read(
    bit [WIDTH-1:0] instr
  );

    return instr[6:0] == LOAD;

  endfunction


  function automatic bit is_mem_write(
    bit [WIDTH-1:0] instr
  );

    return instr[6:0] == STORE;

  endfunction


  function automatic bit is_branch(
    bit [WIDTH-1:0] instr
  );

    return instr[6:0] == BRANCH;

  endfunction


  function automatic bit is_mem_to_reg(
    bit [WIDTH-1:0] instr
  );

    return instr[6:0] == LOAD;

  endfunction


  function automatic bit is_alu_src_imm(
    bit [WIDTH-1:0] instr
  );

    case(instr[6:0])

      I_TYPE,
      LOAD,
      STORE:
        return 1'b1;

      default:
        return 1'b0;

    endcase

  endfunction


  function automatic bit [1:0] decode_alu_op(
    bit [WIDTH-1:0] instr
  );

    case(instr[6:0])

      R_TYPE:
        return 2'b10;

      I_TYPE:
        return 2'b10;

      LOAD,
      STORE:
        return 2'b00;

      BRANCH:
        return 2'b01;

      default:
        return 2'b00;

    endcase

  endfunction


  function automatic bit [3:0] alu_control(
    bit [1:0] alu_op,
    bit [2:0] funct3,
    bit [6:0] funct7
  );

    case(alu_op)

      2'b00:
        return 4'b0010;

      2'b01:
        return 4'b0110;

      2'b10:
        begin
          case(funct3)

            3'b000:
              begin
                if(funct7 == 7'b0100000)
                  return 4'b0110;
                else
                  return 4'b0010;
              end

            3'b111:
              return 4'b0000;

            3'b110:
              return 4'b0001;

            3'b100:
              return 4'b0011;

            3'b010:
              return 4'b0111;

            3'b011:
              return 4'b1000;

            3'b001:
              return 4'b1001;

            3'b101:
              begin
                if(funct7 == 7'b0100000)
                  return 4'b1011;
                else
                  return 4'b1010;
              end

            default:
              return 4'b0010;

          endcase
        end

      default:
        return 4'b0010;

    endcase

  endfunction


  function automatic bit [WIDTH-1:0] execute_alu(
    bit [WIDTH-1:0] a,
    bit [WIDTH-1:0] b,
    bit [3:0] control
  );

    case(control)

      4'b0000:
        return a & b;

      4'b0001:
        return a | b;

      4'b0010:
        return a + b;

      4'b0011:
        return a ^ b;

      4'b0110:
        return a - b;

      4'b0111:
        return ($signed(a) < $signed(b)) ? 32'd1 : 32'd0;

      4'b1000:
        return (a < b) ? 32'd1 : 32'd0;

      4'b1001:
        return a << b[4:0];

      4'b1010:
        return a >> b[4:0];

      4'b1011:
        return $signed(a) >>> b[4:0];

      default:
        return '0;

    endcase

  endfunction


  function automatic bit branch_condition(
    bit [2:0] funct3,
    bit [WIDTH-1:0] a,
    bit [WIDTH-1:0] b
  );

    case(funct3)

      3'b000:
        return a == b;

      3'b001:
        return a != b;

      3'b100:
        return $signed(a) < $signed(b);

      3'b101:
        return $signed(a) >= $signed(b);

      3'b110:
        return a < b;

      3'b111:
        return a >= b;

      default:
        return 1'b0;

    endcase

  endfunction


  function void calculate_hazard();

    stall = 1'b0;

    if(!if_id_q.valid)
      return;

    if(!id_ex_q.valid)
      return;

    if(!id_ex_q.mem_read)
      return;

    if(id_ex_q.rd == '0)
      return;

    if(
      (get_rs1(if_id_q.instr) == id_ex_q.rd) ||
      (get_rs2(if_id_q.instr) == id_ex_q.rd)
    )
      stall = 1'b1;

  endfunction


  function void calculate_forwarding();

    forward_a = 2'b00;
    forward_b = 2'b00;

    if(!id_ex_q.valid)
      return;

    if(
      ex_mem_q.valid &&
      ex_mem_q.reg_write &&
      !ex_mem_q.mem_read &&
      (ex_mem_q.rd != '0) &&
      (ex_mem_q.rd == id_ex_q.rs1)
    )
      forward_a = 2'b10;

    else if(
      mem_wb_q.valid &&
      mem_wb_q.reg_write &&
      (mem_wb_q.rd != '0) &&
      (mem_wb_q.rd == id_ex_q.rs1)
    )
      forward_a = 2'b01;


    if(
      ex_mem_q.valid &&
      ex_mem_q.reg_write &&
      !ex_mem_q.mem_read &&
      (ex_mem_q.rd != '0) &&
      (ex_mem_q.rd == id_ex_q.rs2)
    )
      forward_b = 2'b10;

    else if(
      mem_wb_q.valid &&
      mem_wb_q.reg_write &&
      (mem_wb_q.rd != '0) &&
      (mem_wb_q.rd == id_ex_q.rs2)
    )
      forward_b = 2'b01;

  endfunction


  function automatic bit [WIDTH-1:0] forwarding_value(
    bit [1:0] sel,
    bit [WIDTH-1:0] original,
    bit [WIDTH-1:0] mem_value,
    bit [WIDTH-1:0] wb_value
  );

    case(sel)

      2'b10:
        return mem_value;

      2'b01:
        return wb_value;

      default:
        return original;

    endcase

  endfunction


  function void decode_stage();

    bit [6:0] opcode;

    id_ex_d = '0;

    if(!if_id_q.valid)
      return;

    if(stall)
      return;

    opcode = get_opcode(if_id_q.instr);

    id_ex_d.valid = 1'b1;
    id_ex_d.pc = if_id_q.pc;
    id_ex_d.instr = if_id_q.instr;

    id_ex_d.rs1 = get_rs1(if_id_q.instr);
    id_ex_d.rs2 = get_rs2(if_id_q.instr);
    id_ex_d.rd = get_rd(if_id_q.instr);

    id_ex_d.funct3 = get_funct3(if_id_q.instr);
    id_ex_d.funct7 = get_funct7(if_id_q.instr);

    id_ex_d.rd1 = (id_ex_d.rs1 == '0) ? '0 : regs[id_ex_d.rs1];
    id_ex_d.rd2 = (id_ex_d.rs2 == '0) ? '0 : regs[id_ex_d.rs2];

    id_ex_d.imm = decode_imm(if_id_q.instr);

    id_ex_d.reg_write = is_reg_write(if_id_q.instr);
    id_ex_d.mem_read = is_mem_read(if_id_q.instr);
    id_ex_d.mem_write = is_mem_write(if_id_q.instr);
    id_ex_d.mem_to_reg = is_mem_to_reg(if_id_q.instr);
    id_ex_d.alu_src = is_alu_src_imm(if_id_q.instr);
    id_ex_d.branch = is_branch(if_id_q.instr);
    id_ex_d.alu_op = decode_alu_op(if_id_q.instr);

    id_ex_d.reg_file_sel = 1'b0;

  endfunction


  function void execute_stage();

    bit [WIDTH-1:0] wb_forward_value;

    ex_mem_d = '0;

    if(!id_ex_q.valid)
      return;

    calculate_forwarding();

    wb_forward_value = wb_data;

    alu_a = forwarding_value(
      forward_a,
      id_ex_q.rd1,
      ex_mem_q.alu_result,
      wb_forward_value
    );

    alu_b_raw = forwarding_value(
      forward_b,
      id_ex_q.rd2,
      ex_mem_q.alu_result,
      wb_forward_value
    );

    if(id_ex_q.alu_src)
      alu_b = id_ex_q.imm;
    else
      alu_b = alu_b_raw;

    alu_result = execute_alu(
      alu_a,
      alu_b,
      alu_control(
        id_ex_q.alu_op,
        id_ex_q.funct3,
        id_ex_q.funct7
      )
    );

    branch_target = id_ex_q.pc + id_ex_q.imm;

    branch_taken = 1'b0;

    if(id_ex_q.branch)
      branch_taken = branch_condition(
        id_ex_q.funct3,
        alu_a,
        alu_b_raw
      );

    ex_mem_d.valid = 1'b1;
    ex_mem_d.pc = id_ex_q.pc;
    ex_mem_d.instr = id_ex_q.instr;
    ex_mem_d.alu_result = alu_result;
    ex_mem_d.store_data = alu_b_raw;
    ex_mem_d.rd = id_ex_q.rd;
    ex_mem_d.funct3 = id_ex_q.funct3;
    ex_mem_d.reg_write = id_ex_q.reg_write;
    ex_mem_d.mem_write = id_ex_q.mem_write;
    ex_mem_d.mem_read = id_ex_q.mem_read;
    ex_mem_d.mem_to_reg = id_ex_q.mem_to_reg;
    ex_mem_d.branch = id_ex_q.branch;
    ex_mem_d.zero = alu_result == '0;
    ex_mem_d.branch_target = branch_target;

  endfunction


  function void memory_stage();

    mem_wb_d = '0;

    if(!ex_mem_q.valid)
      return;

    mem_read_data = '0;

    if(ex_mem_q.mem_read)
      mem_read_data = dmem[ex_mem_q.alu_result >> 2];

    if(ex_mem_q.mem_write)
      dmem[ex_mem_q.alu_result >> 2] = ex_mem_q.store_data;

    mem_wb_d.valid = 1'b1;
    mem_wb_d.pc = ex_mem_q.pc;
    mem_wb_d.instr = ex_mem_q.instr;
    mem_wb_d.alu_result = ex_mem_q.alu_result;
    mem_wb_d.mem_data = mem_read_data;
    mem_wb_d.rd = ex_mem_q.rd;
    mem_wb_d.reg_write = ex_mem_q.reg_write;
    mem_wb_d.mem_to_reg = ex_mem_q.mem_to_reg;

  endfunction


  function void writeback_stage();

    wb_data = '0;

    if(!mem_wb_q.valid)
      return;

    if(mem_wb_q.mem_to_reg)
      wb_data = mem_wb_q.mem_data;
    else
      wb_data = mem_wb_q.alu_result;

    if(
      mem_wb_q.reg_write &&
      (mem_wb_q.rd != '0)
    )
      regs[mem_wb_q.rd] = wb_data;

    regs[0] = '0;

  endfunction


  function void fetch_stage();

    if(stall) begin
      if_id_d = if_id_q;
      pc_d = pc;
      return;
    end

    if(branch_taken) begin
      if_id_d = '0;
      pc_d = branch_target;
      return;
    end

    if_id_d.valid = 1'b1;
    if_id_d.pc = pc;
    if_id_d.instr = imem[pc >> 2];

    pc_d = pc + 4;

  endfunction


function void build_output(
  output riscv_rm_item #(32,5) tr
);

  tr = riscv_rm_item #(32,5)::type_id::create("rm_tr");

  tr.exp_valid_cpu = mem_wb_q.valid;

  tr.exp_mem_valid_cpu =
    ex_mem_q.valid &&
    (ex_mem_q.mem_read || ex_mem_q.mem_write);

  tr.exp_pcW_cpu = mem_wb_q.pc;
  tr.exp_instrW_cpu = mem_wb_q.instr;

  tr.exp_wd_reg_cpu = mem_wb_q.reg_write;
  tr.exp_wda_reg_cpu = mem_wb_q.rd;
  tr.exp_wd_cpu = wb_data;

  tr.exp_mr_cpu =
    ex_mem_q.valid &&
    ex_mem_q.mem_read;

  tr.exp_mw_cpu =
    ex_mem_q.valid &&
    ex_mem_q.mem_write;

  tr.exp_maddr_cpu =
    ex_mem_q.alu_result;

  tr.exp_mwdata_cpu =
    ex_mem_q.store_data;

  tr.exp_mrdata_cpu =
    mem_read_data;

endfunction


  task automatic step(
    output rm_item tr
  );

    writeback_stage();

    calculate_hazard();

    decode_stage();

    execute_stage();

    memory_stage();

    fetch_stage();

    mem_wb_q = mem_wb_d;
    ex_mem_q = ex_mem_d;
    id_ex_q = id_ex_d;
    if_id_q = if_id_d;

    pc = pc_d;

    build_output(tr);

  endtask
  
  function void calculate_expected(
    riscv_seq_item #(32,5) req,
    output riscv_rm_item #(32,5) exp
);

  if(req.imem_wen)
    imem[req.imem_wda >> 2] = req.imem_wd;

  step(exp);

endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    in_fifo = new("in_fifo", this);
    ap = new("ap", this);
 endfunction
  
  virtual task run_phase(uvm_phase phase);

    riscv_seq_item #(32,5) req;
    riscv_rm_item #(32,5) exp;

  forever begin

    in_fifo.get(req);

    calculate_expected(req, exp);

    ap.write(exp);

  end

endtask


endclass
