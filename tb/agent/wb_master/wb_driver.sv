class wb_driver extends uvm_driver #(wb_sequence_item);
  // ! Factory registration of Wishbone Driver
  `uvm_component_utils(wb_driver)

  // ! Delcaring handle for virtual interface
  virtual wb_interface wb_intf;

  // ! Declaring a handle for WB_SEQUENCE_ITEM, which will be used to receive incoming packet for driving data to the DUT.
  wb_sequence_item dvr_seq_item;

  // ! Wishbone Driver Constructor
  function new(string name = "wb_driver", uvm_component parent = null);
    super.new(name, parent);
    `uvm_info(get_full_name(), "Inside Wishbone Driver Constructor.", UVM_NONE)
  endfunction
  
  // ! Wishbone Driver Build Phase
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_full_name(), "Inside Wishbone Driver Build Phase.", UVM_NONE)

    if(!uvm_config_db#(virtual wb_interface)::get(this, "", "wb_vintf", wb_intf)) begin
      `uvm_fatal("WB Virtual Interface Not Found Inside Driver!", {"Virtual interface must be set for: ",get_full_name(),".wb_vintf"})
    end
    else begin
      `uvm_info("WB_INTF", "WB Virtual Interface found inside driver.", UVM_NONE)
    end
  endfunction
  
  // ! Wishbone Driver Connect Phase
  virtual function void connect_phase(uvm_phase phase);
    `uvm_info(get_full_name(), "Inside Wishbone Driver Connect Phase.", UVM_NONE)
  endfunction
  
  // ! Wishbone Driver Run Phase
  task run_phase(uvm_phase phase);
    `uvm_info(get_full_name(), "Inside Wishbone Driver Run Phase.", UVM_NONE)

    forever begin
      seq_item_port.get_next_item(dvr_seq_item);
        if(dvr_seq_item.wb_rst_i == 1) begin
          wb_sync_reset();
        end
      seq_item_port.item_done();
    end
  endtask

  task wb_sync_reset();
    wb_intf.WB_RST_I <= 0;
    wb_intf.WB_ADR_I <= 0;
    wb_intf.WB_DAT_I <= 0;
    wb_intf.WB_WE_I  <= 0;
    wb_intf.WB_STB_I <= 0;
    wb_intf.WB_CYC_I <= 0;

    @(negedge wb_intf.WB_CLK_I);

    wb_intf.WB_RST_I <= 1;

    @(negedge wb_intf.WB_CLK_I);
  endtask

/*
WB_RST_I 
ARST_I   
WB_ADR_I 
WB_DAT_I 
WB_DAT_O 
WB_WE_I  
WB_STB_I 
WB_CYC_I 
WB_ACK_O 
WB_INTA_O
*/
endclass