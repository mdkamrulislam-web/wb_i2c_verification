`uvm_analysis_imp_decl(_wb_mtr2scb)
`uvm_analysis_imp_decl(_i2c_mtr2scb)

class wb_i2c_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(wb_i2c_scoreboard)

  `include "../defines/defines.sv"

  logic [7:0] trns_slv_addr_wr_rd_bit             ;
  logic [7:0] recv_slv_addr_wr_rd_bit             ;

  logic [7:0] ini_trns_mem_addr                   ;
  logic [7:0] ini_recv_mem_addr                   ;

  logic [7:0] temp_trans_data                     ;

  int         trns_byte_no                        ;
  int         recv_byte_no                        ;
  
  int         wr_step                             ;
  int         rd_step                             ;

  logic [7:0] exp_transmit_data_memory[`DATADEPTH];  // Change Inside Define File to Modify Depth
  logic [7:0] act_receive_data_memory[`DATADEPTH] ;  // Change Inside Define File to Modify Depth

  // ! Taking a queue as exp_que
  i2c_sequence_item exp_i2c_trans_que[$]          ;

  i2c_sequence_item exp_i2c_trans_item            ;

  wb_agent_config   wb_agt_con                    ;
 
  int trnsfr_chkr                                 ;
  
  int recv_chkr                                   ;


  // ! Declaring imports for getting driver packets and monitor packets.
  uvm_analysis_imp_wb_mtr2scb#(wb_sequence_item, wb_i2c_scoreboard) wb_mtr2scb;
  uvm_analysis_imp_i2c_mtr2scb#(i2c_sequence_item, wb_i2c_scoreboard) i2c_mtr2scb;

  function new(string name = "wb_i2c_scoreboard", uvm_component parent = null);
    super.new(name, parent);
    `uvm_info(get_full_name(), "Inside WB_I2C Scoreboard Constructor.", UVM_DEBUG)
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_full_name(), "Inside WB_I2C Scoreboard Build Phase.", UVM_DEBUG)

    // Creating objects for the above declared imports
    wb_mtr2scb = new("wb_mtr2scb", this);
    i2c_mtr2scb = new("i2c_mtr2scb", this);
    
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info(get_full_name(), "Inside WB_I2C Scoreboard Connect Phase.", UVM_DEBUG)
  endfunction

  task run_phase(uvm_phase phase);
    `uvm_info(get_full_name(), "Inside WB_I2C Scoreboard Run Phase.", UVM_DEBUG)
  endtask

  // ! Defining write_wb_exp_mtr2scb() method which was created by macro `uvm_analysis_imp_decl(_wb_exp_mtr2scb).	
  // Storing the received packet in the expected queue.
  function void write_wb_mtr2scb(wb_sequence_item wb_exp_item);
    
    // When Wishbone Register Address = Transmit Register and I2C Transmit
    // operation is running.
    if((wb_exp_item.wb_adr_i === `TXR) && (((wr_step === 0) && (rd_step === 0)) || (rd_step === 4))) begin
      // Slave Address + WR Bit Transmiision to `TXR Reg ######### For I2C Transmit
      if(wb_agt_con.wb_agt_con_i2c_tr_rc === 2'b01) begin
        trns_slv_addr_wr_rd_bit = wb_exp_item.wb_dat_i;
        wr_step++;
        trns_byte_no = wb_agt_con.wb_agt_con_i2c_trans_byte;
        `uvm_info("SCB_WR_RD_FLAG_VALS", $sformatf("WRITE_FLAG :: %0d, READ_FLAG :: %0d", wr_step, rd_step), UVM_HIGH)
      end
      // Slave Address + WR Bit Transmission to `TXR Reg ######### For I2C Receive
      else if(wb_agt_con.wb_agt_con_i2c_tr_rc === 2'b10) begin
        recv_slv_addr_wr_rd_bit = wb_exp_item.wb_dat_i;
        rd_step++;
        recv_byte_no = wb_agt_con.wb_agt_con_i2c_trans_byte;
        `uvm_info("SCB_WR_RD_FLAG_VALS", $sformatf("WRITE_FLAG :: %0d, READ_FLAG :: %0d", wr_step, rd_step), UVM_HIGH)
      end
    end
    if((wb_exp_item.wb_adr_i === `CR) && (wb_exp_item.wb_dat_i === 8'b1001_0000)) begin
      // Configuration Setting Check for I2C Slave Address Transmission to `TXR Reg ######### For I2C Transmit
      if(wr_step === 1) begin
        //`uvm_warning("WR_CHECKER", $sformatf("Transmission Slave Address :: %0h, Receive Slave Address :: %0h", trns_slv_addr_wr_rd_bit, recv_slv_addr_wr_rd_bit))
        exp_i2c_trans_item = i2c_sequence_item::type_id::create("exp_i2c_trans_item");
        exp_i2c_trans_item.slave_addr_wr_rd_bit = trns_slv_addr_wr_rd_bit;
        `uvm_info("EXP_I2C_TRANS_ITEM", $sformatf("trans_slave_addr_wr_rd_bit :: %0h", exp_i2c_trans_item.slave_addr_wr_rd_bit), UVM_NONE)
        exp_i2c_trans_que.push_back(exp_i2c_trans_item);

        //$display("PUSH DURING WRITE################################");
        //exp_i2c_trans_item.print();
        
        wr_step++;
        `uvm_info("SCB_WR_RD_FLAG_VALS", $sformatf("WRITE_FLAG :: %0d, READ_FLAG :: %0d", wr_step, rd_step), UVM_HIGH)
      end
      // Configuration Setting Check for I2C Slave Address Transmission to `TXR Reg ######### For I2C Receive
      else if((rd_step === 1) || (rd_step === 5)) begin
        exp_i2c_trans_item = i2c_sequence_item::type_id::create("exp_i2c_trans_item");
        exp_i2c_trans_item.slave_addr_wr_rd_bit = recv_slv_addr_wr_rd_bit;
        `uvm_info("EXP_I2C_TRANS_ITEM", $sformatf("recv_slave_addr_wr_rd_bit :: %0h", exp_i2c_trans_item.slave_addr_wr_rd_bit), UVM_NONE)
        exp_i2c_trans_que.push_back(exp_i2c_trans_item);
        
        //$display("PUSH DURING READ################################");
        //exp_i2c_trans_item.print();
        rd_step++;
        `uvm_info("SCB_WR_RD_FLAG_VALS", $sformatf("WRITE_FLAG :: %0d, READ_FLAG :: %0d", wr_step, rd_step), UVM_HIGH)
      end
    end
    if(wb_exp_item.wb_adr_i === `TXR) begin
      // Memory Address Transmiision to `TXR Reg ######### For I2C Transmit
      if(wr_step === 2) begin
        ini_trns_mem_addr = wb_exp_item.wb_dat_i;
        wr_step++;
        `uvm_info("SCB_WR_RD_FLAG_VALS", $sformatf("WRITE_FLAG :: %0d, READ_FLAG :: %0d", wr_step, rd_step), UVM_HIGH)
      end
      // Memory Address Transmiision to `TXR Reg ######### For I2C Transmit
      else if(rd_step === 2) begin
        ini_recv_mem_addr = wb_exp_item.wb_dat_i;
        rd_step++;
        `uvm_info("SCB_WR_RD_FLAG_VALS", $sformatf("WRITE_FLAG :: %0d, READ_FLAG :: %0d", wr_step, rd_step), UVM_HIGH)
      end
    end
    if((wb_exp_item.wb_adr_i === `CR) && (wb_exp_item.wb_dat_i === 8'b0001_0000)) begin
      // Configuration Setting Check for Initial Memory Address Transmission to `TXR Reg ######### For I2C Transmit
      if(wr_step === 3) begin
        exp_i2c_trans_item = i2c_sequence_item::type_id::create("exp_i2c_trans_item");
        exp_i2c_trans_item.memry_addr = ini_trns_mem_addr;
        `uvm_info("EXP_I2C_TRANS_ITEM", $sformatf("ini_trns_mem_addr :: %0h", exp_i2c_trans_item.memry_addr), UVM_NONE)
        exp_i2c_trans_que.push_back(exp_i2c_trans_item);


        wr_step++;
        `uvm_info("SCB_WR_RD_FLAG_VALS", $sformatf("WRITE_FLAG :: %0d, READ_FLAG :: %0d", wr_step, rd_step), UVM_HIGH)
      end
      // Configuration Setting Check for Initial Memory Address Transmission to `TXR Reg ######### For I2C Receive
      else if(rd_step === 3) begin
        exp_i2c_trans_item = i2c_sequence_item::type_id::create("exp_i2c_trans_item");
        exp_i2c_trans_item.memry_addr = ini_recv_mem_addr;
        `uvm_info("EXP_I2C_TRANS_ITEM", $sformatf("ini_recv_mem_addr :: %0h", exp_i2c_trans_item.memry_addr), UVM_NONE)
        exp_i2c_trans_que.push_back(exp_i2c_trans_item);


        rd_step++;
        `uvm_info("SCB_WR_RD_FLAG_VALS", $sformatf("WRITE_FLAG :: %0d, READ_FLAG :: %0d", wr_step, rd_step), UVM_HIGH)
      end
    end
    // Seeting Transmission Datat to the `TXR Register
    if((wb_exp_item.wb_adr_i === `TXR) && (wr_step >= 4)) begin
      temp_trans_data = wb_exp_item.wb_dat_i;
      wr_step++;
      `uvm_info("SCB_WR_RD_FLAG_VALS", $sformatf("WRITE_FLAG :: %0d, READ_FLAG :: %0d", wr_step, rd_step), UVM_HIGH)
    end

    // Configuration Setting for Transmitting The Data in `TXR Register to I2C Slave Register.
    if((wb_exp_item.wb_adr_i === `CR) && !(trns_byte_no < 1) && (wr_step >= 5)) begin
      exp_transmit_data_memory[ini_trns_mem_addr] = temp_trans_data;
      exp_i2c_trans_item = i2c_sequence_item::type_id::create("exp_i2c_trans_item");
      exp_i2c_trans_item.memry_addr = ini_trns_mem_addr;
      exp_i2c_trans_item.transmit_data = exp_transmit_data_memory[ini_trns_mem_addr];
      `uvm_info("EXP_I2C_TRANS_DAT_ADR", $sformatf("Data :: %0h, Address :: %0h", exp_transmit_data_memory[ini_trns_mem_addr], ini_trns_mem_addr), UVM_NONE)
      exp_i2c_trans_que.push_back(exp_i2c_trans_item);
      ini_trns_mem_addr++;


      wr_step++;
      trns_byte_no--;
      if(trns_byte_no < 1) begin
        wr_step = 0;
      end
      `uvm_info("SCB_WR_RD_FLAG_VALS", $sformatf("WRITE_FLAG :: %0d, READ_FLAG :: %0d", wr_step, rd_step), UVM_HIGH)
    end
    if((wb_exp_item.wb_adr_i === `CR) && (wb_exp_item.wb_dat_i[5] === 1'b1) && (rd_step >= 6)) begin
      rd_step++;
      `uvm_info("SCB_WR_RD_FLAG_VALS", $sformatf("WRITE_FLAG :: %0d, READ_FLAG :: %0d", wr_step, rd_step), UVM_HIGH)
    end
    if((wb_exp_item.wb_adr_i === `RXR) && (rd_step >= 7) && !(recv_byte_no < 1)) begin
      act_receive_data_memory[ini_recv_mem_addr] = wb_exp_item.wb_dat_o;
      `uvm_info("EXP_I2C_RECV_DAT_ADR", $sformatf("Data :: %0h, Address :: %0h", act_receive_data_memory[ini_recv_mem_addr], ini_recv_mem_addr), UVM_NONE)
      ini_recv_mem_addr++;


      rd_step++;
      recv_byte_no--;
      if(recv_byte_no < 1) begin
        rd_step = 0;
      end
      `uvm_info("SCB_WR_RD_FLAG_VALS", $sformatf("WRITE_FLAG :: %0d, READ_FLAG :: %0d", wr_step, rd_step), UVM_HIGH)
    end
  endfunction

  function void write_i2c_mtr2scb(i2c_sequence_item i2c_sq_itm);
    i2c_sequence_item exp_trns_itm;
    //$display("RECEIVED FROM I2C################################");
    //i2c_sq_itm.print();
    

    if(exp_i2c_trans_que.size()) begin
      exp_trns_itm = exp_i2c_trans_que.pop_front();
      //$display("POP################################");
      //exp_trns_itm.print();

      // Slave Address Check to Transfer Data
      if(i2c_sq_itm.slv_addr_transfer === 1) begin
        if(i2c_sq_itm.slave_addr_wr_rd_bit === exp_trns_itm.slave_addr_wr_rd_bit) begin
          uvm_report_info("PASSED", $sformatf("Expected {Slv Addr, Wr/Rd Bit} :: %0h \t Actual {Slv Addr, Wr/Rd Bit} :: %0h", exp_trns_itm.slave_addr_wr_rd_bit, i2c_sq_itm.slave_addr_wr_rd_bit), UVM_NONE);
          trnsfr_chkr++;
        end
        else begin
          uvm_report_info("FAILED", $sformatf("Expected {Slv Addr, Wr/Rd Bit} :: %0h \t Actual {Slv Addr, Wr/Rd Bit} :: %0h", exp_trns_itm.slave_addr_wr_rd_bit, i2c_sq_itm.slave_addr_wr_rd_bit), UVM_NONE);
        end
      end
      
      // Initial Memory Address Check to Transfer Data
      if(i2c_sq_itm.mem_addr_transfer === 1) begin
        if(i2c_sq_itm.memry_addr === exp_trns_itm.memry_addr) begin
          uvm_report_info("PASSED", $sformatf("Exp Init Mem Addr :: %0h \t Act Init Mem Addr :: %0h", exp_trns_itm.memry_addr, i2c_sq_itm.memry_addr), UVM_NONE);
        end
        else begin
          uvm_report_info("FAILED", $sformatf("Exp Init Mem Addr :: %0h \t Act Init Mem Addr :: %0h", exp_trns_itm.memry_addr, i2c_sq_itm.memry_addr), UVM_NONE);
        end
      end

      if(i2c_sq_itm.data_trns === 1) begin
        if(exp_trns_itm.memry_addr === i2c_sq_itm.memry_addr) begin
          if(i2c_sq_itm.transmit_data === exp_trns_itm.transmit_data) begin
            uvm_report_info("PASSED", $sformatf("Exp Transmit Data :: %0h \t Act Transmit Data :: %0h \t Exp Mem Addr :: %0h \t Act Mem Addr :: %0h", exp_trns_itm.transmit_data, i2c_sq_itm.transmit_data, exp_trns_itm.memry_addr, i2c_sq_itm.memry_addr), UVM_NONE);
          end
          else begin
            uvm_report_info("FAILED", $sformatf("Exp Transmit Data :: %0h \t Act Transmit Data :: %0h \t Exp Mem Addr :: %0h \t Act Mem Addr :: %0h", exp_trns_itm.transmit_data, i2c_sq_itm.transmit_data, exp_trns_itm.memry_addr, i2c_sq_itm.memry_addr), UVM_NONE);
          end
        end
      end
    end
  endfunction
endclass