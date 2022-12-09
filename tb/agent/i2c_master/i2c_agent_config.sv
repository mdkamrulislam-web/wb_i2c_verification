class i2c_agent_config extends uvm_object;
  // ! Factory registration of I2C Agent Configuration
  `uvm_object_utils(i2c_agent_config)

  uvm_active_passive_enum is_active = UVM_PASSIVE;
  bit has_functional_coverage;

  int       agt_con_byte_no;
  bit [1:0] agt_con_i2c_wr_rd;

  // ! I2C Agent Configuration Constructor
  function new(string name = "i2c_agent_config");
    super.new(name);
    `uvm_info(get_full_name(), "Inside I2C Agent Config Constructor", UVM_HIGH)
  endfunction
endclass
