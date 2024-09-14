package mem_package;
  ////**************parameters**************//// 
    parameter  size_of_memory_location = 16;
    //parameter  clk_period =10;  //not shown on module
  ////******Include all the class files*****////
    `include "transaction Class.sv"
    `include "Sequencer Class.sv"
    `include "Driver Class.sv"
    `include "Monitor Class.sv"
    `include "Subscriber Class.sv"
    `include "Scoreboard Class.sv"
    `include "Env Class.sv"
endpackage