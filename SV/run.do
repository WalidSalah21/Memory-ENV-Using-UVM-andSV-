
Vlog Memory.v pack_file.sv Tbench.sv +cover
vsim MEM_top -novopt -coverage -suppress 12110 
run -all; coverage report -codeAll -cvg -output coverage_rpt.txt

