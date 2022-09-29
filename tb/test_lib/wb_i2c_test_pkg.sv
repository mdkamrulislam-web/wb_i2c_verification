package wb_i2c_test_pkg;
  import uvm_pkg::*;
  //`include "uvm_macros.svh"
  import wb_i2c_seq_pkg::*;
  import wb_i2c_env_pkg::*;
  import wb_agent_pkg::wb_agent_config;

  `include "wb_i2c_base_test.sv"
  `include "wb_rst_test.sv"
  `include "wb_wr_rd_test.sv"
endpackage