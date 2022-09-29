module tb_top;
  // ! Importing UVM Package and Test Package
  import uvm_pkg::*;
  import wb_i2c_test_pkg::*;

  // ! Clock Signal Declaration
  bit WB_CLK_I;

  // ! Clock Generation
  initial forever #15.625 WB_CLK_I = ~WB_CLK_I;

  // ! Interface Instance
  wb_interface wb_intf(WB_CLK_I);

  // ! DUT instance
  i2c_master_top I2C_DUT(
    .wb_clk_i   (  wb_intf.WB_CLK_I  )  ,
    .wb_rst_i   (  wb_intf.WB_RST_I   )  ,
    .arst_i     (  wb_intf.ARST_I     )  ,
    .wb_adr_i   (  wb_intf.WB_ADR_I   )  ,
    .wb_dat_i   (  wb_intf.WB_DAT_I   )  ,
    .wb_dat_o   (  wb_intf.WB_DAT_O   )  ,
    .wb_we_i    (  wb_intf.WB_WE_I    )  ,
    .wb_stb_i   (  wb_intf.WB_STB_I   )  ,
    .wb_cyc_i   (  wb_intf.WB_CYC_I   )  ,
    .wb_ack_o   (  wb_intf.WB_ACK_O   )  ,
    .wb_inta_o  (  wb_intf.WB_INTA_O  )
  );

  initial begin
    `uvm_info("TB_TOP", "Inside tb_top Initial block", UVM_NONE)

    uvm_config_db#(virtual wb_interface)::set(null, "*", "wb_vintf", wb_intf);

    run_test("wb_i2c_base_test");
    $finish;
  end
endmodule
