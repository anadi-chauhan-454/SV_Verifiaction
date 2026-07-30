class uart_gen #(int WIDTH=8);

  uart_tr #(WIDTH) tr;
  mailbox #(uart_tr #(WIDTH)) drv_mbx;
  mailbox #(uart_tr #(WIDTH)) rm_mbx;

  int count;
  event done;

  typedef enum logic [2:0] {
    SANITY,
    PARITY,
    STOP,
    EVEN_PARITY,
    ODD_PARITY
  } uart_test_type;

  uart_test_type test_type;

  function new(mailbox #(uart_tr #(WIDTH)) drv_mbx,
               mailbox #(uart_tr #(WIDTH)) rm_mbx,
               int count = 100,
               uart_test_type test_type = SANITY);
    this.drv_mbx   = drv_mbx;
    this.rm_mbx    = rm_mbx;
    this.count     = count;
    this.test_type = test_type;
  endfunction

  task run();
    repeat (count) begin
      tr = new();

      case (test_type)

        SANITY: begin
          if (!tr.randomize())
            $fatal("Randomization failed.");
        end

        PARITY: begin
          if (!tr.randomize() with {
            parity_en == 1;
          })
            $fatal("Randomization failed.");
        end

        STOP: begin
          if (!tr.randomize() with {
            stop_bits == 1;
          })
            $fatal("Randomization failed.");
        end

        EVEN_PARITY: begin
          if (!tr.randomize() with {
            parity_en   == 1;
            parity_type == 0;
          })
            $fatal("Randomization failed.");
        end

        ODD_PARITY: begin
          if (!tr.randomize() with {
            parity_en   == 1;
            parity_type == 1;
          })
            $fatal("Randomization failed.");
        end

        default: begin
          if (!tr.randomize())
            $fatal("Randomization failed.");
        end

      endcase

      drv_mbx.put(tr.copy());
      rm_mbx.put(tr.copy());

      tr.display("GEN");
    end

    ->done;
  endtask

endclass
