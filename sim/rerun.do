quit -sim
vlog -f filelist.f
##vsim tb_top +UVM_TESTNAME=i2c_transmit_test +UVM_VERBOSITY=UVM_LOW -do run.do -onfinish stop
##vsim -batch tb_top +UVM_TESTNAME=i2c_transmit_test +UVM_VERBOSITY=UVM_LOW -do run.do -onfinish stop
vsim tb_top +UVM_TESTNAME=i2c_transmit_test +UVM_VERBOSITY=UVM_LOW -do run.do -onfinish stop