class MEM_Sequence extends uvm_sequence;
`uvm_object_utils(MEM_Sequence)

//*************************************//
///**declare my_trans object**///  
MEM_Transaction my_trans;

//*************************************//
///**Constructor**/// 
extern function new(string name = "MEM_Sequence");
   
//*************************************//
/////////****body task****/////////
extern task body();

//*************************************//
///**Task for Test RST at first time**///
extern task RST();

//**********************************************//
////****read_n_number****////
extern task read_n_number(input int num_to_read);

//**********************************************//
////****write_n_number****////    
extern task write_n_number(input int num_to_write);    
  
//**********************************************//
////****rand_task****////     
extern task rand_task(input int num_to_rand); 
endclass: MEM_Sequence


////////////////////////////// 
/////**** Constructor****/////
function MEM_Sequence::new(string name = "MEM_Sequence");
    super.new(name);
    endfunction: new

////////////////////////////// 
/////////****body****/////////
 task MEM_Sequence::body();
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
endtask: body


//*************************************//
///**Task for Test RST at first time**///
task MEM_Sequence::RST();
my_trans=MEM_Transaction::type_id::create("my_trans");
start_item(my_trans);
my_trans.RST.rand_mode(0);     //I put it as without it rst will be randomize on the next step 
my_trans.RST = 1;              //set RST to 1 and will not affect by the randomize
assert(my_trans.randomize());  //randomize the my_trans
$display("at time(%0t): [SQEUANCER] the randomized my_trans RST :%p",$realtime,my_trans);
finish_item(my_trans); 

///////////////////////////////////////////////////////////////
///****this iteration to fall the RST with the same task****///
my_trans=MEM_Transaction::type_id::create("my_trans");
start_item(my_trans);
//my_trans.RST.rand_mode(0);     //I put it as without it rst will be randomize on the next step 
my_trans.RST = 0;              //set RST to 1 and will not affect by the randomize
my_trans.EN  = 0;
assert(my_trans.randomize(Address,Data_in,W_R));  //randomize the my_trans
$display("at time(%0t): [SQEUANCER] the randomized my_trans RST :%p",$realtime,my_trans);
finish_item(my_trans); 
my_trans.RST.rand_mode(1);
 $display("at time(%0t):[SQEUANCER] Driver Done on RST check",$realtime);
endtask:RST


//********************************************//
//*Task to write with certain number to task*//
task MEM_Sequence::write_n_number(input int num_to_write);
    int i =0;
    my_trans=MEM_Transaction::type_id::create("my_trans");
    repeat(num_to_write) begin
    start_item(my_trans);
    /*initial values for do the functionality of the task without the randomization*/
    my_trans.EN  = 1;
    my_trans.W_R = 0;
    my_trans.RST = 0;
    assert(my_trans.randomize(Address,Data_in));
    $display("[SQEUANCER] the randomized transaction on write_n_number task :%p",my_trans);
    finish_item(my_trans); 
    $display("[SQEUANCER] send to driver number : %0d on write_n_number task ",i);
    i++;
    end 
    /*change the inputs after finish the required function from task*/
    my_trans=MEM_Transaction::type_id::create("my_trans");
    start_item(my_trans);
    my_trans.EN = 0;
    my_trans.W_R = 0;
    my_trans.RST=0;
    assert(my_trans.randomize(Address,Data_in));
    finish_item(my_trans); 
endtask:write_n_number

//********************************************//
//**Task to read with certain number to task**//
task MEM_Sequence::read_n_number(input int num_to_read);
int i =0;
        repeat(num_to_read) begin
        my_trans=MEM_Transaction::type_id::create("my_trans");
        start_item(my_trans);
        /*initial values for do the functionality of the task without the randomization*/
        my_trans.EN = 1;
        my_trans.W_R = 1;
        my_trans.RST=0;
        assert(my_trans.randomize(Address,Data_in));
        $display("at time(%0t): [SQEUANCER] send to driver no to read on read_n_number task: %0d",$time,i);
       // if(my_trans.W_R)
        //$stop;
        finish_item(my_trans); 
        $display("at time(%0t): [SQEUANCER] Driver Done****",$time);
        i++;
    end
    /****this iteration to fall the valid_out from the inputs****/ 
    my_trans=MEM_Transaction::type_id::create("my_trans");
    start_item(my_trans);
    my_trans.EN = 0;
    my_trans.W_R = 0;
    my_trans.RST=0;
    assert(my_trans.randomize(Address,Data_in));
    finish_item(my_trans); 
endtask:read_n_number

 task MEM_Sequence::rand_task(input int num_to_rand); 

 for(int i=0;i<num_to_rand;i++) begin
    my_trans=MEM_Transaction::type_id::create("my_trans");
    start_item(my_trans);
    assert(my_trans.randomize());
    finish_item(my_trans);  
 end

 /****this iteration to fall the valid_out from the inputs****/ 
    my_trans=MEM_Transaction::type_id::create("my_trans");
    start_item(my_trans);
    my_trans.EN = 0;
    my_trans.W_R = 0;
    my_trans.RST=0;
    assert(my_trans.randomize(Address,Data_in));
    finish_item(my_trans); 
 endtask:rand_task

