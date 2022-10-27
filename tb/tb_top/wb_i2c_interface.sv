interface wb_i2c_interface(input bit WB_CLK_I);
  logic             WB_RST_I     ;
  logic             ARST_I       ;
  logic    [2:0]    WB_ADR_I     ;
  logic    [7:0]    WB_DAT_I     ;
  logic    [7:0]    WB_DAT_O     ;
  logic             WB_WE_I      ;
  logic             WB_STB_I     ;
  logic             WB_CYC_I     ;
  logic             WB_ACK_O     ;
  logic             WB_INTA_O    ;
  logic             SCL_PAD_I    ;
  logic             SCL_PAD_O    ;
  logic             SCL_PADOEN_O ;
  logic             SDA_PAD_I    ;
  logic             SDA_PAD_O    ;
  logic             SDA_PADOEN_O ;
endinterface