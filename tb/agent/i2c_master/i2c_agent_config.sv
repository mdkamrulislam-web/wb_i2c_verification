class i2c_agent_config extends uvm_object;
  // ! Factory registration of I2C Agent Configuration
  `uvm_object_utils(i2c_agent_config)

  uvm_active_passive_enum is_active = UVM_PASSIVE;
  bit has_functional_coverage;

  int transfer_data_byte_no;

  // ! I2C Agent Configuration Constructor
  function new(string name = "i2c_agent_config");
    super.new(name);
    `uvm_info(get_full_name(), "Inside I2C Agent Config Constructor", UVM_HIGH)
  endfunction
endclass