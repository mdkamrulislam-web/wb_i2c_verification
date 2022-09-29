class wb_i2c_base_test extends uvm_test;
  `uvm_component_utils(wb_i2c_base_test)

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
    `uvm_info(get_full_name(), "Inside WB_I2C Base Test Constructor", UVM_NONE)
  endfunction: new

  // ! WB_I2C Base Test Build Phase
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_full_name(), "Inside WB_I2C Base Test Build Phase", UVM_NONE)

    // Creating Environment, Environment Config Instances
    wb_i2c_env     = wb_i2c_environment::type_id::create("wb_i2c_env"    , this);
    wb_i2c_env_con = wb_i2c_env_config ::type_id::create("wb_i2c_env_con", this);
    wb_agt_con     = wb_agent_config   ::type_id::create("wb_agt_con"    , this);

    // Setting parameters of WB_I2C Environment Configuration
    wb_i2c_env_con.has_scoreboard      = 1          ;
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
    `uvm_info(get_full_name(), "Inside WB_I2C Base Test Connect Phase", UVM_NONE)
  endfunction

  // ! WB_I2C Base Test Run Phase
  virtual task run_phase(uvm_phase phase);
    `uvm_info(get_full_name(), "Inside WB_I2C Base Test Run Phase", UVM_NONE)
  endtask
  
  // ! WB Reset Task
  task wb_reset_task();
    // Creating WB Reset Sequence Instance
    wb_rstn_sq = wb_rst_seq::type_id::create("wb_rstn_sq");

    // Starting WB Reset Sequence through Sequencer
    wb_rstn_sq.start(wb_i2c_env.wb_agt.wb_sqr);
  endtask

  // ! WB Write Task
  task wb_write_task(bit randomization, bit [2:0] addr, bit [7:0] data);
    // Creating WB Write Sequence Instance
    wb_wr_sq = wb_wr_seq::type_id::create("wb_wr_sq");

    wb_wr_sq.wb_address    = addr;
    wb_wr_sq.wb_dataIn     = data;
    wb_wr_sq.randomization = randomization;

    // Starting WB Write Sequence through Sequencer
    wb_wr_sq.start(wb_i2c_env.wb_agt.wb_sqr);
  endtask

  // ! WB Read Task
  task wb_read_task(bit [2:0] addr);
    // Creating WB Read Sequence Instance
    wb_rd_sq = wb_rd_seq::type_id::create("wb_rd_sq");

    wb_rd_sq.wb_address    = addr;

    // Starting WB Read Sequence through Sequencer
    wb_rd_sq.start(wb_i2c_env.wb_agt.wb_sqr);
  endtask
endclass