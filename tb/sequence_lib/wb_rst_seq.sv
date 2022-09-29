class wb_rst_seq extends wb_i2c_seq;
  // ! Factory registration of WB RESET Sequence
  `uvm_object_utils(wb_rst_seq)

  // ! WB RESET Sequence Constructor
  function new(string name = "wb_rst_seq");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_info("WB_RST_SEQ", "Inside WB Reset Sequence Constructor.", UVM_NONE)
    
    `uvm_do_with(wb_item, {wb_item.wb_rst_i == 1;})
  endtask
endclass