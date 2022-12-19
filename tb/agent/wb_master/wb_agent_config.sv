class wb_agent_config extends uvm_object;
  // ! Factory registration of Wishbone Agent Configuration
  `uvm_object_utils(wb_agent_config)

  uvm_active_passive_enum is_active = UVM_ACTIVE;
  bit has_functional_coverage;

  bit wb_agt_con_rep_st_en      ;
  int wb_agt_con_i2c_trans_byte ;
  bit [1:0] wb_agt_con_i2c_tr_rc;

  // ! Wishbone Agent Configuration Constructor
  function new(string name = "wb_agent_config");
    super.new(name);
    `uvm_info(get_full_name(), "Inside WB Agent Config Constructor", UVM_HIGH)
  endfunction
endclass