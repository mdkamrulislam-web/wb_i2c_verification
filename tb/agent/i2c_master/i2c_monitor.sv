class i2c_monitor extends uvm_monitor;
  // ! Factory registration of I2C Monitor
  `uvm_component_utils(i2c_monitor)

  `include "../../defines/defines.sv"

  // Declaring Handle for I2C Agent Config
  i2c_agent_config i2c_agt_con;

  // ! Declaring Handle for I2C Interface
  virtual i2c_interface i2c_intf;

  // ! Monitor Flags
  logic [7:0] slv_addr_wr_rd        ;
  logic [7:0] mem_addr              ;
  logic [7:0] transmit_data         ;

  logic       slv_ack_bit           ;
  logic       mem_ack_bit           ;
  logic       transmit_data_ack_bit ;

  bit         transfer_start        ;
  bit         transfer_stop         ;
  bit         transfer_direction    ;
  bit         slv_addr_ack_flag     ;
  bit         mem_addr_ack_flag     ;
  bit         transmit_data_ack_flag;

  int         transfer_byte_no      ;

  // ! I2C Monitor Constructor
  function new(string name = "i2c_monitor", uvm_component parent = null);
    super.new(name, parent);
    `uvm_info(get_full_name(), "Inside I2C Monitor Constructor.", UVM_HIGH)
  endfunction

  // ! I2C Monitor Build Phase
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_full_name(), "Inside I2C Monitor Build Phase.", UVM_HIGH)

    if(!uvm_config_db#(virtual i2c_interface)::get(this, "", "i2c_vintf", i2c_intf)) begin
      `uvm_fatal("I2C Virtual Interface Not Found Inside Monitor!", {"Virtual interface must be set for: ",get_full_name(),".i2c_vintf"})
    end
    else begin
      `uvm_info("I2C_INTF", "I2C Virtual Interface found inside monitor.", UVM_HIGH)
    end
  endfunction

  // ! I2C Monitor Connect Phase
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info(get_full_name(), "Inside I2C Monitor Connect Phase.", UVM_HIGH)
  endfunction

  // I2C Start Condition Checker
  task start_condition();
    @(negedge i2c_intf.TB_SDA && (i2c_intf.TB_SCL === 1));
    if(i2c_intf.TB_SCL === 1'b1) begin
      transfer_start         = 1'b1;
      transfer_stop          = 1'b0;
      mem_addr_ack_flag      = 1'b0;
      transmit_data_ack_flag = 1'b0;
      transfer_direction     = 1'b0;
      
      `uvm_info("START_BIT_DETECT", "##################### START BIT DETECTED #####################", UVM_NONE)
      `uvm_info("FLAGS::START_CON", $sformatf("scl = %0b :: sda = %0b :: start = %0b :: stop = %0b :: slv_ak_flg = %0b :: mem_ak_flg = %0b :: t_data_ak_flg :: %0b", i2c_intf.TB_SCL, i2c_intf.TB_SDA, transfer_start, transfer_stop, slv_addr_ack_flag, mem_addr_ack_flag, transmit_data_ack_flag), UVM_LOW)
    end
  endtask

  // I2C Stop Condition Checker
  task stop_condition();
    @(posedge i2c_intf.TB_SDA);
    if((i2c_intf.TB_SCL === 1'b1) && (i2c_intf.TB_SDA === 1'b1)) begin
      transfer_stop          = 1'b1;
      transfer_start         = 1'b0;
      slv_addr_ack_flag      = 1'b0;
      mem_addr_ack_flag      = 1'b0;
      transfer_direction     = 1'b0;
      transmit_data_ack_flag = 1'b0;
     
      `uvm_info("STOP_BIT_DETECT", "##################### STOP BIT DETECTED ######################", UVM_NONE)
      `uvm_info("FLAGS::STOP_CON", $sformatf("scl = %0b :: sda = %0b :: start = %0b :: stop = %0b :: slv_ak_flg = %0b :: mem_ak_flg = %0b :: t_data_ak_flg :: %0b", i2c_intf.TB_SCL, i2c_intf.TB_SDA, transfer_start, transfer_stop, slv_addr_ack_flag, mem_addr_ack_flag, transmit_data_ack_flag), UVM_LOW)
    end
  endtask

  // Collector Task
  task data_collector();
    @(posedge i2c_intf.TB_SCL);
    if((transfer_start === 1'b1) || (slv_addr_ack_flag === 1'b1) || (mem_addr_ack_flag === 1'b1)) begin
      ////////////// Data Collection //////////////
      for(int i = 0; i <= 8; i++) begin
        ////////////// 1st 8 Bits //////////////
        if(i < 8) begin
          //`uvm_info("I_VAL", $sformatf("Value of i = %0d", i), UVM_NONE)

          ////////////// Slave Address Phase //////////////
          if((transfer_start === 1'b1)) begin
            slv_addr_wr_rd[($bits(slv_addr_wr_rd) - 1) - i] = i2c_intf.TB_SDA;
            `uvm_info("SLV_ADDR_WR/RD_BITS", $sformatf("Slv Addr Bit[%0d] = %0b", (($bits(slv_addr_wr_rd) - 1) - i), slv_addr_wr_rd[($bits(slv_addr_wr_rd) - 1) - i]), UVM_HIGH)
          end

          ////////////// Memory Address Phase //////////////
          else if((slv_addr_ack_flag === 1'b1) && (transfer_direction === 1'b1)) begin
            mem_addr[($bits(mem_addr) - 1) - i] = i2c_intf.TB_SDA;
            `uvm_info("MEM_ADDR_BITS", $sformatf("Mem Addr Bit[%0d] = %0b", (($bits(mem_addr) - 1) - i), mem_addr[($bits(mem_addr) - 1) - i]), UVM_HIGH)
          end
          
          ////////////// Data Transmit Phase //////////////
          else if((mem_addr_ack_flag === 1'b1) && (transfer_direction === 1'b1)) begin
            transmit_data[($bits(transmit_data) - 1) - i] = i2c_intf.TB_SDA;
            `uvm_info("TRANS_DATA_BITS", $sformatf("Trans Data Bit[%0d] = %0b", (($bits(transmit_data) - 1) - i), transmit_data[($bits(transmit_data) - 1) - i]), UVM_HIGH)
          end

          @(posedge i2c_intf.TB_SCL);
        end

        ////////////// 9th Bit //////////////
        else begin

          ////////////// Transfer Direction Flag Setting //////////////
          if((transfer_start === 1'b1)) begin
            if(slv_addr_wr_rd[0] === 1'b0) begin
              transfer_direction = 1; // Write
              `uvm_info("TRANS_DIR", "##################### DATA WILL BE TRANSMITTED TO THE SLAVE ######################", UVM_LOW)
            end
            else if(slv_addr_wr_rd[0] === 1'b1) begin
              transfer_direction = 0; // Read
              `uvm_info("TRANS_DIR", "####################### DATA WILL BE RECEIVED BY THE SLAVE #######################", UVM_LOW)
            end
            else begin
              `uvm_warning("TRANS_DIR", "################ UNKNOWN TRANSFER DIRECTION ###############")
            end
          end
        
          ////////////// Slave Address Acknowledgement //////////////
          if(transfer_start === 1'b1) begin
            slv_ack_bit = i2c_intf.TB_SDA;
            if(slv_ack_bit === 1'b0) begin
              `uvm_info("SLVADDR_WR/RD_ACK_BIT_DETECT", $sformatf("Slave Address = %0h :: WR/RD Bit = %0b :: Slave Ack Bit = %0b", slv_addr_wr_rd[7:1], slv_addr_wr_rd[0], slv_ack_bit), UVM_LOW);

              slv_addr_ack_flag = 1;
              transfer_start = 0;
              `uvm_info("FLAGS::SLV_ADDR_CON", $sformatf("scl = %0b :: sda = %0b :: start = %0b :: stop = %0b :: slv_ak_flg = %0b :: mem_ak_flg = %0b :: t_data_ak_flg :: %0b", i2c_intf.TB_SCL, i2c_intf.TB_SDA, transfer_start, transfer_stop, slv_addr_ack_flag, mem_addr_ack_flag, transmit_data_ack_flag), UVM_LOW);

              break;
            end
            else begin
              slv_addr_ack_flag = 0;
              `uvm_error("SLAVE_ERROR", $sformatf("There is no such slave as :: %0h", slv_addr_wr_rd[7:1]))
            end
          end

          ////////////// Memory Address Acknowledgement //////////////
          else if((slv_addr_ack_flag === 1'b1) && (transfer_direction === 1'b1)) begin
            mem_ack_bit = i2c_intf.TB_SDA;
            if((mem_ack_bit === 1'b0)) begin
              `uvm_info("MEM_ACK_DETECT", "##################### MEMORY ACKNOWLEDGED ######################", UVM_NONE);
              `uvm_info("MEMADDR_WR/RD_ACK_BIT_DETECT", $sformatf("Memory Address = %0h :: Memory Ack Bit = %0b", mem_addr, mem_ack_bit), UVM_LOW);
              mem_addr_ack_flag = 1;
              slv_addr_ack_flag = 0;
              `uvm_info("FLAGS::MEM_ADDR_CON", $sformatf("scl = %0b :: sda = %0b :: start = %0b :: stop = %0b :: slv_ak_flg = %0b :: mem_ak_flg = %0b :: t_data_ak_flg :: %0b", i2c_intf.TB_SCL, i2c_intf.TB_SDA, transfer_start, transfer_stop, slv_addr_ack_flag, mem_addr_ack_flag, transmit_data_ack_flag), UVM_LOW)
              break;
            end
            else begin
              mem_addr_ack_flag = 0;
              `uvm_error("MEM_ERROR", $sformatf("There is no such memory as :: %0h", mem_addr))
            end
          end

          ////////////// Transmit Data Acknowledgement //////////////
          else if((mem_addr_ack_flag === 1'b1) && (transfer_direction === 1'b1)) begin
            transmit_data_ack_bit = i2c_intf.TB_SDA;
            if(transmit_data_ack_bit === 1'b0) begin
              `uvm_info("TRANS_DATA_ACK_DETECT", "##################### DATA TRANSMISSION ACKNOWLEDGED ######################", UVM_NONE);
              `uvm_info("TRANSMIT_DATA_ACK_BIT_DETECT", $sformatf("Transmit Data = %0h :: Transmit Data Ack Bit = %0b", transmit_data, transmit_data_ack_bit), UVM_LOW);
              transmit_data_ack_flag = 1'b1;
              if(transfer_stop) mem_addr_ack_flag = 1'b0;
              `uvm_info("FLAGS::TRANS_DATA_CON", $sformatf("scl = %0b :: sda = %0b :: start = %0b :: stop = %0b :: slv_ak_flg = %0b :: mem_ak_flg = %0b :: t_data_ak_flg :: %0b", i2c_intf.TB_SCL, i2c_intf.TB_SDA, transfer_start, transfer_stop, slv_addr_ack_flag, mem_addr_ack_flag, transmit_data_ack_flag), UVM_LOW)
            end
            else begin
              transmit_data_ack_flag = 1'b0;
              `uvm_error("TRANS_DATA_ERROR", $sformatf("Data transmission failed. Approched to transmit :: %0h", transmit_data))
            end
          end
        end
      end
    end
  endtask

  // ! I2C Monitor Run Phase
  task run_phase(uvm_phase phase);
    `uvm_info(get_full_name(), "Inside I2C Monitor Run Phase.", UVM_LOW)
    repeat(2) @(negedge i2c_intf.CLK_I);
    fork
      forever begin
        start_condition();
      end
      forever begin
        stop_condition();
      end
      forever begin
        data_collector();
      end
    join
  endtask
endclass
