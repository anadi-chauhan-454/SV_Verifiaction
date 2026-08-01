package uart_pkg;
  `include "uart_tr.sv"
  `include "uart_gen.sv"
  `include "uart_drv.sv"
  `include "uart_cov.sv"
  `include "uart_mon.sv"
  `include "uart_rm.sv"
  `include "uart_scb.sv"
  `include "uart_env.sv"

  `include "uart_base_test.sv"
  `include "uart_sanity_test.sv"
  `include "uart_parity_test.sv"
  `include "uart_stop_test.sv"
  `include "uart_parity_odd_test.sv"
  `include "uart_parity_even_test.sv"
endpackage
