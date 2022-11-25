`uvm_analysis_imp_decl(_wb_wr_mtr2pdctr)

class wb_i2c_predictor extends uvm_component;
  // ! Fatory registration of Wishbone I2C Predictor
  `uvm_component_utils(wb_i2c_predictor)

  `include "../defines/defines.sv"

  // ! Taking a queue as wb_wr_que
  i2c_sequence_item i2c_wr_que[$];
  i2c_sequence_item i2c_sq_exp_item;
  logic [7:0] temp_txr_data;
  logic [7:0] temp_mem_addr;
  
  static [1:0] slv_addr_write_count;
  static bit write_stop;
  static bit read_stop;

  // ! Declaring imports for getting monitor wishbone write packets
  uvm_analysis_imp_wb_wr_mtr2pdctr#(wb_sequence_item, wb_i2c_predictor) wb_wr_mtr2pdctr;

  // ! Wishbone I2C Predictor Constructor
  function new(string name = "wb_i2c_predictor", uvm_component parent = null);
    super.new(name, parent);
    `uvm_info(get_full_name(), "Inside Wishbone I2C Predictor Constructor Fucntion.", UVM_MEDIUM)
  endfunction

  // ! Wishbone I2C Predictor Build Phase
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_full_name(), "Inside Wishbone I2C Predictor Build Phase.", UVM_MEDIUM)

    wb_wr_mtr2pdctr = new("wb_wr_mtr2pdctr", this);
  endfunction

  // ! Wishbone I2C Predictor Connect Phase
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info(get_full_name(), "Inside Wishbone I2C Predictor Connect Phase.", UVM_MEDIUM)
  endfunction

  // ! Wishbone I2C Predictor Run Phase
  task run_phase(uvm_phase phase);
    `uvm_info(get_full_name(), "Inside Wishbone I2C Predictor Run Phase.", UVM_MEDIUM)
  endtask
  
  // ! SLAVE ADDRESS STORAGE FUNCTION
  function void i2c_slv_addr_store(wb_sequence_item  item);
    if(item.wb_adr_i==`TXR) begin
      temp_txr_data = item.wb_dat_i;
    end
    else if((item.wb_adr_i==`CR) && (item.wb_dat_i==8'b1001_0000)) begin
      i2c_sq_exp_item.slave_addr_write = temp_txr_data;
      i2c_wr_que.push_back(i2c_sq_exp_item);
      `uvm_info("I2C TRASMIT SLAVE ADDRESS STORED", $sformatf("Slave Address :: %0h", temp_txr_data), UVM_NONE)
    end
  endfunction

  function void write_wb_wr_mtr2pdctr(wb_sequence_item wb_wr_exp_item);
    i2c_sq_exp_item = i2c_sequence_item::type_id::create("i2c_sq_exp_item");
    i2c_slv_addr_store(wb_wr_exp_item);
    //`uvm_info("WB_MONITOR ==> PREDICTOR", $sformatf("WB_ADDR_I = %0h :: WB_DATA_I = %0h", wb_wr_exp_item.wb_adr_i, wb_wr_exp_item.wb_dat_i), UVM_NONE)

    //wb_wr_que.push_back(wb_wr_exp_item);
     foreach (i2c_wr_que[i]) begin
       `uvm_info("WISHBONE WRITE QUEUE", $sformatf("i :: %0d, Slave Address :: %0h", i, i2c_wr_que[i].slave_addr_write), UVM_NONE)
     end
  endfunction
endclass
