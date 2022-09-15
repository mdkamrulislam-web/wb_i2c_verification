class wb_i2c_seq extends uvm_sequence #(wb_sequence_item);
  // ! WB_I2C Sequence Constructor
  function new(string name = "wb_i2c_seq");
    super.new(name);
    `uvm_info(get_full_name(), "Inside WB_I2C Sequence Constructor.", UVM_NONE)
  endfunction
endclass