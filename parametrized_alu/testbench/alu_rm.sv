class alu_rm #(parameter int WIDTH = 4);
  
  mailbox #(alu_tr #(WIDTH)) in_mbx;
  mailbox #(alu_tr #(WIDTH)) out_mbx;
  
  function new(mailbox #(alu_tr #(WIDTH)) in_mbx,
               mailbox #(alu_tr #(WIDTH)) out_mbx);
    this.in_mbx = in_mbx;
    this.out_mbx = out_mbx;
  endfunction
  
  task run();
    alu_tr #(WIDTH) tr;
    logic [WIDTH:0] temp;
    forever
      begin
        in_mbx.get(tr);
        
        temp      = '0;
		tr.result = '0;
		tr.flags  = '0;
        
        unique case(tr.sel)
          
         ALU_ADD: begin
           temp = {1'b0, tr.a} + {1'b0, tr.b};
          tr.result = temp[WIDTH-1:0];

          tr.flags.carry = temp[WIDTH];
            tr.flags.overflow =
           (tr.a[WIDTH-1] == tr.b[WIDTH-1]) &&
           (tr.result[WIDTH-1] != tr.a[WIDTH-1]);
        end

       ALU_SUB: begin
          temp = {1'b0, tr.a} - {1'b0, tr.b};
          tr.result = temp[WIDTH-1:0];

          tr.flags.carry = temp[WIDTH];
            tr.flags.overflow =
          (tr.a[WIDTH-1] != tr.b[WIDTH-1]) &&
          (tr.result[WIDTH-1] != tr.a[WIDTH-1]);
        end

       ALU_AND: tr.result = tr.a & tr.b;
       ALU_OR : tr.result = tr.a | tr.b;
       ALU_XOR: tr.result = tr.a ^ tr.b;
       ALU_SLEFT: tr.result = tr.a << tr.shamt;
       ALU_SRIGHT: tr.result = tr.a >> tr.shamt;
        default: tr.result = '0;
       endcase
    	tr.flags.zero     = (tr.result == '0);
        tr.flags.negative = tr.result[WIDTH-1];
        
        tr.display("RM");
        
         out_mbx.put(tr.copy());
        
      end
  endtask
endclass
