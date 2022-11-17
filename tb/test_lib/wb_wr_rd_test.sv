class wb_wr_rd_test extends wb_i2c_base_test;
  // Factory registration of WB Write Read Test
  `uvm_component_utils(wb_wr_rd_test)

  reg [7:0] check_SR;
  reg [7:0] data_R;

  // WB Write Read Test Constructor
  function new(string name = "wb_wr_rd_test", uvm_component parent = null);
    super.new(name, parent);
    `uvm_info(get_full_name(), "Inside WB Write Read Test Constructor.", UVM_MEDIUM)
  endfunction

  // WB Write Read Test Build Phase
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_full_name(), "Inside WB Write Read Test Build Phase", UVM_MEDIUM)
  endfunction

  // WB Write Read Test Connect Phase 
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info(get_full_name(), "Inside WB Write Read Test Connect Phase.", UVM_MEDIUM)
  endfunction
  // WB Write Read Test Run Phase
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

      /////////////////////////////
      // Write to a Slave Device //
      /////////////////////////////
      // Transmit Register
      // wb_write_task(0, 3, 8'h8A); // Slv Addr = 8'h45, Wr = 0 :: {8'h45, 0} = 8'h8A
      // wb_write_task(0, 3, 8'h20); // Slv Addr = 8'h10, Wr = 0 :: {8'h10, 0} = 8'h20
      // wb_write_task(0, 3, 8'h20); // Slv Addr = 8'h51, Wr = 0 :: {8'h51, 0} = 8'hA2
      //wb_write_task(0, TXR, 8'hFC); // Slv Addr = 8'h7E, Wr = 0 :: {8'h7E, 0} = 8'hFC
      
// b111_1110
      // Enabling Start and Write
      wb_write_task(0, `CR, 8'h90);
      wb_write_task(0, `TXR, {`SLVADDR, `WR});

      // Setting Slave Memory Address for the data to be written
      //wb_write_task(0, 3, 8'hAC);

      // Setting Command Register to such a value so that a Write Transfer can be done
      //wb_write_task(0, 4, 8'h10);
      //#1000ns;

      //wb_read_task(`PRER_LO);
      //wb_read_task(`PRER_HI);
      //wb_read_task(`CTR);
      /*
      wb_read_task(`SR);
      
      while (wb_i2c_env.wb_agt.wb_dvr.tip_flag) begin
        wb_read_task(`SR);
        `uvm_info("TIP_FLAG_CHECKER", $sformatf("TIP :: %0d", wb_i2c_env.wb_agt.wb_dvr.tip_flag), UVM_NONE)
      end
      */

      wb_read_task(`SR, tip_flag);
      
      while (tip_flag) begin
        wb_read_task(`SR, tip_flag);
        //`uvm_info("TIP_FLAG_CHECKER", $sformatf("TIP :: %0d", wb_i2c_env.wb_agt.wb_dvr.tip_flag), UVM_NONE)
      end
      #150000ns;

    phase.drop_objection(this);

  endtask
endclass