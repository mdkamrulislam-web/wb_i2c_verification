class wb_agent extends uvm_agent;
  // ! Factory Registration of Wishbone Agent
  `uvm_component_utils(wb_agent)

  // ! Declaring a handle of Wishbone Agent Config, Driver, Monitor, Sequencer
  wb_agent_config wb_agt_con ;
  wb_driver       wb_dvr     ;
  wb_monitor      wb_mtr     ;
  wb_sequencer    wb_sqr     ;

  // ! Wishbone Agent Constructor
  function new(string name = "wb_agent", uvm_component parent = null);
    super.new(name, parent);
    `uvm_info(get_full_name(), "Inside Wishbone Agent Constructor.", UVM_NONE)
  endfunction

  // ! Wishbone Agent Build Phase
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_full_name(), "Inside Wishbone Agent Build Phase.", UVM_NONE)

    // Getting WB_AGENT_CON from UVM Configuration Database which was set from WB_I2C_Environment to Configure WB_Agent.
    if(!uvm_config_db#(wb_agent_config)::get(this, "", "wb_agent_config", wb_agt_con)) begin
      `uvm_fatal("Wishbone Agent Configuration", {"Agent Configuration must be need for: ",get_full_name(),".wb_agt_con"})
    end
    else begin
      if(wb_agt_con.is_active == UVM_ACTIVE) begin
        wb_dvr = wb_driver    ::type_id::create("wb_dvr", this);
        wb_sqr = wb_sequencer ::type_id::create("wb_sqr", this);
      end
    end

    wb_mtr = wb_monitor::type_id::create("wb_mtr", this);
		
  endfunction

  // ! Wishbone Agent Connect Phase
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info(get_full_name(), "Inside Wishbone Agent Connect Phase.", UVM_NONE)
  endfunction

  // ! Wishbone Agent Run Phase
  task run_phase(uvm_phase phase);
    `uvm_info(get_full_name(), "Inside Wishbone Agent Run Phase.", UVM_NONE)
  endtask
endclass