interface i2c_interface(input bit WB_CLK_I);
  logic             SCL_PAD_I    ;
  logic             SCL_PAD_O    ;
  logic             SCL_PADOEN_O ;
  logic             SDA_PAD_I    ;
  logic             SDA_PAD_O    ;
  logic             SDA_PADOEN_O ;

  logic scl;
  logic sda;

  assign scl       = (SCL_PADOEN_O == 0) ? SCL_PAD_O : 1'b1 ; 
  assign sda       = (SDA_PADOEN_O == 0) ? SDA_PAD_O : 1'b1 ; 
  assign SCL_PAD_I = scl; 
  assign SDA_PAD_I = sda; 
endinterface