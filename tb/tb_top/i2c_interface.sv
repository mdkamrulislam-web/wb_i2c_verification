interface i2c_interface(input bit CLK_I);
  logic             SCL_PAD_I    ;
  logic             SCL_PAD_O    ;
  logic             SCL_PADOEN_O ;
  wire              SDA_PAD_I    ;
  logic             SDA_PAD_O    ;
  logic             SDA_PADOEN_O ;

  wire scl;
  wire sda;

  //assign sda = i2c_intf.SDA_PADOEN_O ? 1'bz : i2c_intf.SDA_PAD_O;
  //assign i2c_intf.SDA_PAD_I = sda;
  //pullup(sda);

  //assign scl = i2c_intf.SCL_PADOEN_O ? 1'bz : i2c_intf.SCL_PAD_O;
  //assign i2c_intf.SCL_PAD_I = scl;
  //pullup(scl);

endinterface