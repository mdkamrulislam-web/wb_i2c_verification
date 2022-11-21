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
      wb_reset_task();                          // ! System Reset

      i2c_core_setup(8'h64, 8'h00, 8'hC0);      // ! Core & Prescale Registers Setup

      i2c_write(`SLVADDR, 8'h02, 8'b1010_1010); // ! I2C Write Transfer
      i2c_read(`SLVADDR, 8'h02);                // ! I2C Read Transfer

      i2c_write(`SLVADDR, 8'h01, 8'b0101_0101); // ! I2C Write Transfer
      i2c_read(`SLVADDR, 8'h01);                // ! I2C Read Transfer

      // for(int i = 0; i < 4; i++) begin
      //   for(int j = 0; j < 256; j++) begin
      //     i2c_write(`SLVADDR, i, j);  // ! I2C Write Transfer
      //     i2c_read(`SLVADDR, i)       // ! I2C Read Transfer
      //   end
      // end
    phase.drop_objection(this);

  endtask
endclass