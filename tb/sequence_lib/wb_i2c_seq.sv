class wb_i2c_seq extends uvm_sequence #(wb_sequence_item);
  // ! Factory registration of WB_I2C Sequence
  `uvm_object_utils(wb_i2c_seq)

  // ! Declaring handles for global parameters
  wb_sequence_item wb_item;
  bit randomization;

  bit [2:0] wb_address;
  bit [7:0] wb_dataIn;

  // ! WB_I2C Sequence Constructor
  function new(string name = "wb_i2c_seq");
    super.new(name);
    `uvm_info(get_full_name(), "Inside WB_I2C Sequence Constructor.", UVM_NONE)
  endfunction
endclass