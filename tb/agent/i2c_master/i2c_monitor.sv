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
  logic [7:0] slv_mem_addr     ;
  logic       slv_mem_ack_bit  ;
  logic [7:0] write_data       ;
  logic       data_ack_bit     ;
  
  logic       slv_addr_ack     ;
  logic       slv_mem_addr_ack ;
  logic       data_ack         ;

  // ! I2C Monitor Constructor
  function new(string name = "i2c_monitor", uvm_component parent = null);
    super.new(name, parent);
    `uvm_info(get_full_name(), "Inside I2C Monitor Constructor.", UVM_LOW)
  endfunction

  // ! I2C Monitor Build Phase
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_full_name(), "Inside I2C Monitor Build Phase.", UVM_LOW)

    if(!uvm_config_db#(virtual i2c_interface)::get(this, "", "i2c_vintf", i2c_intf)) begin
      `uvm_fatal("I2C Virtual Interface Not Found Inside Monitor!", {"Virtual interface must be set for: ",get_full_name(),".i2c_vintf"})
    end
    else begin
      `uvm_info("I2C_INTF", "I2C Virtual Interface found inside monitor.", UVM_LOW)
    end
  endfunction

  // ! I2C Monitor Connect Phase
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info(get_full_name(), "Inside I2C Monitor Connect Phase.", UVM_LOW)
  endfunction

  // I2C Start Condition Checker
  task start_condition();
    forever begin
      @(negedge i2c_intf.SDA_PAD_I);
      if(i2c_intf.SCL_PAD_I==1 && i2c_intf.SDA_PAD_I==0) begin
        transfer_start = 1;
        transfer_stop  = 0;
        `uvm_info("TRANSFER_START_STOP_FLAG_CHECKER", $sformatf("Transfer Start Flag Val = %0b :: Transfer Stop Flag Val = %0b", transfer_start, transfer_stop), UVM_NONE)
      end
      //`uvm_info("I2C MONITOR CHECKER", $sformatf("SCL = %0b, SDA = %0b", i2c_intf.SCL_PAD_I, i2c_intf.SDA_PAD_I), UVM_NONE)
    end
  endtask

  // I2C Stop Condition Checker
  task stop_condition();
    forever begin
      @(posedge i2c_intf.SDA_PAD_I);
      if(i2c_intf.SCL_PAD_I==1 && i2c_intf.SDA_PAD_I==1 && !transfer_start) begin
        transfer_stop = 1;
        transfer_start = 0;
        data_ack = 0;
        `uvm_info("TRANSFER_START_STOP_FLAG_CHECKER", $sformatf("Transfer Start Flag Val = %0b :: Transfer Stop Flag Val = %0b", transfer_start, transfer_stop), UVM_NONE)
      end
    end
  endtask

  task slave_address();
    forever begin
      @(posedge i2c_intf.SCL_PAD_I);
      if(transfer_start) begin
        transfer_start = 0;
        for(int i = 7; i >= 1; i--) begin
          slv_addr_wr_rd[i] = i2c_intf.SDA_PAD_I;
          `uvm_info("I2C_SLAVE_ADDRESS", $sformatf("Slave Address Bits = %0b", slv_addr_wr_rd), UVM_MEDIUM)
          @(posedge i2c_intf.SCL_PAD_I);
        end
        `uvm_info("I2C_SLAVE_ADDRESS_BITS", $sformatf("Slave Address = %0b", slv_addr_wr_rd[7:1]), UVM_NONE)

        slv_addr_wr_rd[0] = i2c_intf.SDA_PAD_I;
        `uvm_info("I2C_WR_RD_BIT", $sformatf("Slave Address = %0b", slv_addr_wr_rd[0]), UVM_NONE)

        @(posedge i2c_intf.SCL_PAD_I);
        slv_ack_bit = i2c_intf.SDA_PAD_I;
        `uvm_info("I2C_SLAVE_ACK_BIT", $sformatf("Slave Ack Bit = %0b", slv_ack_bit), UVM_NONE)
        if(slv_ack_bit == 0) begin
          slv_addr_ack = 1;
        end
        break;
      end
    end
  endtask

  task memory_address();
    forever begin
      @(posedge i2c_intf.SCL_PAD_I);
      if(slv_addr_ack==1'b1) begin
        for(int i = 0; i <= 7; i++)begin
          @(posedge i2c_intf.SCL_PAD_I);
          slv_mem_addr[($bits(slv_mem_addr) - 1) - i] = i2c_intf.SDA_PAD_I;
          `uvm_info("I2C_SLAVE_MEM_ADDR_BIT", $sformatf("Slave Mem Addr Ack Bit[%0d] = %0b", (($bits(slv_mem_addr) - 1) - i), slv_mem_addr[($bits(slv_mem_addr) - 1) - i]), UVM_MEDIUM)
        end
        `uvm_info("I2C_SLAVE_MEM_ADDRESS_BITS", $sformatf("Slave Mem Address = %0b", slv_mem_addr), UVM_NONE)
        
        @(posedge i2c_intf.SCL_PAD_I);
        slv_mem_ack_bit = i2c_intf.SDA_PAD_I;
        `uvm_info("I2C_SLAVE_ACK_BIT", $sformatf("Slave Ack Bit = %0b", slv_mem_ack_bit), UVM_NONE)
        if(slv_ack_bit == 0) begin
          slv_mem_addr_ack = 1;
        end
        break;
      end
    end
  endtask

  task transmit_data();
    forever begin
      @(posedge i2c_intf.SCL_PAD_I);
      if(slv_mem_addr_ack && transfer_stop != 1 && transfer_start != 1 && slv_mem_addr_ack == 1) begin
        for(int i = 0; i <= 7; i++)begin
          @(posedge i2c_intf.SCL_PAD_I);
          write_data[($bits(write_data) - 1) - i] = i2c_intf.SDA_PAD_I;
          `uvm_info("I2C_SLAVE_WRITE_DATA", $sformatf("Slave Write Data Bit[%0d] = %0b", (($bits(slv_mem_addr) - 1) - i), write_data[($bits(write_data) - 1) - i]), UVM_MEDIUM)
        end
        `uvm_info("I2C_TRANSMIT DATA", $sformatf("Transmit Data = %0b", write_data), UVM_NONE)

        @(posedge i2c_intf.SCL_PAD_I);
        data_ack_bit = i2c_intf.SDA_PAD_I;
        `uvm_info("I2C_TRANSMIT_DATA_ACK_BIT", $sformatf("Data Ack Bit = %0b", data_ack_bit), UVM_NONE)
        if(data_ack_bit == 0) begin
          data_ack = 1;
        end
        break;
      end
    end
  endtask

  // ! I2C Monitor Run Phase
  task run_phase(uvm_phase phase);
    `uvm_info(get_full_name(), "Inside I2C Monitor Run Phase.", UVM_LOW)

    fork
      start_condition();
      slave_address();
      memory_address();
      transmit_data();
      stop_condition();
      //`uvm_info("I2C_SLAVE_ADDRESS", $sformatf("Slave Address = %0h", slv_addr_wr_rd), UVM_NONE)
      
    join

  endtask
endclass