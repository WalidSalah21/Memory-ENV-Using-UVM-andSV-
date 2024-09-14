package MEM_Package;
import uvm_pkg::*;
parameter size_of_memory_location=16; 
 `include"uvm_macros.svh"
 `include "MEM_seq_item.sv"
 `include "MEM_Sequancer.sv"
 `include "MEM_Driver.sv"   
 `include "MEM_Monitor.sv"
 `include "MEM_Agent.sv"
 `include "MEM_Scoreboard.sv"
 `include "MEM_coverage_collector.sv"
 `include "MEM_Sequance.sv"
 `include "MEM_ENV.sv"
 `include "MEM_TEST.sv"
endpackage
