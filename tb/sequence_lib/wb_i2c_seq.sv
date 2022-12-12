class wb_i2c_seq extends uvm_sequence #(wb_sequence_item);
  // ! Factory registration of WB_I2C Sequence
  `uvm_object_utils(wb_i2c_seq)

  // ! Declaring handles for global parameters
  wb_sequence_item wb_item;
  bit randomization;

  bit [2:0] wb_address;
  bit [7:0] wb_dataIn;
  bit       wb_resetIn;
  bit       wb_arestIn;
  bit       wb_writeEnIn;

  // ! WB_I2C Sequence Constructor
  function new(string name = "wb_i2c_seq");
    super.new(name);
    `uvm_info(get_full_name(), "Inside WB_I2C Sequence Constructor.", UVM_HIGH)
  endfunction
endclass

/*
rand  logic       wb_rst_i ; 
rand  logic       arst_i   ;
rand  logic [2:0] wb_adr_i ;
rand  logic [7:0] wb_dat_i ;
      logic [7:0] wb_dat_o ;
rand  logic       wb_we_i  ;
      logic       wb_stb_i ;
      logic       wb_cyc_i ;
      logic       wb_ack_o ;
      logic       wb_inta_o;
*/