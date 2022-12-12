class wb_wr_rd_test extends wb_i2c_base_test;
  // Factory registration of WB Write Read Test
  `uvm_component_utils(wb_wr_rd_test)

  reg [7:0] check_SR;
  reg [7:0] data_R;

  // WB Write Read Test Constructor
  function new(string name = "wb_wr_rd_test", uvm_component parent = null);
    super.new(name, parent);
    `uvm_info(get_full_name(), "Inside WB Write Read Test Constructor.", UVM_HIGH)
  endfunction

  // WB Write Read Test Build Phase
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_full_name(), "Inside WB Write Read Test Build Phase", UVM_HIGH)
  endfunction

  // WB Write Read Test Connect Phase 
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info(get_full_name(), "Inside WB Write Read Test Connect Phase.", UVM_HIGH)
  endfunction
  // WB Write Read Test Run Phase
  task run_phase(uvm_phase phase);
    `uvm_info(get_full_name(), "Inside WB Write Read Test Run Phase.", UVM_HIGH)

    /*
      UVM testbench components which uses an objection mechanism share a counter between them.
      The method raise_objection increments the count & drop_objection decrements the count.
    */

    // Objection raised to increment the count, so that the test doesn't stop immediately.
    // * Write --> bit randomization, bit [2:0] addr, bit [7:0] data
    // * Read  --> bit [2:0] addr
    phase.raise_objection(this);

      // RESET
      wb_reset_task();

      ////////////////////////////////////
      // Initialize The I2C Master Core //
      ////////////////////////////////////
      // Setting the Prescale Register to the desired Value
      wb_write_task(0, `PRER_LO, 8'h64);
      wb_write_task(0, `PRER_HI, 8'h00);
      
      // Enabling the Core
      wb_write_task(0, `CTR, 8'h80);

      /////////////////////////////////////
      // Drive Slave Address & Write Bit //
      /////////////////////////////////////
      // Enabling Start and Write
      wb_write_task(0, `CR, 8'h90);
      wb_write_task(0, `TXR, {`SLVADDR, `WR});
      
      ////////////////////////////////////////
      // Polling TIP bit of Status Register //
      ////////////////////////////////////////
      wb_read_task(`SR, tip_flag);
      `uvm_info("TIP_FLAG_CHECKER", $sformatf("TIP :: %0d", tip_flag), UVM_MEDIUM)
      while (tip_flag) begin
        wb_read_task(`SR, tip_flag);
        `uvm_info("TIP_FLAG_CHECKER", $sformatf("TIP :: %0d", tip_flag), UVM_MEDIUM)
      end

      //////////////////////////
      // Slave Memory Address //
      //////////////////////////
      wb_write_task(0, `TXR, 8'h05);
      wb_write_task(0, `CR, 8'h10);

      ////////////////////////////////////////
      // Polling TIP bit of Status Register //
      ////////////////////////////////////////
      wb_read_task(`SR, tip_flag);
      `uvm_info("TIP_FLAG_CHECKER", $sformatf("TIP :: %0d", tip_flag), UVM_MEDIUM)
      while (tip_flag) begin
        wb_read_task(`SR, tip_flag);
        `uvm_info("TIP_FLAG_CHECKER", $sformatf("TIP :: %0d", tip_flag), UVM_MEDIUM)
      end

      ///////////////////////////
      // Writing Data to Slave //
      ///////////////////////////
      wb_write_task(0, `TXR, 8'hAA);
      wb_write_task(0, `CR, 8'h10);

      ////////////////////////////////////////
      // Polling TIP bit of Status Register //
      ////////////////////////////////////////
      wb_read_task(`SR, tip_flag);
      `uvm_info("TIP_FLAG_CHECKER", $sformatf("TIP :: %0d", tip_flag), UVM_MEDIUM)
      while (tip_flag) begin
        wb_read_task(`SR, tip_flag);
        `uvm_info("TIP_FLAG_CHECKER", $sformatf("TIP :: %0d", tip_flag), UVM_MEDIUM)
      end

      //////////////
      // Stop Bit //
      //////////////
      wb_write_task(0, `CR, 8'h40);

      #100000;

      wb_read_task(`RXR, tip_flag);

      #20000;

    phase.drop_objection(this);

  endtask
endclass