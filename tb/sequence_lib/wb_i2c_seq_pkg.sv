package wb_i2c_seq_pkg;
  import uvm_pkg::*;

  import wb_agent_pkg::wb_sequence_item;

  `include "wb_i2c_seq.sv"
  `include "wb_sync_rst_seq.sv"
  `include "wb_wr_seq.sv"
  `include "wb_rd_seq.sv"
endpackage