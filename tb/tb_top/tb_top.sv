`include "../../rtl/timescale.v"
`include "uvm_macros.svh"
module tb_top;
  // ! Importing UVM Package and Test Package
  import uvm_pkg::*;
  import wb_i2c_test_pkg::*;

  // ! Clock Signal Declaration
  bit WB_CLK_I;

  wire sda;
  wire scl;

  // ! Register
  reg [7:0] myReg;

  // ! Clock Generation
  initial forever #10 WB_CLK_I = ~WB_CLK_I;

  // ! Interface Instance
  wb_interface wb_intf(WB_CLK_I);
  i2c_interface i2c_intf(WB_CLK_I);

  // ! I2C Slave Model Connection
  i2cSlave I2C_SLV_DUT(
    .clk   (  wb_intf.WB_CLK_I  ),
    .rst   (  wb_intf.WB_RST_I  ),
    .sda   (  sda               ),
    .scl   (  scl               ),
    .myReg0(                    ),
    .myReg1(                    ),
    .myReg2(                    ),
    .myReg3(                    ),
    .myReg4(  8'h12             ),
    .myReg5(  8'h34             ),
    .myReg6(  8'h56             ),
    .myReg7(  8'h78             )
  );

  // ! WB DUT instance
  i2c_master_top #(.ARST_LVL(1'b1)) WB_I2C_DUT(
    // Wishbone Signals
    .wb_clk_i     ( wb_intf.WB_CLK_I      )  ,
    .wb_rst_i     ( wb_intf.WB_RST_I      )  ,
    .arst_i       ( wb_intf.ARST_I        )  ,
    .wb_adr_i     ( wb_intf.WB_ADR_I      )  ,
    .wb_dat_i     ( wb_intf.WB_DAT_I      )  ,
    .wb_dat_o     ( wb_intf.WB_DAT_O      )  ,
    .wb_we_i      ( wb_intf.WB_WE_I       )  ,
    .wb_stb_i     ( wb_intf.WB_STB_I      )  ,
    .wb_cyc_i     ( wb_intf.WB_CYC_I      )  ,
    .wb_ack_o     ( wb_intf.WB_ACK_O      )  ,
    .wb_inta_o    ( wb_intf.WB_INTA_O     )  ,

    // I2C Signals
    .scl_pad_i    ( i2c_intf.SCL_PAD_I    )  ,
    .scl_pad_o    ( i2c_intf.SCL_PAD_O    )  ,
    .scl_padoen_o ( i2c_intf.SCL_PADOEN_O )  ,
    .sda_pad_i    ( i2c_intf.SDA_PAD_I    )  ,
    .sda_pad_o    ( i2c_intf.SDA_PAD_O    )  ,
    .sda_padoen_o ( i2c_intf.SDA_PADOEN_O )
  );

  assign sda = i2c_intf.SDA_PADOEN_O ? 1'bz : i2c_intf.SDA_PAD_O;
  assign i2c_intf.SDA_PAD_I = sda;
  pullup(sda);

  assign scl = i2c_intf.SCL_PADOEN_O ? 1'bz : i2c_intf.SCL_PAD_O;
  assign i2c_intf.SCL_PAD_I = scl;
  pullup(scl);

  initial begin
    `uvm_info("TB_TOP", "Inside tb_top Initial block", UVM_MEDIUM)

    uvm_config_db#(virtual wb_interface)  :: set(null, "*", "wb_vintf",  wb_intf) ;
    uvm_config_db#(virtual i2c_interface) :: set(null, "*", "i2c_vintf", i2c_intf);

    run_test("wb_i2c_base_test");
    $finish;
  end
endmodule