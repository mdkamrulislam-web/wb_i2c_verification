class wb_i2c_predictor extends uvm_component;
  // ! Fatory registration of Wishbone I2C Predictor
  `uvm_component_utils(wb_i2c_predictor)

  // ! Taking two array as exp_data_arr & exp_addr_arr
  logic [7:0] wb_data_i_arr [];
  logic [2:0] wb_addr_i_arr [];

  // ! Wishbone I2C Predictor Constructor
  function new(string name = "wb_i2c_predictor", uvm_component parent = null);
    super.new(name, parent);

    `uvm_info(get_full_name(), "Inside Wishbone I2C Predictor Constructor Fucntion.", UVM_NONE)
  endfunction

  // ! Wishbone I2C Predictor Build Phase
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    `uvm_info(get_full_name(), "Inside Wishbone I2C Predictor Build Phase.", UVM_NONE)
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
    
    wb_data_i_arr = new[wb_data_i_arr.size() + 1] (wb_data_i_arr);
    wb_addr_i_arr = new[wb_addr_i_arr.size() + 1] (wb_addr_i_arr);
    
    wb_data_i_arr[wb_data_i_arr.size() - 1] = wb_wr_exp_item.wb_adr_i;
    wb_addr_i_arr[wb_addr_i_arr.size() - 1] = wb_wr_exp_item.wb_adr_i;

    `uvm_info("Predictor Data & Addr Array", $sformatf("Data Array ==> %p :: Addr Array ==> %p", wb_data_i_arr, wb_addr_i_arr), UVM_NONE)

  endfunction
endclass
