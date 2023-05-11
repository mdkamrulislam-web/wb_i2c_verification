//////////////////////////////////////////////
// Start Condition Assertion using sequence //
//////////////////////////////////////////////
sequence START_SEQ;
  ((`TOP_WB_I2C_DUT.byte_controller.scl_i === 1'b1) && $fell(`TOP_WB_I2C_DUT.byte_controller.sda_i) && (`TOP_WB_I2C_DUT.byte_controller.start === 1'b1));
endsequence

property start_condition;
  @(negedge `TOP_WB_I2C_DUT.wb_clk_i) START_SEQ |-> ##[0:3] (`TOP_WB_I2C_DUT.byte_controller.bit_controller.busy === 1'b1);
endproperty

ASRST_START_CON_SEQUENCE : assert property(start_condition)
  `uvm_info("START_CONDITION_ASSERTION_PASSED_SEQUENCE",  $sformatf("Expected :: 1, Actual :: %0b", `TOP_WB_I2C_DUT.byte_controller.bit_controller.busy), UVM_NONE)
else
  `uvm_error("START_CONDITION_ASSERTION_FAILED_SEQUENCE", $sformatf("Expected :: 1, Actual :: %0b", `TOP_WB_I2C_DUT.byte_controller.bit_controller.busy))

///////////////////////////////////////////////////
// Start Condition Assertion using alsways block //
///////////////////////////////////////////////////
always @(`TOP_WB_I2C_DUT.byte_controller.start, negedge `TOP_WB_I2C_DUT.byte_controller.sda_i, `TOP_WB_I2C_DUT.byte_controller.scl_i) begin
  @(negedge `TOP_WB_I2C_DUT.byte_controller.sda_i);
  if ((`TOP_WB_I2C_DUT.byte_controller.scl_i === 1'b1) && (`TOP_WB_I2C_DUT.byte_controller.start === 1'b1)) begin
  repeat(4) @(negedge `TOP_WB_I2C_DUT.wb_clk_i);
  
  ASRST_START_CON_ALWAYS_BLOCK : assert(`TOP_WB_I2C_DUT.byte_controller.bit_controller.busy === 1'b1)
    `uvm_info("START_CONDITION_ASSERTION_PASSED_ALWAYS_BLOCK",  $sformatf("Expected :: 1, Actual :: %0b", `TOP_WB_I2C_DUT.byte_controller.bit_controller.busy), UVM_NONE)
  else
    `uvm_error("START_CONDITION_ASSERTION_FAILED_ALWAYS_BLOCK", $sformatf("Expected :: 1, Actual :: %0b", `TOP_WB_I2C_DUT.byte_controller.bit_controller.busy))
  end
end

/////////////////////////////////////////////
// Stop Condition Assertion using sequence //
/////////////////////////////////////////////
sequence STOP_SEQ;
  ((`TOP_WB_I2C_DUT.byte_controller.scl_i === 1'b1) && $rose(`TOP_WB_I2C_DUT.byte_controller.sda_i) && (`TOP_WB_I2C_DUT.byte_controller.stop === 1'b1));
endsequence

property stop_condition;
  @(negedge `TOP_WB_I2C_DUT.wb_clk_i) STOP_SEQ |-> ##[0:3] (`TOP_WB_I2C_DUT.byte_controller.bit_controller.busy === 1'b0);
endproperty

ASRST_STOP_CON_SEQUENCE : assert property(stop_condition)
  `uvm_info( "STOP_CONDITION_ASSERTION_PASSED_SEQUENCE", $sformatf("Expected :: 0, Actual :: %0b", `TOP_WB_I2C_DUT.byte_controller.bit_controller.busy), UVM_NONE)
else
  `uvm_error("STOP_CONDITION_ASSERTION_FAILED_SEQUENCE", $sformatf("Expected :: 0, Actual :: %0b", `TOP_WB_I2C_DUT.byte_controller.bit_controller.busy))

//////////////////////////////////////////////////
// Stop Condition Assertion using alsways block //
//////////////////////////////////////////////////
always @(`TOP_WB_I2C_DUT.byte_controller.stop, posedge `TOP_WB_I2C_DUT.byte_controller.sda_i, `TOP_WB_I2C_DUT.byte_controller.scl_i) begin
  @(posedge `TOP_WB_I2C_DUT.byte_controller.sda_i);
  if ((`TOP_WB_I2C_DUT.byte_controller.scl_i === 1'b1) && (`TOP_WB_I2C_DUT.byte_controller.stop === 1'b1)) begin
  repeat(4) @(negedge `TOP_WB_I2C_DUT.wb_clk_i);
  
  ASRST_STOP_CON_ALWAYS_BLOCK : assert(`TOP_WB_I2C_DUT.byte_controller.bit_controller.busy === 1'b0)
    `uvm_info( "STOP_CONDITION_ASSERTION_PASSED_ALWAYS_BLOCK", $sformatf("Expected :: 0, Actual :: %0b", `TOP_WB_I2C_DUT.byte_controller.bit_controller.busy), UVM_NONE)
  else
    `uvm_error("STOP_CONDITION_ASSERTION_FAILED_ALWAYS_BLOCK", $sformatf("Expected :: 0, Actual :: %0b", `TOP_WB_I2C_DUT.byte_controller.bit_controller.busy))
  end
end