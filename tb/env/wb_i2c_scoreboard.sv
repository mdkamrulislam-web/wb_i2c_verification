`uvm_analysis_imp_decl(_wb_wr_mtr2scb)
`uvm_analysis_imp_decl(_wb_rd_mtr2scb)

class wb_i2c_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(wb_i2c_scoreboard)

  // ! Taking a queue as exp_que
  wb_sequence_item wb_wr_exp_que[$];
  wb_sequence_item wb_rd_exp_que[$];

  wb_sequence_item wb_wr_exp_mtr_item;
  wb_sequence_item wb_rd_exp_mtr_item;
  
  // ! Declaring imports for getting driver packets and monitor packets.
  uvm_analysis_imp_wb_wr_mtr2scb#(wb_sequence_item, wb_i2c_scoreboard) wb_wr_mtr2scb;
  uvm_analysis_imp_wb_rd_mtr2scb#(wb_sequence_item, wb_i2c_scoreboard) wb_rd_mtr2scb;

  function new(string name = "wb_i2c_scoreboard", uvm_component parent = null);
    super.new(name, parent);
    `uvm_info(get_full_name(), "Inside WB_I2C Scoreboard Constructor.", UVM_HIGH)
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_full_name(), "Inside WB_I2C Scoreboard Build Phase.", UVM_HIGH)

    // Creating objects for the above declared imports
    wb_wr_mtr2scb = new("wb_wr_mtr2scb", this);
    wb_rd_mtr2scb = new("wb_rd_mtr2scb", this);
    
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info(get_full_name(), "Inside WB_I2C Scoreboard Connect Phase.", UVM_HIGH)
  endfunction

  task run_phase(uvm_phase phase);
    `uvm_info(get_full_name(), "Inside WB_I2C Scoreboard Run Phase.", UVM_HIGH)
  endtask

  // ! Defining write_wb_exp_mtr2scb() method which was created by macro `uvm_analysis_imp_decl(_wb_exp_mtr2scb).	
  // Storing the received packet in the expected queue.
  function void write_wb_wr_mtr2scb(wb_sequence_item wb_wr_exp_item);
    //wb_wr_exp_item.print();
    `uvm_info("WB_WR_MTR_2_SCB", $sformatf("Address = %0h :: Data In = %0h", wb_wr_exp_item.wb_adr_i, wb_wr_exp_item.wb_dat_i), UVM_NONE)
  endfunction

  function void write_wb_rd_mtr2scb(wb_sequence_item wb_rd_exp_item);
    //wb_rd_exp_item.print();
    `uvm_info("WB_RD_MTR_2_SCB", $sformatf("Address = %0h :: Data Out = %0h", wb_rd_exp_item.wb_adr_i, wb_rd_exp_item.wb_dat_o), UVM_NONE)
  endfunction

endclass