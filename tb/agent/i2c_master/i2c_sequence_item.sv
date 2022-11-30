class i2c_sequence_item extends uvm_sequence_item;
  // ! Declaring Parameters
  logic [7:0] slave_addr ;
  logic [7:0] memry_addr ;
  logic [7:0] exp_transmit_data;
  logic [7:0] exp_receive_data;
  
  // ! The `uvm_object_utils or `uvm_object_utils_begin..`uvm_object_utils_end macros are used to register an uvm_object and other derived types like uvm_transaction, uvm_sequece_items in the UVM factory.
  `uvm_object_utils_begin(i2c_sequence_item)
    `uvm_field_int(slave_addr  , UVM_ALL_ON)
    `uvm_field_int(memry_addr   , UVM_ALL_ON)
    `uvm_field_int(exp_transmit_data  , UVM_ALL_ON)
    `uvm_field_int(exp_receive_data   , UVM_ALL_ON)
  `uvm_object_utils_end

  // ! WB Sequence Item Constructor
  function new(string name = "wb_sequence_item");
    super.new(name);
  endfunction
endclass