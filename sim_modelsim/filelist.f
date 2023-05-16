+incdir+C:/intelFPGA/20.1/modelsim_ase/verilog_src/uvm-1.2/src/
C:/intelFPGA/20.1/modelsim_ase/verilog_src/uvm-1.2/src/uvm_pkg.sv

//+incdir+G:/ModelSim/modelsim_ase/verilog_src/uvm-1.2/src/
//G:/ModelSim/modelsim_ase/verilog_src/uvm-1.2/src/uvm_pkg.sv

+incdir+../rtl/
+incdir+../tb/test_lib/
+incdir+../tb/sequence_lib/
+incdir+../tb/env/
+incdir+../tb/agent/i2c_master/
+incdir+../tb/agent/wb_master/
+incdir+../tb/defines/

//RTL Files
// I2C Master
../rtl/i2c_master_bit_ctrl.v
../rtl/i2c_master_byte_ctrl.v
../rtl/i2c_master_top.v

// I2C Slave
../rtl/registerInterface.v
../rtl/serialInterface.v
../rtl/i2cSlave.v

// TB Files
../tb/defines/defines.sv
../tb/tb_top/i2c_interface.sv
../tb/tb_top/wb_interface.sv
../tb/agent/i2c_master/i2c_agent_pkg.sv
../tb/agent/wb_master/wb_agent_pkg.sv
../tb/sequence_lib/wb_i2c_seq_pkg.sv
../tb/env/wb_i2c_env_pkg.sv
../tb/test_lib/wb_i2c_test_pkg.sv
../tb/tb_top/tb_top.sv

+define+UVM_NO_DPI