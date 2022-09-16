class wb_rd_seq extends wb_i2c_seq;
  // ! Factory registration of WB Read Sequence
  `uvm_object_utils(wb_rd_seq)

  // ! WB Read Sequence Constructor
  function new(string name = "wb_rd_seq");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_info("WB_RD_SEQ", "Inside WB Read Sequence Constructor.", UVM_NONE)
    
    `uvm_do_with(
      wb_item,
      {
        wb_item.wb_adr_i == local::wb_address;
        wb_item.wb_rst_i == 0;
        wb_item.wb_we_i  == 0;
      }
    )
  endtask

/*
      wb_rst_i 
      arst_i   
[2:0] wb_adr_i 
[7:0] wb_dat_i 
[7:0] wb_dat_o 
      wb_we_i  
      wb_stb_i 
      wb_cyc_i 
      wb_ack_o 
      wb_inta_o
*/
endclass