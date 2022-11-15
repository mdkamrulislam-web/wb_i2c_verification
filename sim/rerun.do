quit -sim
vlog -f filelist.f
vsim tb_top +UVM_TESTNAME=wb_wr_rd_test +UVM_VERBOSITY=UVM_NONE -do run.do -onfinish stop