class wb_wr_seq extends wb_i2c_seq;
  // ! Factory registration of WB Write Sequence
  `uvm_object_utils(wb_wr_seq)

  // ! WB Write Sequence Constructor
  function new(string name = "wb_wr_seq");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_info("WB_WR_SEQ", "Inside WB Write Sequence Constructor.", UVM_HIGH)
    
    wb_item = wb_sequence_item::type_id::create("wb_item");
    wait_for_grant();
      
      if(randomization) begin
        wb_item.wb_rst_i = 0;
        wb_item.wb_adr_i = wb_address;
        wb_item.wb_we_i  = 1;
        wb_item.wb_dat_i = $urandom_range(8'hFF, 8'h00);
      end
      else begin
        wb_item.wb_rst_i = 0;
        wb_item.wb_adr_i = wb_address;
        wb_item.wb_we_i  = 1;
        wb_item.wb_dat_i = wb_dataIn;
      end
      send_request(wb_item);
    wait_for_item_done();

    /*
    if(randomization) begin
      `uvm_do_with(
        wb_item,
        {
          wb_item.wb_adr_i == local::wb_address;
          wb_item.wb_rst_i == 0;
          wb_item.wb_we_i  == 1;
        }
      )
    end
    else begin
      `uvm_do_with(
        wb_item,
        {
          wb_item.wb_adr_i == local::wb_address;
          wb_item.wb_rst_i == 0;
          wb_item.wb_we_i  == 1;
          wb_item.wb_dat_i == local::wb_dataIn;
        }
      )
      
      
    end
    */
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