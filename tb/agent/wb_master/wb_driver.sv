class wb_driver extends uvm_driver #(wb_sequence_item);
  // ! Factory registration of Wishbone Driver
  `uvm_component_utils(wb_driver)

  // ! Delcaring handle for virtual interface
  virtual wb_interface wb_intf;

  // ! Declaring a handle for WB_SEQUENCE_ITEM, which will be used to receive incoming packet for driving data to the DUT.
  wb_sequence_item dvr_seq_item;

  // ! Declearing uvm_analysis_port, which is used to send packets from driver to scoreboard.
	uvm_analysis_port #(wb_sequence_item) wb_dvr2scb_port;

  // ! Wishbone Driver Constructor
  function new(string name = "wb_driver", uvm_component parent = null);
    super.new(name, parent);
    `uvm_info(get_full_name(), "Inside Wishbone Driver Constructor.", UVM_MEDIUM)

    wb_dvr2scb_port = new("wb_dvr_scb", this);
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
      seq_item_port.item_done();
    end
  endtask
  
  // ! RESET TASK
  task wb_reset();
    wb_intf.WB_ADR_I <= 0;
    wb_intf.WB_DAT_I <= 0;
    wb_intf.WB_WE_I  <= 0;
    wb_intf.WB_STB_I <= 0;
    wb_intf.WB_CYC_I <= 0;
    
    wb_intf.WB_RST_I <= 1;
    wb_intf.ARST_I   <= 1;

    @(negedge wb_intf.WB_CLK_I);

    wb_intf.WB_RST_I <= 0;
    wb_intf.ARST_I   <= 0;

    wb_intf.WB_STB_I <= 0;
    wb_intf.WB_CYC_I <= 0;
    
    repeat (5) @(negedge wb_intf.WB_CLK_I);
  endtask

  // ! WRITE TASK
  task wb_write();
    wb_intf.WB_WE_I  <= 1;
    wb_intf.WB_STB_I <= 1;
    wb_intf.WB_CYC_I <= 1;
    
    @(negedge wb_intf.WB_CLK_I);

    wb_intf.WB_ADR_I <= dvr_seq_item.wb_adr_i;
    wb_intf.WB_DAT_I <= dvr_seq_item.wb_dat_i;

    @(negedge wb_intf.WB_CLK_I);

    wb_dvr2scb_port.write(dvr_seq_item);
    
    `uvm_info("DRIVER_WRITE_CHECKER", $sformatf("Addr :: %0h, Data :: %0h", wb_intf.WB_ADR_I, wb_intf.WB_DAT_I), UVM_LOW)

    wb_intf.WB_WE_I  <= 0;
    wb_intf.WB_STB_I <= 0;
    wb_intf.WB_CYC_I <= 0;
  endtask
  
  // ! READ TASK
  task wb_read();
    wb_intf.WB_WE_I  <= 0;
    wb_intf.WB_STB_I <= 1;
    wb_intf.WB_CYC_I <= 1;    

    @(negedge wb_intf.WB_CLK_I);

    wb_intf.WB_ADR_I <= dvr_seq_item.wb_adr_i;

    @(negedge wb_intf.WB_CLK_I);

    //`uvm_info("READ_CHECKER", $sformatf("Addr :: %0h, Data :: %0h", wb_intf.WB_ADR_I, wb_intf.WB_DAT_O), UVM_LOW)

    wb_intf.WB_WE_I  <= 0;
    wb_intf.WB_STB_I <= 0;
    wb_intf.WB_CYC_I <= 0;
  endtask
endclass