class i2c_transmit_receive_test extends wb_i2c_base_test;
  // Factory registration of WB Write Read Test
  `uvm_component_utils(i2c_transmit_receive_test)

  logic [7:0] i2c_read_dat;

  // I2C Write Read Test Constructor
  function new(string name = "i2c_transmit_receive_test", uvm_component parent = null);
    super.new(name, parent);
    `uvm_info(get_full_name(), "Inside I2C Transmit Test Constructor.", UVM_HIGH)
  endfunction

  // I2C Write Read Test Build Phase
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_full_name(), "Inside I2C Transmit Test Build Phase", UVM_HIGH)
  endfunction

  // I2C Write Read Test Connect Phase 
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info(get_full_name(), "Inside I2C Transmit Test Connect Phase.", UVM_HIGH)
  endfunction
  // I2C Write Read Test Run Phase
  task run_phase(uvm_phase phase);
    `uvm_info(get_full_name(), "Inside I2C Transmit Test Run Phase.", UVM_HIGH)

    /*
      UVM testbench components which uses an objection mechanism share a counter between them.
      The method raise_objection increments the count & drop_objection decrements the count.
    */

    // Objection raised to increment the count, so that the test doesn't stop immediately.
    phase.raise_objection(this);
      wb_reset_task();                                              // ! System Reset

      i2c_core_setup(8'h64, 8'h00, 8'hC0);                          // ! Core & Prescale Registers Setup
//      i2c_write(`SLVADDR, 0, 5, `DATAWIDTH_8, 0);
      for(int i = 0; i < 4; i++) begin
        i2c_write(`SLVADDR, i, $urandom_range(0, ((2**32)-1)), (`DATAWIDTH_32 - (i*8)), 0);
        i2c_read( `SLVADDR, 0,                                 `DATAWIDTH_32,           0);
      end
      
      #100000ns;
      phase.drop_objection(this);
  endtask
      // NOTE::
      /*############################################################################################################################################
      SETUP   ::              i2c_core_setup([Prescaler Low Data] , [Prescaler High Data], [Control Reg Data]              )              ##########
      ##########                            ([8'h00 - 8'hFF]      , [8'h00 - 8'hFF]      , [Core Enable & Interrupt Enable])              ##########
      ##############################################################################################################################################
      TRANSMIT:: i2c_write([Slave Address], [Memory Address], [Data To be Transmitted], [Data Width], [Repeated Start Enabled/ Disabled]) ##########
      ##########          ([`SLVADDR]     , [0-3] = Wr/Rd   , [0 - 255]               , [32 Bits]   , [0 = Disabled / 1 = Enabled]      ) ##########
      ##############################################################################################################################################
      RECEIVE ::              i2c_read([Slave Address], [Memory Address], [Data Width], [Repeated Start Enabled/ Disabled])               ##########
      ##########                      ([`SLVADDR]     , [0-3] = Wr/Rd   , [0 - 255]   , [0 = Disabled / 1 = Enabled]      )               ##########
      ############################################################################################################################################*/
endclass