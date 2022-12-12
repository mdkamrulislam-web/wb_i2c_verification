class wb_i2c_env_config extends uvm_object;
  // ! Factory Registration of WB_I2C Environment Config
  `uvm_object_utils(wb_i2c_env_config)

  // ! Declaring the handls of the WB Agent Config, I2C Agent Config and has_scoreboard Parameter.
  bit has_scoreboard;
  wb_agent_config wb_agt_con;

  function new(string name = "wb_i2c_env_config");
    super.new(name);
    `uvm_info(get_full_name(), "Inside WB_I2C Environment Config Constructor", UVM_HIGH)
  endfunction
endclass