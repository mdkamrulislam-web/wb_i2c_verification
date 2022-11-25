`uvm_analysis_imp_decl(_wb_wr_mtr2pdctr)

class wb_i2c_predictor extends uvm_component;
  // ! Fatory registration of Wishbone I2C Predictor
  `uvm_component_utils(wb_i2c_predictor)

  // ! Taking a queue as wb_wr_que
  wb_sequence_item wb_wr_que[$];

  // ! Declaring imports for getting monitor wishbone write packets
  uvm_analysis_imp_wb_wr_mtr2pdctr#(wb_sequence_item, wb_i2c_predictor) wb_wr_mtr2pdctr;

  // ! Wishbone I2C Predictor Constructor
  function new(string name = "wb_i2c_predictor", uvm_component parent = null);
    super.new(name, parent);
    `uvm_info(get_full_name(), "Inside Wishbone I2C Predictor Constructor Fucntion.", UVM_NONE)
  endfunction

  // ! Wishbone I2C Predictor Build Phase
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_full_name(), "Inside Wishbone I2C Predictor Build Phase.", UVM_NONE)

    wb_wr_mtr2pdctr = new("wb_wr_mtr2pdctr", this);
  endfunction

  // ! Wishbone I2C Predictor Connect Phase
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info(get_full_name(), "Inside Wishbone I2C Predictor Connect Phase.", UVM_NONE)
  endfunction

  // ! Wishbone I2C Predictor Run Phase
  task run_phase(uvm_phase phase);
    `uvm_info(get_full_name(), "Inside Wishbone I2C Predictor Run Phase.", UVM_NONE)
  endtask

  function void write_wb_wr_mtr2pdctr(wb_sequence_item wb_wr_exp_item);
    `uvm_info("WB_MONITOR ==> PREDICTOR", $sformatf("WB_ADDR_I = %0h :: WB_DATA_I = %0h", wb_wr_exp_item.wb_adr_i, wb_wr_exp_item.wb_dat_i), UVM_NONE)

    wb_wr_que.push_back(wb_wr_exp_item);
    // foreach (wb_wr_que[i]) begin
    //   `uvm_info("WISHBONE WRITE QUEUE", $sformatf("i :: %0d, Address :: %0d, Data :: %0d", i, wb_wr_que[i].wb_adr_i, wb_wr_que[i].wb_dat_i), UVM_NONE)
    // end
  endfunction
endclass
