class wb_i2c_base_test extends uvm_test;
  `uvm_component_utils(wb_i2c_base_test)

  `include "../defines/defines.sv"

  bit         tip_flag;
  logic [7:0] wb_read_data;
  logic [7:0] i2c_read_data;

  // ! Declearing handle of the WB_I2C Environment, Environment Config, WB Agent Config
  wb_i2c_environment wb_i2c_env;
  wb_i2c_env_config wb_i2c_env_con;
  wb_agent_config wb_agt_con;

  // ! Declaring handles for different sequences.
  wb_rst_seq wb_rstn_sq;
  wb_wr_seq wb_wr_sq;
  wb_rd_seq wb_rd_sq;

  // ! WB_I2C Base Test Constructor: new
  function new(string name = "wb_i2c_base_test", uvm_component parent = null);
    super.new(name, parent);
    `uvm_info(get_full_name(), "Inside WB_I2C Base Test Constructor", UVM_MEDIUM)
  endfunction: new

  // ! WB_I2C Base Test Build Phase
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_full_name(), "Inside WB_I2C Base Test Build Phase", UVM_MEDIUM)

    // Creating Environment, Environment Config Instances
    wb_i2c_env     = wb_i2c_environment::type_id::create("wb_i2c_env"    , this);
    wb_i2c_env_con = wb_i2c_env_config ::type_id::create("wb_i2c_env_con", this);
    wb_agt_con     = wb_agent_config   ::type_id::create("wb_agt_con"    , this);

    // Setting parameters of WB_I2C Environment Configuration
    wb_i2c_env_con.has_scoreboard      = 0          ; 
    wb_agt_con.has_functional_coverage = 1          ;
    wb_agt_con.is_active               = UVM_ACTIVE ;

    // Pointing WB_AGT_CON of this class to WB_AGT_CON of WB_I2C_ENV_CON
		wb_i2c_env_con.wb_agt_con = wb_agt_con;

    // Setting WB_I2C_ENV_CON in UVM Configuration Database to get it from APB Environment.
    //uvm_config_db#(wb_i2c_env_config)::set(this, "wb_i2c_env", "wb_i2c_env_config", wb_i2c_env_con);
    uvm_config_db#(wb_i2c_env_config)::set(null, "uvm_test_top.wb_i2c_env", "wb_i2c_env_config", wb_i2c_env_con);

  endfunction

  // ! WB_I2C Base Test Connect Phase
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info(get_full_name(), "Inside WB_I2C Base Test Connect Phase", UVM_MEDIUM)
  endfunction

  // ! WB_I2C Base Test Run Phase
  virtual task run_phase(uvm_phase phase);
    `uvm_info(get_full_name(), "Inside WB_I2C Base Test Run Phase", UVM_MEDIUM)
  endtask

  // !      ###################################################
  // !      ############### Wishbone Reset Task ###############
  // !      ###################################################
  task wb_reset_task();
    // Creating WB Reset Sequence Instance
    wb_rstn_sq = wb_rst_seq::type_id::create("wb_rstn_sq");

    // Starting WB Reset Sequence through Sequencer
    wb_rstn_sq.start(wb_i2c_env.wb_agt.wb_sqr);
  endtask

  // !      ###################################################
  // !      ############### Wishbone Write Task ###############
  // !      ###################################################
  task wb_write_task(bit randomization, bit [2:0] addr, bit [7:0] data);
    // Creating WB Write Sequence Instance
    wb_wr_sq = wb_wr_seq::type_id::create("wb_wr_sq");

    wb_wr_sq.wb_address    = addr;
    wb_wr_sq.wb_dataIn     = data;
    wb_wr_sq.randomization = randomization;

    // Starting WB Write Sequence through Sequencer
    wb_wr_sq.start(wb_i2c_env.wb_agt.wb_sqr);
  endtask

  // !      ###################################################
  // !      ############### Wishbone Read Task ################
  // !      ###################################################
  task wb_read_task(bit [2:0] addr, output bit tip_flag);
    // Creating WB Read Sequence Instance
    wb_rd_sq = wb_rd_seq::type_id::create("wb_rd_sq");
    wb_rd_sq.wb_address = addr;

    // Starting WB Read Sequence through Sequencer
    wb_rd_sq.start(wb_i2c_env.wb_agt.wb_sqr);
    tip_flag     = wb_rd_sq.dvr_rsp.t_flag  ;

    //`uvm_info("READ_SEQ ===> TEST", $sformatf("TIP :: %0d", tip_flag), UVM_NONE)
  endtask
  
  // !      ###################################################
  // !      ######### WB Status Register Polling Task #########
  // !      ###################################################
  task tip_poll();
    ////////////////////////////////////////
    // Polling TIP bit of Status Register //
    ////////////////////////////////////////
    wb_read_task(`SR, tip_flag);
    //`uvm_info("TIP_FLAG_CHECKER", $sformatf("TIP :: %0d", tip_flag), UVM_NONE)
    while (tip_flag) begin
      wb_read_task(`SR, tip_flag);
      //`uvm_info("TIP_FLAG_CHECKER", $sformatf("TIP :: %0d", tip_flag), UVM_NONE)
    end
  endtask

  // !      ###################################################
  // !      ############### I2C Core Setup Task ###############
  // !      ###################################################
  task i2c_core_setup(
    input logic [7:0] prer_lo_dat,
    input logic [7:0] prer_hi_dat,
    input logic [7:0] ctr_dat
  );
    `uvm_info("I2C CORE SETUP", "##### I2C Core setup is started #####", UVM_LOW)
    // ?       ////////////////////////////////////
    // ?       // Initialize The I2C Master Core //
    // ?       ////////////////////////////////////
    // Setting the Prescale Registers to the desired Value
    wb_write_task(0, `PRER_LO, prer_lo_dat); // * Prescale Lower Bits
    wb_write_task(0, `PRER_HI, prer_hi_dat); // * Prescale Higher Bits
    
    // Enabling the Core
    wb_write_task(0, `CTR    , ctr_dat    ); // * I2C Core & Interrupt Enable

    `uvm_info("I2C CORE SETUP", "##### I2C Core setup is done #####", UVM_LOW)
  endtask

  // !      ###################################################
  // !      ################## I2C Write Task #################
  // !      ###################################################
  task i2c_write(
    input logic [6:0] i2c_slv_addr,
    input logic [7:0] mem_address,
    input logic [7:0] data
  );
    `uvm_info(
      "I2C WRITE TRANSFER STARTED",
      $sformatf(
        "SLV_ADDRESS => %0h :: MEM_ADDRESS => %0h :: WRITE_DATA => %0h",
        i2c_slv_addr,
        mem_address,
        data
      ),
      UVM_LOW
    )

    // ?       /////////////////////////
    // ?       // Drive Slave Address //
    // ?       /////////////////////////
    wb_write_task(0, `TXR, {i2c_slv_addr, `WR});
    wb_write_task(0, `CR, 8'b1001_0000);  // * Start & Write Bits
    tip_poll();

    // ?       //////////////////////////
    // ?       // Slave Memory Address //
    // ?       //////////////////////////
    wb_write_task(0, `TXR, mem_address);
    wb_write_task(0, `CR, 8'b0001_0000);  // * Write Bit
    tip_poll();

    // ?       ///////////////////////////
    // ?       // Writing Data to Slave //
    // ?       ///////////////////////////
    wb_write_task(0, `TXR, data);
    wb_write_task(0, `CR, 8'b0101_0000);  // * Stop & Write Bits
    tip_poll();

    #100000;

    `uvm_info(
      "I2C WRITE TRANSFER   ENDED",
      $sformatf(
        "SLV_ADDRESS => %0h :: MEM_ADDRESS => %0h :: WRITE_DATA => %0h",
        i2c_slv_addr,
        mem_address,
        data
      ),
      UVM_LOW
    )
  endtask
  // !      ###################################################
  // !      ################## I2C Read Task ##################
  // !      ###################################################
  task i2c_read(
    input logic [6:0] i2c_slv_addr,
    input logic [7:0] mem_address
  );
    `uvm_info(
      "I2C READ TRANSFER STARTED",
      $sformatf(
        "SLV_ADDRESS => %0h :: MEM_ADDRESS => %0h",
        i2c_slv_addr,
        mem_address
      ),
      UVM_LOW
    )
    // ?       /////////////////////////////////////
    // ?       // Drive Slave Address & Write Bit //
    // ?       /////////////////////////////////////
    wb_write_task(0, `TXR, {i2c_slv_addr, `WR});
    wb_write_task(0, `CR, 8'b1001_0000);  // * Start & Write Bits
    tip_poll();
    //#5000;

    // ?       //////////////////////////
    // ?       // Slave Memory Address //
    // ?       //////////////////////////
    wb_write_task(0, `TXR, mem_address);
    wb_write_task(0, `CR, 8'b0001_0000);  // * Write Bit
    tip_poll();
   
    // ?       ////////////////////////////////////
    // ?       // Drive Slave Address & Read Bit //
    // ?       ////////////////////////////////////
    wb_write_task(0, `TXR, {i2c_slv_addr, `RD});
    wb_write_task(0, `CR, 8'b1001_0000);  // * Start & Write Bits
    tip_poll();

    // ?       //////////////////
    // ?       // Reading Data //
    // ?       //////////////////
    wb_write_task(0, `CR, 8'b0110_1000);  // * Stop, Read & NACK Bits
    wb_read_task(`RXR, tip_flag);
    tip_poll();

    #100000;

    `uvm_info(
      "I2C READ TRANSFER   ENDED",
      $sformatf(
        "SLV_ADDRESS => %0h :: MEM_ADDRESS => %0h",
        i2c_slv_addr,
        mem_address
      ),
      UVM_LOW
    )
  endtask
endclass