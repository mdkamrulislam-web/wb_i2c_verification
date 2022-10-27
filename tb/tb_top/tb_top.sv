`include "uvm_macros.svh"
module tb_top;
  // ! Importing UVM Package and Test Package
  import uvm_pkg::*;
  import wb_i2c_test_pkg::*;

  // ! Clock Signal Declaration
  bit WB_CLK_I;

  // ! Clock Generation
  initial forever #15.625 WB_CLK_I = ~WB_CLK_I;

  // ! Interface Instance
  wb_i2c_interface wb_i2c_intf(WB_CLK_I);

  // ! WB DUT instance
  i2c_master_top WB_DUT(
    .wb_clk_i     (  wb_i2c_intf.WB_CLK_I     )  ,
    .wb_rst_i     (  wb_i2c_intf.WB_RST_I     )  ,
    .arst_i       (  wb_i2c_intf.ARST_I       )  ,
    .wb_adr_i     (  wb_i2c_intf.WB_ADR_I     )  ,
    .wb_dat_i     (  wb_i2c_intf.WB_DAT_I     )  ,
    .wb_dat_o     (  wb_i2c_intf.WB_DAT_O     )  ,
    .wb_we_i      (  wb_i2c_intf.WB_WE_I      )  ,
    .wb_stb_i     (  wb_i2c_intf.WB_STB_I     )  ,
    .wb_cyc_i     (  wb_i2c_intf.WB_CYC_I     )  ,
    .wb_ack_o     (  wb_i2c_intf.WB_ACK_O     )  ,
    .wb_inta_o    (  wb_i2c_intf.WB_INTA_O    )  ,
    .scl_pad_i    (  wb_i2c_intf.SCL_PAD_I    )  ,
    .scl_pad_o    (  wb_i2c_intf.SCL_PAD_O    )  ,
    .scl_padoen_o (  wb_i2c_intf.SCL_PADOEN_O )  ,
    .sda_pad_i    (  wb_i2c_intf.SDA_PAD_I    )  ,
    .sda_pad_o    (  wb_i2c_intf.SDA_PAD_O    )  ,
    .sda_padoen_o (  wb_i2c_intf.SDA_PADOEN_O )
  );

  // ! I2C DUT instance


  initial begin
    `uvm_info("TB_TOP", "Inside tb_top Initial block", UVM_MEDIUM)

    uvm_config_db#(virtual wb_i2c_interface)::set(null, "*", "wb_i2c_vintf", wb_i2c_intf);

    run_test("wb_i2c_base_test");
    $finish;
  end
endmodule
