class mem_driver;
//declare mailboxs
    mailbox #(MEM_Transaction) seq2drv;
//declare transactions   
    MEM_Transaction transaction;
//declare events
    event  driver_done;
//declare virtual interface    
    virtual  MemoryInterface mem_if;
//*************************************//
//**construnctor new**//    
extern  function new(mailbox #(MEM_Transaction) seq2drv ,virtual MemoryInterface mem_if, event driver_done);
//*************************************//
//**run task**//
 extern task run;
endclass:mem_driver

//*************************************//
//**construnctor new**//
function mem_driver::new(mailbox #(MEM_Transaction) seq2drv ,virtual MemoryInterface mem_if, event driver_done);
        this.seq2drv = seq2drv;
        this.driver_done = driver_done;
        this.mem_if = mem_if;
endfunction:new
//*************************************//
//**run task**//
task mem_driver::run;
    forever begin
    seq2drv.get(transaction);
    @(negedge mem_if.clk);
    $display("at time(%0t) :[DRIVER] ******transaction is %p",$realtime,transaction);
    mem_if.EN      <= transaction.EN;
    mem_if.RST     <= transaction.RST;
    mem_if.W_R     <= transaction.W_R;
    mem_if.Address <= transaction.Address;
    mem_if.Data_in <= transaction.Data_in;
    mem_if.set_inp_data <=1;               //to refer to Monitor i send input data
    ->driver_done;
    end
 endtask:run