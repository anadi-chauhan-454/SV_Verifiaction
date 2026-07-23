module alu_top;
  parameter WIDTH = 4;

  import alu_pkg::*;

  alu_if #(WIDTH) vif();
  
   alu #(.WIDTH(WIDTH)) dut(
    .a(vif.a),
    .b(vif.b),
    .sel(vif.sel),
    .shamt(vif.shamt),
    .result(vif.result),
    .flags(vif.flags)
  );
  
  alu_test #(WIDTH) test;
   
  initial
    begin
      test = new(vif);
      test.run();
    end
endmodule
  
