package wb_i2c_env_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  
  import i2c_agent_pkg::*;
  import wb_agent_pkg::*;

  `include "wb_i2c_predictor.sv"
  `include "wb_i2c_scoreboard.sv"
  `include "wb_i2c_env_config.sv"
  `include "wb_i2c_environment.sv"
endpackage