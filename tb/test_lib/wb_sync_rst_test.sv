class wb_sync_rst_test extends wb_i2c_base_test;
  // ! Factory registration of WB Synchronous Reset Test
  `uvm_component_utils(wb_sync_rst_test)

  // ! WB Synchronous Reset Test Constructor
  function new(string name = "wb_sync_rst_test", uvm_component parent = null);
    super.new(name, parent);
    `uvm_info(get_full_name(), "Inside WB Synchronous Reset Test Constructor.", UVM_NONE)
  endfunction

  // ! WB Synchronous Reset Test Build Phase
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_full_name(), "Inside WB Synchronous Reset Test Build Phase", UVM_NONE)
  endfunction

  // ! WB Synchronous Reset Test Connect Phase 
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info(get_full_name(), "Inside WB Synchronous Reset Test Connect Phase.", UVM_NONE)
  endfunction
  // ! WB Synchronous Reset Test Run Phase
  task run_phase(uvm_phase phase);
    `uvm_info(get_full_name(), "Inside WB Synchronous Reset Test Run Phase.", UVM_NONE)

    /*
		UVM testbench components which uses an objection mechanism share a counter between them.
		The method raise_objection increments the count & drop_objection decrements the count.
		*/

		// Objection raised to increment the count, so that the test doesn't stop immediately.
		phase.raise_objection(this);
      wb_sync_reset_task();
    phase.drop_objection(this);
  endtask
endclass

