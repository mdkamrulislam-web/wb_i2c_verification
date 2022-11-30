class i2c_agent extends uvm_agent;
  // ! Factory Registration of I2C Agent
  `uvm_component_utils(i2c_agent)

  // ! Declaring a handle of I2C Monitor
  i2c_monitor i2c_mtr     ;

  // ! I2C Agent Constructor
  function new(string name = "i2c_agent", uvm_component parent = null);
    super.new(name, parent);
    `uvm_info(get_full_name(), "Inside I2C Agent Constructor.", UVM_LOW)
  endfunction

  // ! I2C Agent Build Phase
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_full_name(), "Inside I2C Agent Build Phase.", UVM_LOW)

    i2c_mtr = i2c_monitor::type_id::create("i2c_mtr", this);
  endfunction

  // ! I2C Agent Connect Phase
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info(get_full_name(), "Inside I2C Agent Connect Phase.", UVM_LOW);
  endfunction

  // ! I2C Agent Run Phase
  task run_phase(uvm_phase phase);
    `uvm_info(get_full_name(), "Inside I2C Agent Run Phase.", UVM_LOW)
  endtask
endclass