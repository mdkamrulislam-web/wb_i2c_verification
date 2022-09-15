class wb_monitor extends uvm_monitor;
  // ! Factory registration of Wishbone Monitor
  `uvm_component_utils(wb_monitor)

  // ! Declaring handle for virtual interface
  virtual wb_interface wb_intf;

  // ! Wishbone Monitor Constructor
  function new(string name = "wb_monitor", uvm_component parent = null);
    super.new(name, parent);
    `uvm_info(get_full_name(), "Inside Wishbone Monitor Constructor.", UVM_NONE)
  endfunction

  // ! Wishbone Monitor Build Phase
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_full_name(), "Inside Wishbone Monitor Build Phase.", UVM_NONE)

    if(!uvm_config_db#(virtual wb_interface)::get(this, "", "wb_vintf", wb_intf)) begin
      `uvm_fatal("WB Virtual Interface Not Found Inside Monitor!", {"Virtual interface must be set for: ",get_full_name(),".wb_vintf"})
    end
    else begin
      `uvm_info("WB_INTF", "WB Virtual Interface found inside monitor.", UVM_NONE)
    end
  endfunction

  // ! Wishbone Monitor Connect Phase
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info(get_full_name(), "Inside Wishbone Monitor Connect Phase.", UVM_NONE)
  endfunction

  // ! Wishbone Monitor Run Phase
  task run_phase(uvm_phase phase);
    `uvm_info(get_full_name(), "Inside Wishbone Monitor Run Phase.", UVM_NONE)
  endtask
endclass