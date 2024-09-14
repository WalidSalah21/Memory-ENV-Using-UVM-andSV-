class mem_env;

//declare the mailbox
mailbox #(MEM_Transaction) seq2drv,M2SB_mb ,M2SUB_mb;
//declare the virtual interface
virtual MemoryInterface mem_if;
//declare the  event
event driver_done;
//declare the class object
mem_sequancer seq;
mem_driver drv;
mem_monitor mon;
mem_scoreboard sb;
mem_coverage_collector cov;
//*************************************//
//**construnctor new**//
extern function new(virtual MemoryInterface mem_if);
//*************************************//
//**run task**//
extern task run();
endclass:mem_env

//*************************************//
//**construnctor new**//
function mem_env::new(virtual MemoryInterface mem_if);
    this.mem_if = mem_if;
    seq2drv = new();
    M2SB_mb = new();
    M2SUB_mb = new();
    seq = new(seq2drv,driver_done);
    drv = new(seq2drv,mem_if,driver_done);
    mon = new(mem_if,M2SB_mb,M2SUB_mb);
    sb = new(M2SB_mb);
    cov = new(M2SUB_mb);
endfunction:new

//*************************************//
//**run task**//
task mem_env::run();
    fork
        seq.run();
        drv.run();
        mon.run();
        sb.run();
        cov.run();
    join
endtask:run