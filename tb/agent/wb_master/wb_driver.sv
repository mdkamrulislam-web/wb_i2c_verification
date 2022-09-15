class wb_driver extends uvm_driver #(wb_sequence_item);
  // ! Factory registration of Wishbone Driver
  `uvm_component_utils(wb_driver)

  // ! Wishbone Driver Constructor
  function new(string name = "wb_driver", uvm_component parent = null);
    super.new(name, parent);
    `uvm_info(get_full_name(), "Inside Wishbone Driver Constructor.", UVM_NONE)
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_full_name(), "Inside Wishbone Driver Build Phase.", UVM_NONE)
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    `uvm_info(get_full_name(), "Inside Wishbone Driver Connect Phase.", UVM_NONE)
  endfunction

  task run_phase(uvm_phase phase);
    `uvm_info(get_full_name(), "Inside Wishbone Driver Run Phase.", UVM_NONE)
  endtask

endclass