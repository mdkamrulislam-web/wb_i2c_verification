class wb_monitor extends uvm_monitor;
  // ! Factory registration of Wishbone Monitor
  `uvm_component_utils(wb_monitor)

  // ! Declaring handle for virtual interface
  virtual wb_interface wb_intf;

  // ! Declaring a handle of WB_SEQ_ITEM
  wb_sequence_item wb_mtr_seq_item;

  // ! Wishbone Monitor Constructor
  function new(string name = "wb_monitor", uvm_component parent = null);
    super.new(name, parent);
    `uvm_info(get_full_name(), "Inside Wishbone Monitor Constructor.", UVM_MEDIUM)
  endfunction

  // ! Wishbone Monitor Build Phase
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_full_name(), "Inside Wishbone Monitor Build Phase.", UVM_MEDIUM)

    if(!uvm_config_db#(virtual wb_interface)::get(this, "", "wb_vintf", wb_intf)) begin
      `uvm_fatal("WB Virtual Interface Not Found Inside Monitor!", {"Virtual interface must be set for: ",get_full_name(),".wb_vintf"})
    end
    else begin
      `uvm_info("WB_INTF", "WB Virtual Interface found inside monitor.", UVM_MEDIUM)
    end
  endfunction

  // ! Wishbone Monitor Connect Phase
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info(get_full_name(), "Inside Wishbone Monitor Connect Phase.", UVM_MEDIUM)
  endfunction

  // ! Wishbone Monitor Run Phase
  task run_phase(uvm_phase phase);
    `uvm_info(get_full_name(), "Inside Wishbone Monitor Run Phase.", UVM_MEDIUM)
/*
    // Creating an instance of WB Sequence Item
    wb_mtr_seq_item = wb_sequence_item::type_id::create("wb_mtr_seq_item");

    fork
      begin
        forever begin
          if(wb_intf.WB_RST_I) begin
            @(posedge wb_intf.WB_CLK_I);
            if((wb_intf.WB_DAT_O == 8'hFF) && !wb_intf.WB_ACK_O && !wb_intf.WB_INTA_O) begin
              `uvm_info("Passed", $sformatf("Expected :: 8'hFF, Actual :: %0h", wb_intf.WB_DAT_O), UVM_MEDIUM)
            end
            else begin
              `uvm_error("Passed", $sformatf("Expected :: 8'hFF, Actual :: %0h", wb_intf.WB_DAT_O))
            end
          end
          else if(!wb_intf.WB_RST_I && !wb_intf.WB_WE_I && wb_intf.WB_CYC_I && wb_intf.WB_STB_I) begin
            @(negedge wb_intf.WB_CLK_I);
            if(wb_intf.WB_ACK_O) begin
              
            end
          end
        end
      end

      begin

      end
    join_none
*/
  endtask
endclass