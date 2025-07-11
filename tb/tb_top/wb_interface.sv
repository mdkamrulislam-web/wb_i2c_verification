interface wb_interface(input bit WB_CLK_I);
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
endinterface