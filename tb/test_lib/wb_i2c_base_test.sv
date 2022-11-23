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

  /*#########################
  ### Wishbone Reset Task ###
  #########################*/
  task wb_reset_task();
    // Creating WB Reset Sequence Instance
    wb_rstn_sq = wb_rst_seq::type_id::create("wb_rstn_sq");

    // Starting WB Reset Sequence through Sequencer
    wb_rstn_sq.start(wb_i2c_env.wb_agt.wb_sqr);
  endtask

  /*#########################
  ### Wishbone Write Task ###
  #########################*/
  task wb_write_task(bit randomization, bit [2:0] addr, bit [7:0] data);
    // Creating WB Write Sequence Instance
    wb_wr_sq = wb_wr_seq::type_id::create("wb_wr_sq");

    wb_wr_sq.wb_address    = addr;
    wb_wr_sq.wb_dataIn     = data;
    wb_wr_sq.randomization = randomization;

    // Starting WB Write Sequence through Sequencer
    wb_wr_sq.start(wb_i2c_env.wb_agt.wb_sqr);
  endtask

  /*########################
  ### Wishbone Read Task ###
  ########################*/
  task wb_read_task(bit [2:0] addr, output bit tip_flag);
    // Creating WB Read Sequence Instance
    wb_rd_sq = wb_rd_seq::type_id::create("wb_rd_sq");
    wb_rd_sq.wb_address = addr;

    // Starting WB Read Sequence through Sequencer
    wb_rd_sq.start(wb_i2c_env.wb_agt.wb_sqr);
    tip_flag     = wb_rd_sq.dvr_rsp.t_flag  ;

    //`uvm_info("READ_SEQ ===> TEST", $sformatf("TIP :: %0d", tip_flag), UVM_NONE)
  endtask
  
  /*#####################################
  ### WB Status Register Polling Task ###
  #####################################*/
  task tip_poll();
    wb_read_task(`SR, tip_flag);
    //`uvm_info("TIP_FLAG_CHECKER", $sformatf("TIP :: %0d", tip_flag), UVM_NONE)
    while (tip_flag) begin
      wb_read_task(`SR, tip_flag);
      //`uvm_info("TIP_FLAG_CHECKER", $sformatf("TIP :: %0d", tip_flag), UVM_NONE)
    end
  endtask

  /*#########################
  ### I2C Core Setup Task ###
  #########################*/
  task i2c_core_setup(
    input logic [7:0] prer_lo_dat,
    input logic [7:0] prer_hi_dat,
    input logic [7:0] ctr_dat
  );
    // Setting the Prescale Registers to the desired Value
    wb_write_task(0, `PRER_LO, prer_lo_dat); // * Prescale Lower Bits
    wb_write_task(0, `PRER_HI, prer_hi_dat); // * Prescale Higher Bits
    
    // Enabling the Core
    wb_write_task(0, `CTR    , ctr_dat    ); // * I2C Core & Interrupt Enable

    `uvm_info("I2C CORE SETUP", "I2C CORE SETUP IS DONE", UVM_LOW)
  endtask

  /*##############################################################################
  ### I2C Start Condition Generation & Slave Address & WR/RD Bit Transfer Task ###
  ##############################################################################*/
  task i2c_slv_addr_trans(input logic [6:0] i2c_slv_addr, input bit wr_rd);
    `uvm_info("Transmitting Slave Address", $sformatf("SLV_ADDRESS => %0h", i2c_slv_addr), UVM_LOW)

    wb_write_task(0, `TXR, {i2c_slv_addr, wr_rd});
    wb_write_task(0, `CR, 8'b1001_0000);  // Start & Write Bits HIGH
    tip_poll();
  endtask

  /*######################################
  ### I2C Memory Address Transfer Task ###
  ######################################*/
  task i2c_mem_addr_trans(input logic [7:0] mem_address);
    `uvm_info("Transmitting Memory Address", $sformatf("MEM_ADDRESS => %0h", mem_address), UVM_LOW)

    wb_write_task(0, `TXR, mem_address);
    wb_write_task(0, `CR, 8'b0001_0000);  // Write Bit HIGH
    tip_poll();
  endtask

  /*##################################################################
  ### I2C Repeated Start Condition Generation & Data Transfer Task ###
  ##################################################################*/
  task rep_start_wr(logic [7:0] data);
    wb_write_task(0, `TXR, data);
    wb_write_task(0, `CR, 8'b0001_0000);  // * Write Bit HIGH
    tip_poll();
  endtask

  /*########################################################
  ### I2C Stop Condition Generation & Data Transfer Task ###
  ########################################################*/
  task stop_wr(logic [7:0] data);
    wb_write_task(0, `TXR, data);
    wb_write_task(0, `CR, 8'b0101_0000);  // * Stop & Write Bits HIGH
    tip_poll();
  endtask

  /*################################################################
  ### I2C Data Transfer Task Depending On Different Data Lengths ###
  ################################################################*/  
  task i2c_data_trans(input logic [31:0] data, input logic [1:0] byte_no);
    `uvm_info("Transmitting Data", $sformatf("Data => %0h", data), UVM_LOW)
    if(byte_no == 2'b00) begin
      stop_wr(data[31:24]);
    end
    else if(byte_no ==  2'b01) begin
      rep_start_wr(data[31:24]);

      stop_wr(data[23:16]);
    end 
    else if(byte_no ==  2'b10) begin
      rep_start_wr(data[31:24]);
      rep_start_wr(data[23:16]);

      stop_wr(data[15:8]);
    end
    else if(byte_no ==  2'b11) begin
      rep_start_wr(data[31:24]);
      rep_start_wr(data[23:16]);
      rep_start_wr(data[15:8]);

      stop_wr(data[7:0]);
    end 
  endtask

  /*####################
  ### I2C Write Task ###
  ####################*/
  task i2c_write(
    input logic [6:0]  i2c_slv_addr,
    input logic [7:0]  mem_address ,
    input logic [31:0] data        ,
    input logic [1:0]  byte_no
  );

    i2c_slv_addr_trans(i2c_slv_addr, `WR);
    i2c_mem_addr_trans(mem_address);
    i2c_data_trans(data, byte_no);
  endtask

  /*#################################################################
  ### I2C Repeated Start Condition Generation & Data Receive Task ###
  #################################################################*/
  task rep_read_ack();
    wb_write_task(0, `CR, 8'b0010_0000);  // * Read HIGH & ACK Bit LOW
    wb_read_task(`RXR, tip_flag);
    tip_poll();
  endtask

  /*##############################################################
  ### I2C NACK & Stop Condition Generation & Data Receive Task ###
  ##############################################################*/
  task read_nack_stop();
    wb_write_task(0, `CR, 8'b0110_1000);  // * Stop HIGH, Read HIGH & ACK Bit HIGH
    wb_read_task(`RXR, tip_flag);
    tip_poll();
  endtask

  /*###############################################################
  ### I2C Data Receive Task Depending On Different Data Lengths ###
  ###############################################################*/
  task i2c_data_recv(input logic [1:0] byte_no);
    //`uvm_info("Receiving Data", $sformatf("Data => %0h", data), UVM_LOW)
    if(byte_no == 2'b00) begin
      read_nack_stop();
    end
    else if(byte_no ==  2'b01) begin
      rep_read_ack();

      read_nack_stop();
    end 
    else if(byte_no ==  2'b10) begin
      rep_read_ack();
      rep_read_ack();

      read_nack_stop();
    end
    else if(byte_no ==  2'b11) begin
      rep_read_ack();
      rep_read_ack();
      rep_read_ack();

      read_nack_stop();
    end 
  endtask

  /*###################
  ### I2C Read Task ###
  ###################*/
  task i2c_read(
    input logic [6:0]  i2c_slv_addr,
    input logic [7:0]  mem_address ,
    input logic [1:0]  byte_no  
  );

  i2c_slv_addr_trans(i2c_slv_addr, `WR);
  i2c_mem_addr_trans(mem_address);
  i2c_slv_addr_trans(i2c_slv_addr, `RD);
  i2c_data_recv(byte_no);

  endtask
endclass