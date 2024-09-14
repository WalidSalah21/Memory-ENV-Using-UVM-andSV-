class mem_sequancer;
//declare mailboxs
 mailbox #(MEM_Transaction) seq2drv;
//declare memory transaction 
 MEM_Transaction transaction;
//declare events 
 event  driver_done;

//*************************************//
//constructor function 
extern function new(mailbox #(MEM_Transaction) seq2drv , event driver_done);
//*************************************//
///**Task for Test RST at first time**///
extern task RST();
//*************************************//
//**run task**//
extern task run();
//**********************************************//
////****read_n_number****////
extern task read_n_number(input int num_to_read);
//**********************************************//
////****write_n_number****////
extern task write_n_number(input int num_to_write);
//**********************************************//
////****rand_task****////     
extern task rand_task(input int num_to_rand); 
endclass:mem_sequancer

//constructor function 
function mem_sequancer::new(mailbox #(MEM_Transaction) seq2drv , event driver_done);
    this.seq2drv     = seq2drv;
    this.driver_done = driver_done;
endfunction:new

//*************************************//
///**Task for Test RST at first time**///
task mem_sequancer::RST();
transaction = new();
transaction.RST.rand_mode(0);     //I put it as without it rst will be randomize on the next step 
transaction.RST = 1;              //set RST to 1 and will not affect by the randomize
assert(transaction.randomize());  //randomize the transaction
//transaction.RST.rand_mode(1);
$display("at time(%0t): [SQEUANCER] the randomized transaction RST :%p",$realtime,transaction);
seq2drv.put(transaction);
@(driver_done);

///////////////////////////////////////////////////////////////
///****this iteration to fall the RST with the same task****///
transaction = new();
//transaction.RST.rand_mode(0);     //I put it as without it rst will be randomize on the next step 
transaction.RST = 0;              //set RST to 1 and will not affect by the randomize
transaction.EN  = 0;
assert(transaction.randomize(Address,Data_in,W_R));  //randomize the transaction
//transaction.RST.rand_mode(1);
$display("at time(%0t): [SQEUANCER] the randomized transaction RST :%p",$realtime,transaction);
seq2drv.put(transaction);
@(driver_done);
 $display("at time(%0t):[SQEUANCER] Driver Done on RST check",$realtime);
endtask:RST

//*************************************//
//**run task**//
task mem_sequancer::run;
int i =0;
int num_2_rand;
///**test rst at first time **///
#10;
RST();     
///**test read all memory sequencially**///
read_n_number(size_of_memory_location);

//test write all memory sequencially
write_n_number(size_of_memory_location);
//test read all memory sequencially
read_n_number(size_of_memory_location);

//rand task to test the randomization of the transaction
num_2_rand =$urandom_range(100000,50000);
rand_task(num_2_rand);
#100;
$stop;
endtask:run

//********************************************//
//**Task to read with certain number to task**//
task mem_sequancer::read_n_number(input int num_to_read);
int i =0;
        repeat(num_to_read) begin
        transaction = new();
        /*initial values for do the functionality of the task without the randomization*/
        transaction.EN = 1;
        transaction.W_R = 1;
        transaction.RST=0;
        assert(transaction.randomize(Address,Data_in));
        seq2drv.put(transaction);
        $display("at time(%0t): [SQEUANCER] send to driver no to read on read_n_number task: %0d",$time,i);
        @(driver_done);
        $display("at time(%0t): [SQEUANCER] Driver Done",$time);
        i++;
    end
    /****this iteration to fall the valid_out from the inputs****/ 
    transaction = new();
    transaction.EN = 0;
    transaction.W_R = 0;
    transaction.RST=0;
    assert(transaction.randomize(Address,Data_in));
    seq2drv.put(transaction);
    @(driver_done);
endtask:read_n_number

//********************************************//
//*Task to write with certain number to task*//
task mem_sequancer::write_n_number(input int num_to_write);
    int i =0;
    /*initial values for do the functionality of the task without the randomization*/
    transaction.EN  = 1;
    transaction.W_R = 0;
    transaction.RST = 0;
    repeat(num_to_write) begin
        assert(transaction.randomize(Address,Data_in));
        $display("[SQEUANCER] the randomized transaction on write_n_number task :%p",transaction);
        seq2drv.put(transaction);
        $display("[SQEUANCER] send to driver number : %0d on write_n_number task ",i);
        @(driver_done);
        i++;
    end 
    /*change the inputs after finish the required function from task*/
    transaction = new();
    transaction.EN = 0;
    transaction.W_R = 0;
    transaction.RST=0;
    assert(transaction.randomize(Address,Data_in));
    seq2drv.put(transaction);
    @(driver_done);
endtask:write_n_number

//**********************************************//
////****rand_task****////    
task mem_sequancer::rand_task(input int num_to_rand); 

 for(int i=0;i<num_to_rand;i++) begin
    transaction = new();
    assert(transaction.randomize());
    seq2drv.put(transaction);
    @(driver_done);
 end
///////////////////////////////////////////////////////////////
/****this iteration to fall the valid_out from the inputs****/ 
    transaction = new();
    transaction.EN = 0;
    transaction.W_R = 0;
    transaction.RST=0;
    assert(transaction.randomize(Address,Data_in));
    seq2drv.put(transaction);
    @(driver_done);
 endtask:rand_task