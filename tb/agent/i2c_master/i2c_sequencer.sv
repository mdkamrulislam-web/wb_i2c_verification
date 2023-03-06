class i2c_sequencer extends uvm_sequencer #(i2c_sequence_item);
  // ! Factory registration of I2C Sequencer
  `uvm_component_utils(i2c_sequencer)

  // ! I2C Sequencer Constructor
  function new(string name = "i2c_sequencer", uvm_component parent = null);
    super.new(name, parent);
    `uvm_info(get_full_name(), "Inside I2C Sequencer Constructor.", UVM_HIGH)
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_full_name(), "Inside I2C Sequencer Build Phase.", UVM_HIGH)
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info(get_full_name(), "Inside I2C Sequencer Connect Phase.", UVM_HIGH)
  endfunction

  task run_phase(uvm_phase phase);
    `uvm_info(get_full_name(), "Inside I2C Sequencer Run Phase.", UVM_HIGH)
  endtask
endclass