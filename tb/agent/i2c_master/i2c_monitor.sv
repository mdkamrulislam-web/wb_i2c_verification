class i2c_monitor extends uvm_monitor;
  // ! Factory registration of I2C Monitor
  `uvm_component_utils(i2c_monitor)

  `include "../../defines/defines.sv"

  // ! Declaring Handle for I2C Interface
  virtual i2c_interface i2c_intf;

  // ! Monitor Flags
  logic       transfer_start   ;
  logic       transfer_stop    ;
  logic [7:0] slv_addr_wr_rd   ;
  logic       slv_ack_bit      ;
  logic [7:0] mem_addr     ;
  logic       mem_ack_bit  ;
  logic [7:0] transmit_data           ;
  logic       data_ack_bit     ;

  logic       transfer_direction;
  
  logic       slv_addr_ack_flag;
  logic       mem_addr_ack_flag ;
  logic       transmit_data_ack_flag         ;

  logic mem_trigger;
  logic dat_trigger;

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
    if(i2c_intf.TB_SCL == 1'b1) begin
      transfer_start   = 1'b1;
      transfer_stop    = 1'b0;
      
      `uvm_info("START_BIT_DETECT", "##################### START BIT DETECTED #####################", UVM_NONE)
      `uvm_info("FLAGS::START_CON", $sformatf("SCL = %0b :: SDA = %0b :: Start = %0b :: Stop = %0b :: Slv_Ack = %0b :: Mem_Ack = %0b", i2c_intf.TB_SCL, i2c_intf.TB_SDA, transfer_start, transfer_stop, slv_addr_ack_flag, mem_addr_ack_flag), UVM_LOW)
    end
  endtask

  // I2C Stop Condition Checker
  task stop_condition();
    @(posedge i2c_intf.TB_SDA);
    //`uvm_info("BEFORE_STOP_BIT_CON", $sformatf("SCL = %0b :: SDA = %0b :: Start = %0b :: Stop = %0b :: Slv_Ack :: %0b", i2c_intf.TB_SCL, i2c_intf.TB_SDA, transfer_start, transfer_stop, slv_addr_ack_flag), UVM_NONE)
    if((i2c_intf.TB_SCL === 1'b1) && (i2c_intf.TB_SDA === 1'b1)) begin
      transfer_stop      = 1'b1;
      transfer_start     = 1'b0;
      slv_addr_ack_flag  = 1'b0;
      transfer_direction = 1'bX;
     
      `uvm_info("STOP_BIT_DETECT", "##################### STOP BIT DETECTED ######################", UVM_NONE)
      `uvm_info("FLAGS::STOP_CON", $sformatf("SCL = %0b :: SDA = %0b :: Start = %0b :: Stop = %0b :: Slv_Ack = %0b :: Mem_Ack = %0b", i2c_intf.TB_SCL, i2c_intf.TB_SDA, transfer_start, transfer_stop, slv_addr_ack_flag, mem_addr_ack_flag), UVM_LOW)
    end
  endtask

  // Task for Slave Memory Address
  task data_collector();
    @(posedge i2c_intf.TB_SCL);
    if((transfer_start === 1'b1) || (slv_addr_ack_flag === 1'b1)) begin
      // Data Collection
      for(int i = 0; i <= 8; i++) begin
        // 1st 8 Bits
        if(i < 8) begin

          // Slave Address Phase
          if(transfer_start === 1'b1) begin
            slv_addr_wr_rd[($bits(slv_addr_wr_rd) - 1) - i] = i2c_intf.TB_SDA;
            `uvm_info("SLV_ADDR_WR/RD_BITS", $sformatf("Mem Addr Bit[%0d] = %0b", (($bits(slv_addr_wr_rd) - 1) - i), slv_addr_wr_rd[($bits(slv_addr_wr_rd) - 1) - i]), UVM_HIGH)
          end

          // Memory Address Phase
          else if((slv_addr_ack_flag === 1'b1) && (transfer_direction === 1'b1)) begin
            mem_addr[($bits(mem_addr) - 1) - i] = i2c_intf.TB_SDA;
            `uvm_info("MEM_ADDR_BITS", $sformatf("Mem Addr Bit[%0d] = %0b", (($bits(mem_addr) - 1) - i), mem_addr[($bits(mem_addr) - 1) - i]), UVM_HIGH)
          end

          // Data Transmit & Receive Phase
          else if((mem_addr_ack_flag === 1'b1) && (transfer_stop === 0) && (transfer_direction === 1'b1)) begin
            transmit_data[($bits(transmit_data) - 1) - i] = i2c_intf.TB_SDA;
            `uvm_info("TRANSMIT_DATA_BITS", $sformatf("Transmit Data Bit[%0d] = %0b", (($bits(transmit_data) - 1) - i), transmit_data[($bits(transmit_data) - 1) - i]), UVM_HIGH)
          end

          @(posedge i2c_intf.TB_SCL);
        end
        // 9th Bit
        else begin
          // Slave Address Acknowledgement
          if(transfer_start === 1'b1) begin
            slv_ack_bit = i2c_intf.TB_SDA;
            if(slv_ack_bit === 1'b0) begin
              // Transfer Direction Flag Setting
              if(slv_addr_wr_rd[0] === 1'b0) begin
                transfer_direction = 1; // Write
                `uvm_info("TRANS_DIR", "##################### TRANSMITTING DATA ######################", UVM_LOW)
              end
              else if(slv_addr_wr_rd[0] === 1'b1) begin
                transfer_direction = 0; // Read
                `uvm_info("TRANS_DIR", "####################### RECEIVING DATA #######################", UVM_LOW)
              end
              else begin
                `uvm_warning("TRANS_DIR", "################ UNKNOWN TRANSFER DIRECTION ###############")
              end

              `uvm_info("SLAVE_FOUND", $sformatf("%0h :: Slave Found.", slv_addr_wr_rd[7:1]), UVM_LOW)
              slv_addr_ack_flag = 1;
              transfer_start = 0;
              break;
            end
            else begin
              slv_addr_ack_flag = 0;
              `uvm_error("SLAVE_ERROR", $sformatf("There is no such slave as :: %0h", slv_addr_wr_rd[7:1]))
            end
          end
          // Memory Address Acknowledgement
          if((slv_addr_ack_flag === 1'b1) && (transfer_direction === 1'b1)) begin
            mem_ack_bit = i2c_intf.TB_SDA;
            if((mem_ack_bit === 1'b0)) begin
              `uvm_info("MEM_FOUND", $sformatf("%0h :: Memory Found.", mem_addr), UVM_LOW)
              mem_addr_ack_flag = 1;
              slv_addr_ack_flag = 0;
            end
            else begin
              mem_addr_ack_flag = 0;
              `uvm_error("MEM_ERROR", $sformatf("There is no such memory as :: %0h", mem_addr))
            end
          end
          // Transmit Data Acknowledgement
          if((mem_addr_ack_flag === 1'b1) && (transfer_stop === 0) && (transfer_direction === 1'b1)) begin
            data_ack_bit = i2c_intf.TB_SDA;
            if((data_ack_bit === 1'b0)) begin
              `uvm_info("DATA_TRANSMITTED", $sformatf("%0h :: Data Transmission Successful.", transmit_data), UVM_LOW)
              transmit_data_ack_flag = 1;
              slv_addr_ack_flag = 0;
              if(transfer_stop === 1'b1) break;
            end
            else begin
              transmit_data_ack_flag = 0;
              `uvm_error("DATA_ERROR", $sformatf("Data Transmission is Unsuccessful. Attempted to transmit :: %0h", transmit_data))
            end
          end
        end
      end
      
      if((slv_addr_ack_flag === 1'b1)) begin
        `uvm_info("SLV_ACK_DETECT", "##################### SLAVE ACKNOWLEDGED ######################", UVM_NONE);
        `uvm_info("SLVADDR_WR/RD_ACK_BIT_DETECT", $sformatf("Slave Address = %0b :: WR/RD Bit = %0b :: Slave Ack Bit = %0b", slv_addr_wr_rd[7:1], slv_addr_wr_rd[0], slv_ack_bit), UVM_LOW);
        `uvm_info("FLAGS::SLV_ADDR_CON", $sformatf("SCL = %0b :: SDA = %0b :: Start = %0b :: Stop = %0b :: Slv_Ack = %0b :: Mem_Ack = %0b", i2c_intf.TB_SCL, i2c_intf.TB_SDA, transfer_start, transfer_stop, slv_addr_ack_flag, mem_addr_ack_flag), UVM_LOW)
      end
      else if((mem_addr_ack_flag === 1'b1) && (transfer_direction === 1'b1)) begin
        `uvm_info("MEM_ACK_DETECT", "##################### MEMORY ACKNOWLEDGED ######################", UVM_NONE);
        `uvm_info("MEMADDR_WR/RD_ACK_BIT_DETECT", $sformatf("Memory Address = %0b :: Memory Ack Bit = %0b", mem_addr, mem_ack_bit), UVM_LOW);
        `uvm_info("FLAGS::MEM_ADDR_CON", $sformatf("SCL = %0b :: SDA = %0b :: Start = %0b :: Stop = %0b :: Slv_Ack = %0b :: Mem_Ack = %0b", i2c_intf.TB_SCL, i2c_intf.TB_SDA, transfer_start, transfer_stop, slv_addr_ack_flag, mem_addr_ack_flag), UVM_LOW)
      end
      else if((transmit_data_ack_flag === 1'b1) && (transfer_direction === 1'b1) && !transfer_stop) begin
        `uvm_info("MEM_ACK_DETECT", "##################### MEMORY ACKNOWLEDGED ######################", UVM_NONE);
        `uvm_info("MEMADDR_WR/RD_ACK_BIT_DETECT", $sformatf("Memory Address = %0b :: Memory Ack Bit = %0b", mem_addr, mem_ack_bit), UVM_LOW);
        `uvm_info("FLAGS::MEM_ADDR_CON", $sformatf("SCL = %0b :: SDA = %0b :: Start = %0b :: Stop = %0b :: Slv_Ack = %0b :: Mem_Ack = %0b", i2c_intf.TB_SCL, i2c_intf.TB_SDA, transfer_start, transfer_stop, slv_addr_ack_flag, mem_addr_ack_flag), UVM_LOW)
      end
    end
  endtask
  

  // // I2C Start Condition Checker
  // task start_condition();
  //   //@(negedge i2c_intf.TB_SDA && (i2c_intf.TB_SCL == 1));
  //   @(negedge i2c_intf.TB_SDA);
  //   if(i2c_intf.TB_SCL == 1) begin
  //     transfer_start   = 1;
  //     transfer_stop    = 0;
  //     slv_mem_addr_ack = 0;
  //     mem_trigger      = 0;
  //     dat_trigger      = 0;
  //     data_ack         = 0;
  //     slv_addr_wr_rd   = 8'bXX;
  //     slv_mem_addr     = 8'bXX;
  //     t_data           = 8'bXX;
      
  //     `uvm_info("START_BIT", $sformatf("Start Flag = %0b :: Stop Flag = %0b", transfer_start, transfer_stop), UVM_NONE)
  //     `uvm_info("START_FLAG_VALS", $sformatf("Start = %0b :: Stop = %0b :: SLV_ADDR_ACK = %0b :: SLV_MEM_ADDR_ACK = %0b :: DATA_ACK = %0b, MEM_Tri = %0b, DATA_Tri = %0b", transfer_start, transfer_stop, slv_addr_ack, slv_mem_addr_ack, data_ack, mem_trigger, dat_trigger), UVM_NONE)
  //   end
  // endtask

  // // I2C Stop Condition Checker
  // task stop_condition();
  //   @(negedge i2c_intf.TB_SDA);
  //   @(posedge i2c_intf.TB_SDA);
  //   if((i2c_intf.TB_SCL == 1) && (i2c_intf.TB_SDA == 1)) begin
  //     transfer_stop    = 1;
  //     slv_mem_addr_ack = 0;
  //     mem_trigger      = 0;
  //     dat_trigger      = 0;
  //     data_ack         = 0;
  //     slv_addr_wr_rd   = 8'bXX;
  //     slv_mem_addr     = 8'bXX;
  //     t_data           = 8'bXX;
     
  //     `uvm_info("STOP_BIT", $sformatf("Start Flag = %0b :: Stop Flag = %0b", transfer_start, transfer_stop), UVM_NONE)
  //     `uvm_info("STOP_FLAG_VALS", $sformatf("Start = %0b :: Stop = %0b :: SLV_ADDR_ACK = %0b :: SLV_MEM_ADDR_ACK = %0b :: DATA_ACK = %0b, MEM_Tri = %0b, DATA_Tri = %0b", transfer_start, transfer_stop, slv_addr_ack, slv_mem_addr_ack, data_ack, mem_trigger, dat_trigger), UVM_NONE)
  //   end
  // endtask

  // // Task for Slave Address
  // task slave_address();
  //   @(posedge i2c_intf.TB_SCL);
  //   `uvm_info("SLV_ADDR_FLAG_VALS_BEFOR_CON", $sformatf("Start = %0b :: Stop = %0b :: SLV_ADDR_ACK = %0b :: SLV_MEM_ADDR_ACK = %0b :: DATA_ACK = %0b, MEM_Tri = %0b, DATA_Tri = %0b", transfer_start, transfer_stop, slv_addr_ack, slv_mem_addr_ack, data_ack, mem_trigger, dat_trigger), UVM_HIGH)
  //   if(transfer_start) begin
  //     transfer_start = 0;
  //     for(int i = 7; i >= 1; i--) begin
  //       slv_addr_wr_rd[i] = i2c_intf.TB_SDA;
  //       `uvm_info("SLAVE_ADDRESS_BITS", $sformatf("Slave Address Bits[%0d] = %0b", i, slv_addr_wr_rd), UVM_HIGH)
  //       @(posedge i2c_intf.TB_SCL);
  //     end
  //     `uvm_info("SLAVE_ADDRESS", $sformatf("Slave Address = %0b", slv_addr_wr_rd[7:1]), UVM_NONE)

  //     slv_addr_wr_rd[0] = i2c_intf.TB_SDA;
  //     `uvm_info("SLAVE_WR_RD_BIT", $sformatf("Slave W/R Bit = %0b", slv_addr_wr_rd[0]), UVM_NONE)

  //     @(posedge i2c_intf.TB_SCL);
  //     slv_ack_bit = i2c_intf.TB_SDA;
  //     if((slv_ack_bit == 0) && (i2c_intf.SDA_PADOEN_O == 1)) begin
  //       `uvm_info("SLAVE_ACK_BIT", $sformatf("Slave Ack Bit = %0b", slv_ack_bit), UVM_NONE)
  //       slv_addr_ack = 1;
  //     end
  //     `uvm_info("SLV_ADDR_FLAG_VALS", $sformatf("Start = %0b :: Stop = %0b :: SLV_ADDR_ACK = %0b :: SLV_MEM_ADDR_ACK = %0b :: DATA_ACK = %0b, MEM_Tri = %0b, DATA_Tri = %0b", transfer_start, transfer_stop, slv_addr_ack, slv_mem_addr_ack, data_ack, mem_trigger, dat_trigger), UVM_NONE)
  //   end
  // endtask

  // // Task for Slave Memory Address
  // task memory_address();
  //   @(posedge i2c_intf.TB_SCL);
  //   `uvm_info("MEM_ADDR_FLAG_VALS_BEFORE_CON", $sformatf("Start = %0b :: Stop = %0b :: SLV_ADDR_ACK = %0b :: SLV_MEM_ADDR_ACK = %0b :: DATA_ACK = %0b, MEM_Tri = %0b, DATA_Tri = %0b", transfer_start, transfer_stop, slv_addr_ack, slv_mem_addr_ack, data_ack, mem_trigger, dat_trigger), UVM_HIGH)
  //   if(slv_addr_ack == 1'b1) begin
      
  //     slv_addr_ack = 0;
  //     for(int i = 0; i <= 7; i++) begin
  //       slv_mem_addr[($bits(slv_mem_addr) - 1) - i] = i2c_intf.TB_SDA;
  //       `uvm_info("MEMORY_ADDR_BITS", $sformatf("Mem Addr Bit[%0d] = %0b", (($bits(slv_mem_addr) - 1) - i), slv_mem_addr[($bits(slv_mem_addr) - 1) - i]), UVM_HIGH)
  //       @(posedge i2c_intf.TB_SCL);
  //     end
  //     `uvm_info("MEM_ADDR_FLAG_VALS_AFTER_CON", $sformatf("Start = %0b :: Stop = %0b :: SLV_ADDR_ACK = %0b :: SLV_MEM_ADDR_ACK = %0b :: DATA_ACK = %0b, MEM_Tri = %0b, DATA_Tri = %0b", transfer_start, transfer_stop, slv_addr_ack, slv_mem_addr_ack, data_ack, mem_trigger, dat_trigger), UVM_HIGH)
  //     `uvm_info("MEMORY_ADDRESS", $sformatf("Memory Address = %0b", slv_mem_addr), UVM_NONE)
      
      
  //     slv_mem_ack_bit = i2c_intf.TB_SDA;
  //     if((slv_mem_ack_bit == 0) && (i2c_intf.SDA_PADOEN_O == 1)) begin
  //       `uvm_info("MEM_ACK_BIT", $sformatf("Slave Mem Ack Bit = %0b", slv_mem_ack_bit), UVM_NONE)
  //       slv_mem_addr_ack = 1;
  //     end
      
  //     mem_trigger = 1;
  //     `uvm_info("MEM_ADDR_FLAG_VALS", $sformatf("Start = %0b :: Stop = %0b :: SLV_ADDR_ACK = %0b :: SLV_MEM_ADDR_ACK = %0b :: DATA_ACK = %0b, MEM_Tri = %0b, DATA_Tri = %0b", transfer_start, transfer_stop, slv_addr_ack, slv_mem_addr_ack, data_ack, mem_trigger, dat_trigger), UVM_NONE)
  //   end
  // endtask

  // // Task for Data Transmission
  // task transmit_data();
  //   if(transfer_start) begin
  //     dat_trigger = 0;
  //     mem_trigger = 0;
  //   end
  //   @(posedge i2c_intf.TB_SCL);

  //   //@(negedge i2c_intf.TB_SDA && (i2c_intf.TB_SCL == 1)) mem_trigger = 0;
  //   `uvm_info("TRANS_DATA_FLAG_VALS_BEFORE_CON", $sformatf("Start = %0b :: Stop = %0b :: SLV_ADDR_ACK = %0b :: SLV_MEM_ADDR_ACK = %0b :: DATA_ACK = %0b, MEM_Tri = %0b, DATA_Tri = %0b", transfer_start, transfer_stop, slv_addr_ack, slv_mem_addr_ack, data_ack, mem_trigger, dat_trigger), UVM_HIGH)
  //   if((mem_trigger && slv_mem_addr_ack) || dat_trigger) begin
  //     slv_mem_addr_ack = 0;
  //     //mem_trigger      = 0;
  //     for(int i = 0; i <= 7; i++)begin
  //       t_data[($bits(t_data) - 1) - i] = i2c_intf.TB_SDA;
  //       `uvm_info("TRANSMIT_DATA_BITS", $sformatf("Transmit Data Bit[%0d] = %0b", (($bits(t_data) - 1) - i), t_data[($bits(t_data) - 1) - i]), UVM_HIGH)
  //       @(posedge i2c_intf.TB_SCL);
  //     end
  //     `uvm_info("TRANS_DATA_FLAG_VALS_AFTER_CON", $sformatf("Start = %0b :: Stop = %0b :: SLV_ADDR_ACK = %0b :: SLV_MEM_ADDR_ACK = %0b :: DATA_ACK = %0b, MEM_Tri = %0b, DATA_Tri = %0b", transfer_start, transfer_stop, slv_addr_ack, slv_mem_addr_ack, data_ack, mem_trigger, dat_trigger), UVM_HIGH)
  //     `uvm_info("TRANSMIT DATA", $sformatf("Transmit Data = %0b", t_data), UVM_NONE)
       
      
  //     data_ack_bit = i2c_intf.TB_SDA;
  //     `uvm_info("TRANSMIT_DATA_ACK_BIT", $sformatf("Transmit Data Ack Bit = %0b", data_ack_bit), UVM_NONE)
  //     if(data_ack_bit == 0) begin
  //       data_ack = 1;
  //     end
  //     dat_trigger = 1;
  //     //@(posedge i2c_intf.TB_SDA && (i2c_intf.TB_SCL == 1)) dat_trigger = 0;
  //     `uvm_info("TRANS_DATA_FLAG_VALS", $sformatf("Start = %0b :: Stop = %0b :: SLV_ADDR_ACK = %0b :: SLV_MEM_ADDR_ACK = %0b :: DATA_ACK = %0b, MEM_Tri = %0b, DATA_Tri = %0b", transfer_start, transfer_stop, slv_addr_ack, slv_mem_addr_ack, data_ack, mem_trigger, dat_trigger), UVM_NONE)
  //   end
  // endtask

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