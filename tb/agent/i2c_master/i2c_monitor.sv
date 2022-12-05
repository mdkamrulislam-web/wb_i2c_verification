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
  logic [7:0] t_data    ;
  logic       data_ack_bit     ;
  
  logic       slv_addr_ack     ;
  logic       slv_mem_addr_ack ;
  logic       data_ack         ;

  logic mem_trigger;
  logic dat_trigger;

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
    //forever begin
      @(negedge i2c_intf.TB_SDA);
      if(i2c_intf.TB_SCL == 1) begin
        transfer_start = 1;
        transfer_stop  = 0;
        `uvm_info("START_BIT", $sformatf("Start Flag = %0b :: Stop Flag = %0b", transfer_start, transfer_stop), UVM_NONE)
        `uvm_info("START_FLAG_VALS", $sformatf("Start = %0b :: Stop = %0b :: SLV_ADDR_ACK = %0b :: SLV_MEM_ADDR_ACK = %0b :: DATA_ACK = %0b, MEM_Tri = %0b, DATA_Tri = %0b", transfer_start, transfer_stop, slv_addr_ack, slv_mem_addr_ack, data_ack, mem_trigger, dat_trigger), UVM_NONE)
      end
    //end
  endtask

  // I2C Stop Condition Checker
  task stop_condition();
    //forever begin
      @(posedge i2c_intf.TB_SDA);
      if(i2c_intf.TB_SCL == 1) begin
        transfer_stop = 1;
        slv_mem_addr_ack = 0;  // For_Data
        mem_trigger = 0;
        dat_trigger = 0;
       
        `uvm_info("STOP_BIT", $sformatf("Start Flag = %0b :: Stop Flag = %0b", transfer_start, transfer_stop), UVM_NONE)
        `uvm_info("START_FLAG_VALS", $sformatf("Start = %0b :: Stop = %0b :: SLV_ADDR_ACK = %0b :: SLV_MEM_ADDR_ACK = %0b :: DATA_ACK = %0b, MEM_Tri = %0b, DATA_Tri = %0b", transfer_start, transfer_stop, slv_addr_ack, slv_mem_addr_ack, data_ack, mem_trigger, dat_trigger), UVM_NONE)
      end
    //end
  endtask

  // Slave Address
  task slave_address();
    //forever begin
      @(posedge i2c_intf.TB_SCL);
      if(transfer_start) begin
        transfer_start = 0;
        for(int i = 7; i >= 1; i--) begin
          slv_addr_wr_rd[i] = i2c_intf.TB_SDA;
          `uvm_info("SLAVE_ADDRESS_BITS", $sformatf("Slave Address Bits = %0b", slv_addr_wr_rd), UVM_HIGH)
          @(posedge i2c_intf.TB_SCL);
        end
        `uvm_info("SLAVE_ADDRESS", $sformatf("Slave Address = %0b", slv_addr_wr_rd[7:1]), UVM_NONE)

        slv_addr_wr_rd[0] = i2c_intf.TB_SDA;
        `uvm_info("WR_RD_BIT", $sformatf("W/R Bit = %0b", slv_addr_wr_rd[0]), UVM_NONE)


        @(posedge i2c_intf.TB_SCL);
        slv_ack_bit = i2c_intf.TB_SDA;
        if((slv_ack_bit == 0) && (i2c_intf.SDA_PADOEN_O == 1)) begin
          `uvm_info("SLAVE_ACK_BIT", $sformatf("Slave Ack Bit = %0b", slv_ack_bit), UVM_NONE)
          slv_addr_ack = 1;
        end
        `uvm_info("START_FLAG_VALS", $sformatf("Start = %0b :: Stop = %0b :: SLV_ADDR_ACK = %0b :: SLV_MEM_ADDR_ACK = %0b :: DATA_ACK = %0b, MEM_Tri = %0b, DATA_Tri = %0b", transfer_start, transfer_stop, slv_addr_ack, slv_mem_addr_ack, data_ack, mem_trigger, dat_trigger), UVM_NONE)
      end
    //end
  endtask

  task memory_address();
    //forever begin
      @(posedge i2c_intf.TB_SCL);
      //`uvm_info("CHECKER", "################################################", UVM_NONE);
      if(slv_addr_ack == 1'b1) begin
        
        slv_addr_ack = 0;
        for(int i = 0; i <= 7; i++) begin
          slv_mem_addr[($bits(slv_mem_addr) - 1) - i] = i2c_intf.TB_SDA;
          `uvm_info("MEMORY_ADDR_BITS", $sformatf("Slave Mem Addr Ack Bit[%0d] = %0b", (($bits(slv_mem_addr) - 1) - i), slv_mem_addr[($bits(slv_mem_addr) - 1) - i]), UVM_HIGH)
          @(posedge i2c_intf.TB_SCL);
        end
        `uvm_info("MEMORY_ADDRESS", $sformatf("Memory Address = %0b", slv_mem_addr), UVM_NONE)
        
        
        slv_mem_ack_bit = i2c_intf.TB_SDA;
        if((slv_mem_ack_bit == 0) && (i2c_intf.SDA_PADOEN_O == 1)) begin
          `uvm_info("SLAVE_MEM_ACK_BIT", $sformatf("Slave Mem Ack Bit = %0b", slv_mem_ack_bit), UVM_NONE)
          slv_mem_addr_ack = 1;
        end
        
       // @(posedge i2c_intf.TB_SCL);
        mem_trigger = 1;
        `uvm_info("START_FLAG_VALS", $sformatf("Start = %0b :: Stop = %0b :: SLV_ADDR_ACK = %0b :: SLV_MEM_ADDR_ACK = %0b :: DATA_ACK = %0b, MEM_Tri = %0b, DATA_Tri = %0b", transfer_start, transfer_stop, slv_addr_ack, slv_mem_addr_ack, data_ack, mem_trigger, dat_trigger), UVM_NONE)
      end
    //end
  endtask

  task transmit_data();
    //forever begin
      @(posedge i2c_intf.TB_SCL);
      //`uvm_info("CHECKER", "################################################", UVM_NONE);
      if((mem_trigger && (slv_mem_addr_ack == 1'b1)) || dat_trigger) begin
        slv_mem_addr_ack = 0;
        for(int i = 0; i <= 7; i++)begin
          t_data[($bits(t_data) - 1) - i] = i2c_intf.TB_SDA;
          `uvm_info("TRANSMIT_DATA_BITS", $sformatf("Transmit Data Bit[%0d] = %0b", (($bits(t_data) - 1) - i), t_data[($bits(t_data) - 1) - i]), UVM_HIGH)
          @(posedge i2c_intf.TB_SCL);
        end
        `uvm_info("TRANSMIT DATA", $sformatf("Transmit Data = %0b", t_data), UVM_NONE)
         
        
        data_ack_bit = i2c_intf.TB_SDA;
        `uvm_info("TRANSMIT_DATA_ACK_BIT", $sformatf("Transmit Data Ack Bit = %0b", data_ack_bit), UVM_NONE)
        if(data_ack_bit == 0) begin
          data_ack = 1;
        end
        //@(posedge i2c_intf.TB_SCL);
        dat_trigger = 1;
        `uvm_info("START_FLAG_VALS", $sformatf("Start = %0b :: Stop = %0b :: SLV_ADDR_ACK = %0b :: SLV_MEM_ADDR_ACK = %0b :: DATA_ACK = %0b, MEM_Tri = %0b, DATA_Tri = %0b", transfer_start, transfer_stop, slv_addr_ack, slv_mem_addr_ack, data_ack, mem_trigger, dat_trigger), UVM_NONE)
      end
    //end
  endtask

//  task transmit_data();
//    forever begin
//      @(posedge i2c_intf.SCL_PAD_I);
//      if((slv_mem_addr_ack == 1) && (transfer_stop != 1'b1)) begin
//        for(int i = 0; i <= 6; i++) begin
//          data_fifo[i] = i2c_intf.SDA_PAD_I;
//          `uvm_info("TRANSMISSION CHECKER", $sformatf("data*_&&&&&&&&&&&&&&&&&&&&&&&&=%b", data_fifo[i]), UVM_NONE)
//          if(transfer_start === 1 && transfer_stop === 1) begin
//            i = 0; 
//            data_fifo[0] = i2c_intf.SDA_PAD_I;
//            transfer_stop = 0;
//            transfer_start = 0;
//          end
//          @(posedge i2c_intf.SCL_PAD_I);
//        end
//        data_fifo[7] = i2c_intf.SDA_PAD_I;
//        `uvm_info("TRANSMISSION CHECKER", $sformatf("data*_&&&&&&&&&&&&&&&&&&&&&&&&=%b", data_fifo[7]), UVM_NONE)
//        for(int i = 7; i <= 0; i--) begin
//           t_data[i] = data_fifo[i];
//        end
//        `uvm_info("TRANSMIT DATA", $sformatf("Transmit Data = %0b", t_data), UVM_NONE)
//
//        @(negedge i2c_intf.SCL_PAD_I);
//        data_ack_bit = i2c_intf.SDA_PAD_I;                       
//      end
//    end
//  endtask

  // ! I2C Monitor Run Phase
  task run_phase(uvm_phase phase);
    `uvm_info(get_full_name(), "Inside I2C Monitor Run Phase.", UVM_LOW)

    repeat(2) @(negedge i2c_intf.CLK_I);
    forever begin
      fork
        start_condition();
        slave_address();
        memory_address();
        transmit_data();
        stop_condition();
        //`uvm_info("I2C_SLAVE_ADDRESS", $sformatf("Slave Address = %0h", slv_addr_wr_rd), UVM_NONE)
      join
      //@(posedge i2c_intf.SCL_PAD_I);
    end

  endtask
endclass
