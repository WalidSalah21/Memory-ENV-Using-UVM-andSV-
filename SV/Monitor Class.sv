class mem_monitor;
//declare mailboxs
    mailbox #(MEM_Transaction) M2SB_mb ,M2SUB_mb;
//declare transactions    
    MEM_Transaction MON_transaction;
//declare virtual interface     
    virtual MemoryInterface mem_if;
//*************************************//
//**construnctor new**//     
extern  function new(virtual MemoryInterface mem_if,mailbox #(MEM_Transaction) M2SB_mb ,mailbox #(MEM_Transaction) M2SUB_mb);
//*************************************//
//**run task**//        
extern task run;
endclass:mem_monitor

//*************************************//
//**construnctor new**// 
function mem_monitor::new(virtual MemoryInterface mem_if,mailbox #(MEM_Transaction) M2SB_mb ,mailbox #(MEM_Transaction) M2SUB_mb);
        this.mem_if = mem_if;
        this.M2SB_mb = M2SB_mb;
        this.M2SUB_mb = M2SUB_mb;
endfunction:new
//*************************************//
//**run task**//
task mem_monitor::run;
    int i=0; //counter

    forever begin
        //sampling at negedge
         @(negedge mem_if.clk);
        //on both cases input or output transaction 
         wait ((mem_if.valid_out ==1) || (mem_if.set_inp_data ==1));
        if(mem_if.valid_out ==1)          //recieved output
        begin
                 MON_transaction = new();
                 MON_transaction.Data_out    = mem_if.Data_out;   //her "<=" make all values =0 ???????
                 MON_transaction.valid_out   = mem_if.valid_out;
                 $display("at time(%0t):[MONITOR] recieved from monitor output :%p", $realtime,MON_transaction);
                 //send to SB and SUB
                 M2SB_mb.put(MON_transaction);
                 M2SUB_mb.put(MON_transaction);
                 #1ns; //this arbitary delay in case both condition right on th same time            
        end
        /*else if do mismatching*/
        if(mem_if.set_inp_data ==1)  //recieved input 
        begin
                 //$display("at time(%0t):[MONITOR] recieved from monitor input :%p", $realtime,MON_transaction);
                MON_transaction = new();
                mem_if.set_inp_data  =0;                        //rst the flag
                MON_transaction.inp_trans    =1;                //refer to it is input transaction
                MON_transaction.RST     = mem_if.RST;           //her "<=" make all values =0 ???????
                MON_transaction.EN      = mem_if.EN;
                MON_transaction.W_R     = mem_if.W_R;
                MON_transaction.Address = mem_if.Address;
                MON_transaction.Data_in = mem_if.Data_in; 
                 $display("at time(%0t):[MONITOR] recieved from monitor input :%p", $realtime,MON_transaction);
                M2SB_mb.put(MON_transaction);
                M2SUB_mb.put(MON_transaction);
        end   
    end
endtask:run


/////////////*************another wrong method*************/////////////
 /*fork

            
            begin
                @(posedge mem_if.clk);
                wait(mem_if.valid_out ==1);
                 $display("at time(%0t):[MONITOR] recieved new output on monitor", $realtime);
                 MON_transaction.Data_out    = mem_if.Data_out;
                 MON_transaction.valid_out   = mem_if.valid_out;
                 tran2sub.Data_out   = mem_if.Data_out;
                 tran2sub.valid_out  = mem_if.valid_out;
                 $display("at time(%0t):[MONITOR] recieved from monitor output :%p", $realtime,MON_transaction);
                 M2SB_mb.put(MON_transaction);
                 M2SUB_mb.put(MON_transaction);
                 #4ns;
                 $display("at time(%0t):[MONITOR] sent to scoreboard", $realtime);
            end
            //**sample inputs from the memory interface**/
            /*begin  
                @(posedge mem_if.clk);
                wait( mem_if.set_inp_data ==1) ; 
                mem_if.set_inp_data  =0;
                MON_transaction.inp_trans    =1;
                MON_transaction.RST     = mem_if.RST;          //her "<=" make all values =0 ???????
                MON_transaction.EN      = mem_if.EN;
                MON_transaction.W_R     = mem_if.W_R;
                MON_transaction.Address = mem_if.Address;
                MON_transaction.Data_in = mem_if.Data_in; 
                /*$display("at time(%0t):[MONITOR] recieved from monitor input mem_if.RST :%d", $realtime,MON_transaction.RST);
                $display("at time(%0t):[MONITOR] recieved from monitor input mem_if.EN :%d", $realtime,MON_transaction.EN);
                $display("at time(%0t):[MONITOR] recieved from monitor input mem_if.W_R :%d", $realtime,MON_transaction.W_R);
                $display("at time(%0t):[MONITOR] recieved from monitor input mem_if.Address :%d", $realtime,MON_transaction.Address);
                $display("at time(%0t):[MONITOR] recieved from monitor input mem_if.Data_in :%d", $realtime,MON_transaction.RST);*/

               /* $display("at time(%0t):[MONITOR] recieved from monitor input :%p", $realtime,MON_transaction);
                M2SB_mb.put(MON_transaction);
                M2SUB_mb.put(MON_transaction); 
                $display("at time(%0t):[MONITOR] sent to scoreboard", $realtime);                    
            end
           join_any*/