class wb_sequencer extends uvm_sequencer #(wb_sequence_item);
  // ! Factory registration of Wishbone Sequencer
  `uvm_component_utils(wb_sequencer)

  // ! Wishbone Sequencer Constructor
  function new(string name = "wb_sequencer", uvm_component parent = null);
    super.new(name, parent);
    `uvm_info(get_full_name(), "Inside Wishbone Sequencer Constructor.", UVM_NONE)
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_full_name(), "Inside Wishbone Sequencer Build Phase.", UVM_NONE)
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info(get_full_name(), "Inside Wishbone Sequencer Connect Phase.", UVM_NONE)
  endfunction

  task run_phase(uvm_phase phase);
    `uvm_info(get_full_name(), "Inside Wishbone Sequencer Run Phase.", UVM_NONE)
  endtask
endclass