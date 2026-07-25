class sfifo_rm#(
  parameter int DWIDTH = 8,
  parameter int DEPTH = 8
);
  
  mailbox #(sfifo_tr #(DWIDTH)) in_mbx;
  mailbox #(sfifo_tr #(DWIDTH)) out_mbx;
  
  bit [DWIDTH-1:0] model_q[$];
  
  function new(
    mailbox #(sfifo_tr #(DWIDTH)) in_mbx,
    mailbox #(sfifo_tr #(DWIDTH)) out_mbx
  );
    this.in_mbx = in_mbx;
    this.out_mbx = out_mbx;
  endfunction
  
  task run();
    sfifo_tr #(DWIDTH) tr;
    sfifo_tr #(DWIDTH) exp_tr;
    
    // State variables to mimic a 1-clock-cycle hardware delay
    bit last_empty = 1; // FIFO starts empty
    bit last_full  = 0;
    bit [DWIDTH-1:0] last_data_out = '0;

    forever 
      begin
        in_mbx.get(tr);
        
        exp_tr = tr.copy();
        
        exp_tr.flags.empty    = last_empty;
        exp_tr.flags.full     = last_full;
        exp_tr.flags.overflow  = 0;
        exp_tr.flags.underflow = 0;
        exp_tr.data_out        = last_data_out;
        
        if(tr.wen && !tr.ren) begin
          if(model_q.size() == DEPTH)
             exp_tr.flags.overflow = 1;
          else
             model_q.push_back(tr.data_in);
        end
        else if(tr.ren && !tr.wen) begin
           if(model_q.size() == 0)
              exp_tr.flags.underflow = 1;
           else begin
              last_data_out = model_q.pop_front();
           end
        end
        else if(tr.wen && tr.ren) begin
          if(model_q.size() == 0) begin
            exp_tr.flags.underflow = 1;
            model_q.push_back(tr.data_in);
          end
          else begin
            last_data_out = model_q.pop_front();
            model_q.push_back(tr.data_in);
          end
        end

        if (!tr.ren) begin
          last_data_out = last_data_out; 
        end
        last_full  = (model_q.size() == DEPTH);
        last_empty = (model_q.size() == 0);

        exp_tr.display("RM");
        out_mbx.put(exp_tr);
      end
  endtask
endclass
