class i2c_wr_rd_test extends wb_i2c_base_test;
  // Factory registration of WB Write Read Test
  `uvm_component_utils(i2c_wr_rd_test)

  logic [7:0] i2c_read_dat;

  // I2C Write Read Test Constructor
  function new(string name = "i2c_wr_rd_test", uvm_component parent = null);
    super.new(name, parent);
    `uvm_info(get_full_name(), "Inside I2C Write Read Test Constructor.", UVM_MEDIUM)
  endfunction

  // I2C Write Read Test Build Phase
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_full_name(), "Inside I2C Write Read Test Build Phase", UVM_MEDIUM)
  endfunction

  // I2C Write Read Test Connect Phase 
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info(get_full_name(), "Inside I2C Write Read Test Connect Phase.", UVM_MEDIUM)
  endfunction
  // I2C Write Read Test Run Phase
  task run_phase(uvm_phase phase);
    `uvm_info(get_full_name(), "Inside I2C Write Read Test Run Phase.", UVM_MEDIUM)

    /*
      UVM testbench components which uses an objection mechanism share a counter between them.
      The method raise_objection increments the count & drop_objection decrements the count.
    */

    // Objection raised to increment the count, so that the test doesn't stop immediately.
    phase.raise_objection(this);
      wb_reset_task();                                      // ! System Reset

      i2c_core_setup(8'h64, 8'h00, 8'hC0);                  // ! Core & Prescale Registers Setup
      
      i2c_write(`SLVADDR, 8'h01, 32'hAA_55_22_11, 2'b11);   // ! I2C Data Transfer
      i2c_read(`SLVADDR, 8'h01, 2'b11);                     // ! I2C Data Receive
    phase.drop_objection(this);

  endtask
endclass
