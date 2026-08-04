typedef enum logic[1:0]{
  SANITY,
  WRITE_ONLY,
  READ_ONLY,
  RANDOM
} test_mode;

class asfifo_gen #(int DWIDTH=8);
  
  mailbox #(asfifo_tr #(DWIDTH)) wdrv_mbx;
  mailbox #(asfifo_tr #(DWIDTH)) rdrv_mbx;
  
  mailbox #(asfifo_tr #(DWIDTH)) rm_mbx;
  
  asfifo_tr #(DWIDTH) tr;
  
  int count;
  
  event done;
  
  test_mode mode;
  
  function new (mailbox #(asfifo_tr #(DWIDTH)) wdrv_mbx,
                mailbox #(asfifo_tr #(DWIDTH)) rdrv_mbx,
                mailbox #(asfifo_tr #(DWIDTH)) rm_mbx,
                int count = 100);
    this.wdrv_mbx = wdrv_mbx;
    this.rdrv_mbx = rdrv_mbx;
    this.rm_mbx = rm_mbx;
    this.count = count;
    this.mode = SANITY;
  endfunction
  
  task run();
    repeat(count) begin
      tr = new();
      tr.write_only.constraint_mode(0);
      tr.read_only.constraint_mode(0);
      
      unique case(mode)
        SANITY://nothing
          ;
        WRITE_ONLY:tr.write_only.constraint_mode(1);
        READ_ONLY:tr.read_only.constraint_mode(1);
        RANDOM://nothing
          ;
        default:SANITY: $fatal("[GEN] Invalid mode");
      endcase
           
      assert(tr.randomize())
        else
          $fatal("[GEN] generation failed for transactions=%0d",tr.txn_id);
      
      tr.display("GEN");
      
      wdrv_mbx.put(tr.copy());
      rdrv_mbx.put(tr.copy());
      
      rm_mbx.put(tr.copy());
    end
    ->done;
  endtask
endclass
