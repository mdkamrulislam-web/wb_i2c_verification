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
  
  int write = 0;
  int read = 0;

  bit rep_wr;
  bit rep_rd;

  bit wr_stop_bit;

  // ! Declaring imports for getting monitor wishbone write packets
  uvm_analysis_imp_wb_wr_mtr2pdctr#(wb_sequence_item, wb_i2c_predictor) wb_wr_mtr2pdctr;

  // ! Declearing uvm_analysis_port, which is used to send packets from monitor to scoreboard.
  uvm_analysis_port #(i2c_sequence_item) exp_pred2scb_port;

  // ! Wishbone I2C Predictor Constructor
  function new(string name = "wb_i2c_predictor", uvm_component parent = null);
    super.new(name, parent);
    `uvm_info(get_full_name(), "Inside Wishbone I2C Predictor Constructor Fucntion.", UVM_MEDIUM)
    exp_pred2scb_port = new("exp_pred2scb_port", this);
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

  function void write_wb_wr_mtr2pdctr(wb_sequence_item item);
    i2c_sq_exp_item = i2c_sequence_item::type_id::create("i2c_sq_exp_item");
    if((item.wb_adr_i==`TXR) && (write == 0) && (read == 0)) begin
      temp_txr_data = item.wb_dat_i;
      write++;
      read++;
    end
    else if((write == 1) && (read == 1) && (item.wb_adr_i==`CR) && (item.wb_dat_i==8'b1001_0000)) begin
      i2c_sq_exp_item.slave_addr = temp_txr_data;
      write++;
      read++;
      exp_pred2scb_port.write(i2c_sq_exp_item);
      `uvm_info("I2C TRASMIT SLAVE ADDRESS STORED", $sformatf("Slave Address :: %0h", temp_txr_data), UVM_NONE)
    end
    else if((write == 2) && (read == 2) && (item.wb_adr_i==`TXR)) begin
      temp_mem_addr = item.wb_dat_i;
      write++;
      read++;
    end
    else if((write == 3) && (read == 3) && (item.wb_adr_i == `CR) && (item.wb_dat_i==8'b0001_0000)) begin
      i2c_sq_exp_item.memry_addr = temp_mem_addr;
      write++;
      read++;
      exp_pred2scb_port.write(i2c_sq_exp_item);
      `uvm_info("I2C TRASMIT MEM ADDRESS STORED", $sformatf("Memory Address :: %0h", temp_txr_data), UVM_NONE)
    end
    else if((write == 4) && (read == 4) && (item.wb_adr_i == `TXR)) begin
      temp_txr_data = item.wb_dat_i;
      write++;
      read++;
    end
    else if((write == 5) && (item.wb_adr_i == `CR) && (item.wb_dat_i == 8'b0101_0000)) begin
      read = 0;
      write = 0;
      i2c_sq_exp_item.exp_transmit_data = temp_txr_data;
      exp_pred2scb_port.write(i2c_sq_exp_item);
      `uvm_info("I2C TRASMIT DATA STORED", $sformatf("Data :: %0h", temp_txr_data), UVM_NONE)
    end
    else if((write >= 5) && (item.wb_adr_i == `TXR)) begin
      read = 0;
      write++;
      temp_txr_data = item.wb_dat_i;
    end
    else if((write >= 6) && (item.wb_adr_i == `CR) && (item.wb_dat_i == 8'b0001_0000)) begin
      i2c_sq_exp_item.exp_transmit_data = temp_txr_data;
      exp_pred2scb_port.write(i2c_sq_exp_item);
      `uvm_info("I2C TRASMIT DATA STORED", $sformatf("Data:: %0h", temp_txr_data), UVM_NONE)
    end

    /*
    else if((write == 5) && (read == 5) && (item.wb_adr_i == `CR) && (item.wb_dat_i == 8'b0001_0000)) begin
      read = 0;
      write++;
    end
    else if((write == 5) && (read == 5) && (item.wb_adr_i == `CR) && (item.wb_dat_i == 8'b1001_0000)) begin
      write = 0;
      read++;
    end
    */






    /*
    else if((write == 0) && (read == 6) && (item.wb_adr_i == `CR) && (item.wb_dat_i == 8'b0110_0000)) begin
      stop_bit = 1;
    end
    
    if(!stop_bit && (item.wb_adr_i = `RXR)) begin
      i2c_sq_exp_item.exp_receive_data = item.wb_dat_o;
      exp_pred2scb_port.write(i2c_sq_exp_item);
    end
    */
    //foreach (i2c_wr_que[i]) begin
      //`uvm_info("WISHBONE WRITE QUEUE", $sformatf("i :: %0d, Slave Address :: %0h", i, i2c_wr_que[i].slave_addr), UVM_NONE)
    //end
  endfunction
endclass
