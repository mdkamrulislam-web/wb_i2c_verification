#! /bin/bash

if [ -d "cov_work" ];
	then rm -r cov_work;
	echo "cov_work is deleted!";
fi

fileName="test_name.txt";

if [[ -f "$fileName" ]];
	then
		while IFS="" read -r line
				do
					#echo "$line";
					bash run.sh cov $line NONE;
				done < $fileName

	else
		echo "The $fileName doesn't exist."
fi

imc -execcmd "merge -runfile test_name.txt -out merged_results"
#imc -execcmd "merge seq_wr_rd con_wr_rd -out merged_results"
#imc -load /home/MD220208/kamrul_work/uvm/apb/apb_slv_memory/sim/cov_work/scope/merged_results &