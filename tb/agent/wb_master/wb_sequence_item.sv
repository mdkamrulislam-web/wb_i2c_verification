class wb_sequence_item extends uvm_sequence_item;
  // ! Declaring Parameters
  rand  logic       wb_rst_i ; 
  rand  logic       arst_i   ;
  rand  logic [2:0] wb_adr_i ;
  rand  logic [7:0] wb_dat_i ;
        logic [7:0] wb_dat_o ;
        logic       wb_we_i  ;
        logic       wb_stb_i ;
        logic       wb_cyc_i ;
        logic       wb_ack_o ;
        logic       wb_inta_o;

  // ! The `uvm_object_utils or `uvm_object_utils_begin..`uvm_object_utils_end macros are used to register an uvm_object and other derived types like uvm_transaction, uvm_sequece_items in the UVM factory.
  `uvm_object_utils_begin(wb_sequence_item)
    `uvm_field_int(wb_rst_i , UVM_ALL_ON)
    `uvm_field_int(arst_i   , UVM_ALL_ON)
    `uvm_field_int(wb_adr_i , UVM_ALL_ON)
    `uvm_field_int(wb_dat_i , UVM_ALL_ON)
    `uvm_field_int(wb_dat_o , UVM_ALL_ON)
    `uvm_field_int(wb_we_i  , UVM_ALL_ON)
    `uvm_field_int(wb_stb_i , UVM_ALL_ON)
    `uvm_field_int(wb_cyc_i , UVM_ALL_ON)
    `uvm_field_int(wb_ack_o , UVM_ALL_ON)
    `uvm_field_int(wb_inta_o, UVM_ALL_ON)
  `uvm_object_utils_end

  // ! WB Sequence Item Constructor
  function new(string name = "wb_sequence_item");
    super.new(name);
  endfunction
endclass