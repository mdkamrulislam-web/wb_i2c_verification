class wb_driver extends uvm_driver #(wb_sequence_item);
  // ! Factory registration of Wishbone Driver
  `uvm_component_utils(wb_driver)

  bit tip_flag;

  `include "../../defines/defines.sv"

  // ! Delcaring handle for virtual interface
  virtual wb_interface wb_intf;

  // ! Declaring a handle for WB_SEQUENCE_ITEM, which will be used to receive incoming packet for driving data to the DUT.
  wb_sequence_item dvr_seq_item;

  // ! Wishbone Driver Constructor
  function new(string name = "wb_driver", uvm_component parent = null);
    super.new(name, parent);
    `uvm_info(get_full_name(), "Inside Wishbone Driver Constructor.", UVM_MEDIUM)
  endfunction
  
  // ! Wishbone Driver Build Phase
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_full_name(), "Inside Wishbone Driver Build Phase.", UVM_MEDIUM)

    if(!uvm_config_db#(virtual wb_interface)::get(this, "", "wb_vintf", wb_intf)) begin
      `uvm_fatal("WB Virtual Interface Not Found Inside Driver!", {"Virtual interface must be set for: ",get_full_name(),".wb_vintf"})
    end
    else begin
      `uvm_info("WB_INTF", "WB Virtual Interface found inside driver.", UVM_MEDIUM)
    end
  endfunction
  
  // ! Wishbone Driver Connect Phase
  virtual function void connect_phase(uvm_phase phase);
    `uvm_info(get_full_name(), "Inside Wishbone Driver Connect Phase.", UVM_MEDIUM)
  endfunction
  
  // ! Wishbone Driver Run Phase
  task run_phase(uvm_phase phase);
    `uvm_info(get_full_name(), "Inside Wishbone Driver Run Phase.", UVM_MEDIUM)

    forever begin
      seq_item_port.get_next_item(dvr_seq_item);
        if(dvr_seq_item.wb_rst_i == 1) begin
          wb_reset();
        end
        else if((dvr_seq_item.wb_rst_i == 0) && (dvr_seq_item.wb_we_i == 1)) begin
          wb_write();
        end
        else if((dvr_seq_item.wb_rst_i == 0) && (dvr_seq_item.wb_we_i == 0)) begin
          wb_read();
        end
      seq_item_port.item_done(dvr_seq_item);
    end
  endtask
  
  // ! RESET TASK
  task wb_reset();
    wb_intf.WB_ADR_I <= 3'hX;
    wb_intf.WB_DAT_I <= 8'hXX;
    wb_intf.WB_WE_I  <= 1'hX;
    wb_intf.WB_STB_I <= 1'hX;
    wb_intf.WB_CYC_I <= 0;
    
    wb_intf.WB_RST_I <= 1;
    wb_intf.ARST_I   <= 1;

    repeat (6) @(negedge wb_intf.WB_CLK_I);

    wb_intf.WB_RST_I <= 0;
    wb_intf.ARST_I   <= 0;
    
    repeat (3) @(negedge wb_intf.WB_CLK_I);
  endtask

  // ! WRITE TASK
  task wb_write();
    @(negedge wb_intf.WB_CLK_I);

    wb_intf.WB_WE_I  <= 1;
    wb_intf.WB_STB_I <= 1;
    wb_intf.WB_CYC_I <= 1;
    
    //@(negedge wb_intf.WB_CLK_I);

    wb_intf.WB_ADR_I <= dvr_seq_item.wb_adr_i;
    wb_intf.WB_DAT_I <= dvr_seq_item.wb_dat_i;

    @(negedge wb_intf.WB_CLK_I);
    //wb_dvr2scb_port.write(dvr_seq_item);

    while(~wb_intf.WB_ACK_O) @(negedge wb_intf.WB_CLK_I);

    //`uvm_info("DRIVER_WRITE_CHECKER", $sformatf("Addr :: %0h, Data :: %0h", wb_intf.WB_ADR_I, wb_intf.WB_DAT_I), UVM_LOW)

    wb_intf.WB_ADR_I <= 3'hX;
    wb_intf.WB_DAT_I <= 8'hXX;
    wb_intf.WB_WE_I  <= 1'hX;
    wb_intf.WB_STB_I <= 1'hX;
    wb_intf.WB_CYC_I <= 0;
  endtask
  
  // ! READ TASK
  task wb_read();
    @(negedge wb_intf.WB_CLK_I);

    wb_intf.WB_WE_I  <= 0;
    wb_intf.WB_STB_I <= 1;
    wb_intf.WB_CYC_I <= 1;    
    wb_intf.WB_ADR_I <= dvr_seq_item.wb_adr_i;

    @(negedge wb_intf.WB_CLK_I);
    if(wb_intf.WB_ADR_I == `SR) begin
      if(wb_intf.WB_DAT_O[1] == 1) begin
        dvr_seq_item.t_flag = 1;
      end
      else begin
        dvr_seq_item.t_flag = 0;
      end
    end

    while(~wb_intf.WB_ACK_O) @(negedge wb_intf.WB_CLK_I);
    //`uvm_info("READ_CHECKER", $sformatf("Addr :: %0h, Data :: %0h", wb_intf.WB_ADR_I, wb_intf.WB_DAT_O), UVM_LOW)

    wb_intf.WB_ADR_I <= 3'hX;
    wb_intf.WB_WE_I  <= 1'hX;
    wb_intf.WB_STB_I <= 1'hX;
    wb_intf.WB_CYC_I <= 0;
  endtask
endclass