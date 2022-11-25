class wb_i2c_environment extends uvm_env;
  // ! Factory registration of WB_I2C Environment
  `uvm_component_utils(wb_i2c_environment)

  // ! Declaring the handle of WB_I2C Scoreboard, WB Agent, Environment Config, Wishbone I2C Predictor.
  wb_i2c_scoreboard wb_i2c_sb;
  wb_agent wb_agt;
  wb_i2c_env_config wb_i2c_env_con;
  wb_i2c_predictor wb_i2c_prdctr;

  // ! WB_I2C Environment Constructor
  function new(string name = "wb_i2c_environment", uvm_component parent = null);
    super.new(name, parent);
    `uvm_info(get_full_name(), "Inside WB_I2C Environment Constructor.", UVM_MEDIUM)
  endfunction

  // ! WB_I2C Environment Build Phase
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_full_name(), "Inside WB_I2C Environment Build Phase.", UVM_MEDIUM)

    // Getting APB_ENV_CON from UVM Configuration Database which was set from APB_BASE_TEST to Configure APB_Environment.
    if(!uvm_config_db#(wb_i2c_env_config)::get(this, "", "wb_i2c_env_config", wb_i2c_env_con)) begin
      `uvm_fatal("WB_I2C Environment Configuration", {"Environment Configuration must be set for: ",get_full_name(),".env_con"})
    end
    else begin
      // Creating WB_I2C Scoreboard Instance.
      if (wb_i2c_env_con.has_scoreboard) begin
        wb_i2c_prdctr = wb_i2c_predictor::type_id::create("wb_i2c_prdctr", this);
        wb_i2c_sb = wb_i2c_scoreboard::type_id::create("wb_i2c_sb", this);
      end
    end

    wb_agt = wb_agent::type_id::create("wb_agt", this);
    
    // Setting WB_AGENT_CON in UVM Configuration Database to get it from WB Agent.
    uvm_config_db#(wb_agent_config)::set(this, "wb_agt", "wb_agent_config", wb_i2c_env_con.wb_agt_con);
		
  endfunction

  // ! WB_I2C Environment Connect Phase
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info(get_full_name(), "Inside WB_I2C Environment Connect Phase.", UVM_MEDIUM)

		// Connecting Driver & Monitor with Scoreboard, depending on the parameters of Enviornment Configuration & Agent Configuration
    if(wb_i2c_env_con.has_scoreboard) begin
      wb_agt.wb_mtr.wb_wr_exp_mtr2pdctr_port.connect(wb_i2c_prdctr.wb_wr_mtr2pdctr);
    end
    else begin
			`uvm_info("WB_ENV_CONFIG", "THIS TESTBENCH DOES NOT HAVE A SCOREBOARD.", UVM_LOW)
		end
  endfunction

  // ! WB_I2C Environment Run Phase
  task run_phase(uvm_phase phase);
    `uvm_info(get_full_name(), "Inside WB_I2C Environment Run Phase.", UVM_MEDIUM)
  endtask

endclass