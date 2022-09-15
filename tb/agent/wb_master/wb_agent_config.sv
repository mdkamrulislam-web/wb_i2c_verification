class wb_agent_config extends uvm_object;
  // ! Factory registration of Wishbone Agent Configuration
  `uvm_object_utils(wb_agent_config)

  uvm_active_passive_enum is_active = UVM_PASSIVE;
  bit has_functional_coverage;

  // ! Wishbone Agent Configuration Constructor
  function new(string name = "wb_agent_config");
    super.new(name);
  endfunction
endclass