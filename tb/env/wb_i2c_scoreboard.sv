// ! The `uvm_analysis_imp_decl allows for a scoreboard (or other analysis component) to support input from many places. If you want each export to call a different write() method, you need to use these macros. We need 2 import, one for expected packet which is sent by driver and received packet which is coming from receiver. Declaring 2 imports using `uvm_analysis_imp_decl macros.

`uvm_analysis_imp_decl(_exp_pred2scb)
//`uvm_analysis_imp_decl(_wb_act_mtr2scb)

class wb_i2c_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(wb_i2c_scoreboard)

	// ! Taking a queue as exp_que
	i2c_sequence_item exp_que[$];
	//wb_sequence_item act_que[$];
  i2c_sequence_item exp_pred_item;

	// ! Declaring imports for getting driver packets and monitor packets.
	uvm_analysis_imp_exp_pred2scb#(i2c_sequence_item, wb_i2c_scoreboard) exp_pred2scb;
	//uvm_analysis_imp_wb_act_mtr2scb#(wb_sequence_item, wb_i2c_scoreboard) wb_act_mtr2scb;

  function new(string name = "wb_i2c_scoreboard", uvm_component parent = null);
    super.new(name, parent);
    `uvm_info(get_full_name(), "Inside WB_I2C Scoreboard Constructor.", UVM_MEDIUM)
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_full_name(), "Inside WB_I2C Scoreboard Build Phase.", UVM_MEDIUM)

    // Creating objects for the above declared imports
    exp_pred2scb = new("exp_pred2scb", this);
    //wb_act_mtr2scb = new("wb_act_mtr2scb", this);
    
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info(get_full_name(), "Inside WB_I2C Scoreboard Connect Phase.", UVM_MEDIUM)
  endfunction

  task run_phase(uvm_phase phase);
    `uvm_info(get_full_name(), "Inside WB_I2C Scoreboard Run Phase.", UVM_MEDIUM)
  endtask

	// ! Defining write_wb_exp_mtr2scb() method which was created by macro `uvm_analysis_imp_decl(_wb_exp_mtr2scb).	
	// Storing the received packet in the expected queue.
	function void write_exp_pred2scb(i2c_sequence_item exp_item);
		//`uvm_info("PREDICTOR ==> SCOREBOARD", $sformatf("SLV_ADDR = %0h, MEM_ADDR = %0h, DATA = %0h", exp_item.slave_addr, exp_item.memry_addr, exp_item.exp_transmit_data), UVM_LOW);
    
		exp_que.push_back(exp_item);

    foreach (exp_que[i]) begin
      `uvm_info("SCOREBOARD", $sformatf("i :: %0d, Slave Address :: %0h, Memory Address :: %0h, Data :: %0h", i, exp_que[i].slave_addr, exp_que[i].memry_addr, exp_que[i].exp_transmit_data), UVM_NONE)
    end
	endfunction

  /*
  function void write_exp_pred2scb(wb_sequence_item wb_act_item);
    wb_sequence_item exp_item;
    `uvm_info("MONITOR ==> SCOREBOARD ACT", $sformatf("ADDR = %0h, DATA = %0h, Size :: %0d", wb_act_item.wb_adr_i, wb_act_item.wb_dat_o, exp_que.size()), UVM_LOW);
    
    if(exp_que.size() != 0) begin
      exp_item = exp_que.pop_front();

      if(wb_act_item.wb_adr_i == exp_item.wb_adr_i) begin
        if(wb_act_item.wb_dat_o == exp_item.wb_dat_i) begin
          uvm_report_info("PASSED", $psprintf("CAPTURED DATA & EXPECTED DATA MATCHED =====> EXPECTED ADDR = %h :: CAPTURED ADDR = %h :: EXPECTED DATA = %h :: CAPTURED DATA = %h\t", exp_item.wb_adr_i, wb_act_item.wb_adr_i, exp_item.wb_dat_i, wb_act_item.wb_dat_o), UVM_NONE);
        end
        else begin
					uvm_report_info("FAILED", $psprintf("CAPTURED DATA & EXPECTED DATA MISMATCHED =====> EXPECTED ADDR = %h :: CAPTURED ADDR = %h :: EXPECTED DATA = %h :: CAPTURED DATA = %h\t", exp_item.wb_adr_i, wb_act_item.wb_adr_i, exp_item.wb_dat_i, wb_act_item.wb_dat_o), UVM_NONE);
				end
      end
      else begin
        uvm_report_info("FAILED", $psprintf("CAPTURED DATA & EXPECTED DATA MISMATCHED =====> EXPECTED ADDR = %h :: CAPTURED ADDR = %h :: EXPECTED DATA = %h :: CAPTURED DATA = %h\t", exp_item.wb_adr_i, wb_act_item.wb_adr_i, exp_item.wb_dat_i, wb_act_item.wb_dat_o), UVM_NONE);
      end
    end
    else begin
			uvm_report_info(get_type_name(), $psprintf("No more items in the expected queue to compare."), UVM_NONE);
		end
    
  endfunction
  */
/*
  function void compare();
    $display("exp queue = %d, act queue = %0d", exp_que.size(), act_que.size());
  endfunction
*/
endclass