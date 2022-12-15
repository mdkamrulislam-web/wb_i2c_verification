`uvm_analysis_imp_decl(_wb_wr_mtr2scb)
`uvm_analysis_imp_decl(_wb_rd_mtr2scb)

class wb_i2c_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(wb_i2c_scoreboard)

  `include "../defines/defines.sv"

  wb_agent_config wb_agt_con;

  static logic [7:0] trans_exp_slv_addr             ;
  static logic [7:0] temp_trans_exp_slv_addr        ;
  logic [7:0] trans_exp_mem_addr                    ;
  logic [7:0] trans_exp_txr_data                    ;
  int         trans_exp_byte_no                     ;
  
  static int write                              ;
  static int read                               ;

  static logic [7:0] exp_i2c_slv_adr            ;

  static logic [7:0] exp_transmit_data_memory[8];
  static logic [7:0] act_transmit_data_memory[8];

  // ! Taking a queue as exp_que
  wb_sequence_item wb_wr_exp_que[$]             ;
  wb_sequence_item wb_rd_exp_que[$]             ;

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
    //`uvm_info("WB_WR_MTR_2_SCB", $sformatf("Address = %0h :: Data In = %0h", wb_wr_exp_item.wb_adr_i, wb_wr_exp_item.wb_dat_i), UVM_MEDIUM)

    `uvm_info("WB_AGT_CHECKER", $sformatf("Transfer Byte No :: %0d, Repeated Start Enabled :: %0b, I2C_TR_RC :: %0b", wb_agt_con.wb_agt_con_i2c_trans_byte, wb_agt_con.wb_agt_con_rep_st_en, wb_agt_con.wb_agt_con_i2c_tr_rc), UVM_NONE)
    
    //////////////////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////// EXPECTED TRANSMIT DATA /////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////////////////////
    // Setting Slave Address in TXR Reg
    if((wb_agt_con.wb_agt_con_i2c_tr_rc === 2'b01)) begin
      if((wb_wr_exp_item.wb_adr_i === `TXR) && (write === 0)) begin
        temp_trans_exp_slv_addr = wb_wr_exp_item.wb_dat_i;
        write++;
      end
      if((wb_wr_exp_item.wb_adr_i === `CR) && (write === 1) && ((wb_wr_exp_item.wb_dat_i===8'b1001_0000) || (wb_agt_con.wb_agt_con_rep_st_en === 1'b1))) begin
        trans_exp_slv_addr = temp_trans_exp_slv_addr;
        `uvm_info("SCOREBOARD_FLAGS::SLV_ADDR**", $sformatf("\t\t#############>>\t\tWRITE_FLAG_VAL :: %0d, TRANS_EXP_SLV_ADDR :: %0h", write, trans_exp_slv_addr), UVM_NONE)
      end
    end
    
  endfunction

  function void write_wb_rd_mtr2scb(wb_sequence_item wb_rd_exp_item);
    //wb_rd_exp_item.print();
    `uvm_info("WB_RD_MTR_2_SCB", $sformatf("Address = %0h :: Data Out = %0h", wb_rd_exp_item.wb_adr_i, wb_rd_exp_item.wb_dat_o), UVM_MEDIUM)
  endfunction

endclass