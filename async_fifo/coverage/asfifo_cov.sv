class asfifo_cov #(int DWIDTH=16);
  
  covergroup asfifo_cg with function sample(asfifo_tr #(DWIDTH) tr);

    datain_cp: coverpoint tr.data_in {

      bins zero    = {16'h0000};
      bins max     = {16'hFFFF};

      bins low []  = {[16'h0001:16'h3FFF]};
      bins mid []  = {[16'h4000:16'hBFFF]};
      bins high[]  = {[16'hC000:16'hFFFE]};
    }


    dataout_cp: coverpoint tr.data_out {

      bins zero    = {16'h0000};
      bins max     = {16'hFFFF};

      bins low []  = {[16'h0001:16'h3FFF]};
      bins mid []  = {[16'h4000:16'hBFFF]};
      bins high [] = {[16'hC000:16'hFFFE]};
    }


    wen_cp: coverpoint tr.wen {
      bins write = {1};
      bins idle  = {0};
    }


    ren_cp: coverpoint tr.ren {
      bins read = {1};
      bins idle = {0};
    }


    full_cp: coverpoint tr.full {
      bins full     = {1};
      bins not_full = {0};
    }


    empty_cp: coverpoint tr.empty {
      bins empty     = {1};
      bins not_empty = {0};
    }


    wren_cross: cross wen_cp, ren_cp;


    wfull_cross: cross wen_cp, full_cp {
      bins overflow =
        binsof(wen_cp.write) &&
        binsof(full_cp.full);
    }


    rempty_cross: cross ren_cp, empty_cp {
      bins underflow =
        binsof(ren_cp.read) &&
        binsof(empty_cp.empty);
    }


    full_empty_cross: cross full_cp, empty_cp {
      illegal_bins both =
        binsof(full_cp.full) &&
        binsof(empty_cp.empty);
    }


    read_data_cross: cross ren_cp, dataout_cp {

      bins read_zero =
        binsof(ren_cp.read) &&
        binsof(dataout_cp.zero);

      bins read_max =
        binsof(ren_cp.read) &&
        binsof(dataout_cp.max);

      bins read_random =
        binsof(ren_cp.read) &&
        (binsof(dataout_cp.low) ||
         binsof(dataout_cp.mid) ||
         binsof(dataout_cp.high));
    }


    write_data_cross: cross wen_cp, datain_cp {

      bins write_zero =
        binsof(wen_cp.write) &&
        binsof(datain_cp.zero);

      bins write_max =
        binsof(wen_cp.write) &&
        binsof(datain_cp.max);

      bins write_random =
        binsof(wen_cp.write) &&
        (binsof(datain_cp.low) ||
         binsof(datain_cp.mid) ||
         binsof(datain_cp.high));
    }


  endgroup


  function new();
    asfifo_cg = new();
  endfunction


  function void write(asfifo_tr #(DWIDTH) tr);

    asfifo_cg.sample(tr);

    $display("[COV] Current Coverage=%0.2f%%",
              asfifo_cg.get_coverage());

  endfunction

endclass
