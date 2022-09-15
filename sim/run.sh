echo "WISHBONE TO I2C";

## DELETING UNNECESSARY FILES AND FOLDER
if [ -d "INCA_libs" ];
	then rm -r INCA_libs;
	echo "INCA_libs is deleted!";
fi

rm filelist.f~;

## RUNNING SIMULATION WITH DIFFERENT FUNCTIONALITIES
SIM_MODE=$1;
TEST_NAME=$2;
VERBOSITY=$3;


if [[ "$SIM_MODE" == "gui" ]];
	then 
			irun -timescale 1ns/1ps -f filelist.f -access +rwc -uvm +UVM_TESTNAME="$TEST_NAME" +UVM_VERBOSITY=UVM_$VERBOSITY -gui -append_log;
			echo "SIMULATION IS COMPLETED IN GUI MODE.";

elif [[ "$SIM_MODE" == "cov" ]];
	then
		
			irun -timescale 1ns/1ps -f filelist.f -access +rwc -uvm +UVM_TESTNAME="$TEST_NAME" +UVM_VERBOSITY=UVM_$VERBOSITY -coverage all -covtest "$TEST_NAME" -append_log;
			echo "SIMULATION IS COMPLETED WITH COVERAGE.";

elif [[ "$SIM_MODE" == "batch" ]];
	then
			irun -timescale 1ns/1ps -f filelist.f -access +rwc -uvm +UVM_TESTNAME="$TEST_NAME" +UVM_VERBOSITY=UVM_$VERBOSITY -append_log;
			echo "SIMULATION IS COMPLETED IN BATCH MODE.";
	else 
			echo "Nothing Happened!";
fi

#clear