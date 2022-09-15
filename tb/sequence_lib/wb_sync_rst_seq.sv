class wb_sync_rst_seq extends wb_i2c_seq;
  // ! Factory registration of WB SYNC RESET Sequence
  `uvm_object_utils(wb_sync_rst_seq)

  // ! WB SYNC RESET Sequence Constructor
  function new(string name = "wb_sync_rst_seq");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_info("WB_SYNC_RST_SEQ", "Inside WB Sync Reset Sequence Constructor.", UVM_NONE)
    
    `uvm_do_with(wb_item, {wb_item.wb_rst_i == 1;})
  endtask
endclass