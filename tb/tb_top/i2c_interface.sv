interface i2c_interface(input bit CLK_I);
  logic RESET        ;
  tri1  TB_SDA       ;
  logic SDA_PADOEN_O ;
  logic SDA_PAD_O    ;
  tri1  SDA_PAD_I    ;

  tri1  TB_SCL       ;
  logic SCL_PADOEN_O ;
  logic SCL_PAD_O    ;
  tri1  SCL_PAD_I    ;

  assign TB_SDA    = (SDA_PADOEN_O === 0) ? SDA_PAD_O : 1'bZ;
  //assign SDA_PAD_I = (SDA_PADOEN_O === 1) ? TB_SDA    : ~TB_SDA;
  assign SDA_PAD_I = TB_SDA;

  assign TB_SCL    = (SCL_PADOEN_O === 0) ? SCL_PAD_O : 1'bZ;
  //assign SCL_PAD_I = (SCL_PADOEN_O === 1) ? TB_SCL    : ~TB_SCL;
  assign SCL_PAD_I = TB_SCL;
/*
  logic             SCL_PAD_I    ;
  logic             SCL_PAD_O    ;
  logic             SCL_PADOEN_O ;
  logic             SDA_PAD_I    ;
  logic             SDA_PAD_O    ;
  logic             SDA_PADOEN_O ;

  tri scl;
  tri sda;

  assign sda = i2c_intf.SDA_PADOEN_O ? 1'bz : i2c_intf.SDA_PAD_O;
  assign i2c_intf.SDA_PAD_I = sda;

  assign scl = i2c_intf.SCL_PADOEN_O ? 1'bz : i2c_intf.SCL_PAD_O;
  assign i2c_intf.SCL_PAD_I = scl;
*/
endinterface