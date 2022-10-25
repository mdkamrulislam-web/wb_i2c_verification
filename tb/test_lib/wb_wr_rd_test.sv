class wb_wr_rd_test extends wb_i2c_base_test;
  // ! Factory registration of WB Write Read Test
  `uvm_component_utils(wb_wr_rd_test)

  // ! WB Write Read Test Constructor
  function new(string name = "wb_wr_rd_test", uvm_component parent = null);
    super.new(name, parent);
    `uvm_info(get_full_name(), "Inside WB Write Read Test Constructor.", UVM_MEDIUM)
  endfunction

  // ! WB Write Read Test Build Phase
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_full_name(), "Inside WB Write Read Test Build Phase", UVM_MEDIUM)
  endfunction

  // ! WB Write Read Test Connect Phase 
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info(get_full_name(), "Inside WB Write Read Test Connect Phase.", UVM_MEDIUM)
  endfunction
  // ! WB Write Read Test Run Phase
  task run_phase(uvm_phase phase);
    `uvm_info(get_full_name(), "Inside WB Write Read Test Run Phase.", UVM_MEDIUM)

    /*
		UVM testbench components which uses an objection mechanism share a counter between them.
		The method raise_objection increments the count & drop_objection decrements the count.
		*/

		// Objection raised to increment the count, so that the test doesn't stop immediately.
		// * Write --> bit randomization, bit [2:0] addr, bit [7:0] data
    // * Read  --> bit [2:0] addr
    phase.raise_objection(this);

      // ! RESET
      wb_reset_task();

      // ! WRITE
      //wb_write_task(0, 1, 8'h3F);
      //wb_write_task(0, 0, 8'h00);
      wb_write_task(0, 2, 8'hC0);
      wb_write_task(0, 9, 8'hEF);

      wb_read_task(2);
      wb_read_task(9);
      
      // ! READ
      //wb_read_task(0);
      //wb_read_task(1);
      //wb_read_task(2);

      #100;

    phase.drop_objection(this);

  endtask
endclass

