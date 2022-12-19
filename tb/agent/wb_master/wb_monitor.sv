class wb_monitor extends uvm_monitor;
  // ! Factory registration of Wishbone Monitor
  `uvm_component_utils(wb_monitor)

  `include "../../defines/defines.sv"

  // ! Declaring handle for virtual interface
  virtual wb_interface wb_intf;

  // ! Declaring a handle of WB_SEQ_ITEM
  wb_sequence_item wb_mtr_seq_item;

  // ! Declearing uvm_analysis_port, which is used to send packets from monitor to scoreboard.
  uvm_analysis_port #(wb_sequence_item) wb_mtr2scb_port;

  // ! Wishbone Monitor Constructor
  function new(string name = "wb_monitor", uvm_component parent = null);
    super.new(name, parent);
    `uvm_info(get_full_name(), "Inside Wishbone Monitor Constructor.", UVM_HIGH)
    wb_mtr2scb_port = new("wb_mtr2scb_port", this);
  endfunction

  // ! Wishbone Monitor Build Phase
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_full_name(), "Inside Wishbone Monitor Build Phase.", UVM_HIGH)

    if(!uvm_config_db#(virtual wb_interface)::get(this, "", "wb_vintf", wb_intf)) begin
      `uvm_fatal("WB Virtual Interface Not Found Inside Monitor!", {"Virtual interface must be set for: ",get_full_name(),".wb_vintf"})
    end
    else begin
      `uvm_info("WB_INTF", "WB Virtual Interface found inside monitor.", UVM_HIGH)
    end
  endfunction

  // ! Wishbone Monitor Connect Phase
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info(get_full_name(), "Inside Wishbone Monitor Connect Phase.", UVM_HIGH)
  endfunction

  // ! Wishbone Monitor Run Phase
  task run_phase(uvm_phase phase);
    `uvm_info(get_full_name(), "Inside Wishbone Monitor Run Phase.", UVM_HIGH)

    fork

      // WB Write Condition
      begin
        forever begin
          @(posedge wb_intf.WB_CLK_I);
          if((!wb_intf.WB_RST_I && !wb_intf.ARST_I) && (wb_intf.WB_CYC_I && wb_intf.WB_STB_I && wb_intf.WB_WE_I)) begin
            wb_mtr_seq_item = wb_sequence_item::type_id::create("wb_mtr_seq_item");
            wb_mtr_seq_item.wb_adr_i = wb_intf.WB_ADR_I;
            wb_mtr_seq_item.wb_dat_i = wb_intf.WB_DAT_I;
            `uvm_info("MONITOR_WRITE_CHECKER", $sformatf("Addr :: %0h, Data :: %0h", wb_mtr_seq_item.wb_adr_i, wb_mtr_seq_item.wb_dat_i), UVM_HIGH);
            wb_mtr2scb_port.write(wb_mtr_seq_item);
          end
        end
      end
      
      // WB Read Condition
      begin
        forever begin
          @(posedge wb_intf.WB_CLK_I);
          if((!wb_intf.WB_RST_I && !wb_intf.ARST_I) && (wb_intf.WB_CYC_I && wb_intf.WB_STB_I && !wb_intf.WB_WE_I) && (wb_intf.WB_ADR_I == `RXR)) begin
            @(negedge wb_intf.WB_CLK_I);
            if(wb_intf.WB_ACK_O) begin
              wb_mtr_seq_item = wb_sequence_item::type_id::create("wb_mtr_seq_item");
              wb_mtr_seq_item.wb_adr_i = wb_intf.WB_ADR_I;
              wb_mtr_seq_item.wb_dat_o = wb_intf.WB_DAT_O;
              `uvm_info("MONITOR_READ_CHECKER", $sformatf("Addr :: %0h, Data :: %0h", wb_mtr_seq_item.wb_adr_i, wb_mtr_seq_item.wb_dat_o), UVM_HIGH);
              wb_mtr2scb_port.write(wb_mtr_seq_item);
            end
          end
        end
      end
/*
      begin
        forever begin
          @(negedge wb_intf.WB_CLK_I);
          if((wb_intf.WB_RST_I || wb_intf.ARST_I) && (wb_intf.WB_CYC_I && wb_intf.WB_STB_I && !wb_intf.WB_WE_I)) begin
            `uvm_info("MONITOR_READ_CHECKER", $sformatf("Addr :: %0h,Data :: %0h", wb_intf.WB_ADR_I, wb_intf.WB_DAT_O), UVM_HIGH);
            wb_act_mtr2scb_port.write(wb_act_mtr_seq_item);
          end
        end
      end
*/
    join_none
  endtask
endclass