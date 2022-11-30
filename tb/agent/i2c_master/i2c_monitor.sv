class i2c_monitor extends uvm_monitor;
  // ! Factory registration of I2C Monitor
  `uvm_component_utils(i2c_monitor)

  // ! Declaring Handle for I2C Interface
  virtual i2c_interface i2c_intf;

  // ! Monitor Flags
  static bit transfer_start;

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

  task i2c_start_condition();
    forever begin
      @(negedge i2c_intf.SDA_PAD_I);
      @(posedge i2c_intf.CLK_I);
      if(i2c_intf.SDA_PAD_I === 0 && i2c_intf.SCL_PAD_I === 1 && !transfer_start) begin
        if(i2c_intf.SDA_PAD_I === 0 && i2c_intf.SCL_PAD_I === 1 && !transfer_start) begin
        transfer_start = 1;
      end
    end
  endtask

  // ! I2C Monitor Run Phase
  task run_phase(uvm_phase phase);
    `uvm_info(get_full_name(), "Inside I2C Monitor Run Phase.", UVM_LOW)

    fork
      `uvm_info("Transfer Start", $sformatf("Transfer Start = %0b", transfer_start), UVM_NONE)
      i2c_start_condition();
      `uvm_info("Transfer Start", $sformatf("Transfer Start = %0b", transfer_start), UVM_NONE)
    join
  endtask
endclass
