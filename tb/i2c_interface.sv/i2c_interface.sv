interface i2c_interface(input bit WB_CLK_I);
  logic             SCL_PAD_I    ;
  logic             SCL_PAD_O    ;
  logic             SCL_PADOEN_O ;
  logic             SDA_PAD_I    ;
  logic             SDA_PAD_O    ;
  logic             SDA_PADOEN_O ;

  assign scl                   = (wb_i2c_intf.SCL_PADOEN_O == 0) ? wb_i2c_intf.SCL_PAD_O : 1'b1 ; 
  assign sda                   = (wb_i2c_intf.SDA_PADOEN_O == 0) ? wb_i2c_intf.SDA_PAD_O : 1'b1 ; 
  assign wb_i2c_intf.SCL_PAD_I = scl; 
  assign wb_i2c_intf.SDA_PAD_I = sda; 
endinterface