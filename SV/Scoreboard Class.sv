class mem_scoreboard;
//declare the mailbox
mailbox #(MEM_Transaction) mon2sb;
//declare transactions  
MEM_Transaction tran_mon2sb;

logic [31:0] data_q[$];
bit          in_out;    // 0 for input, 1 for output

static logic [31:0] memory [0:15];   //declare memory to analogy the behavioural of DUT
//*************************************//
//**construnctor new**//
extern function new(mailbox #(MEM_Transaction) mon2sb);
//*************************************//
//**golden_model task**//
extern task golden_model(input logic EN,RST, W_R,[3:0] Address,[31:0] Data_in,input bit in_out);
//*************************************//
//**run task**//
extern task run;
endclass:mem_scoreboard


//*************************************//
//**construnctor new**//
function mem_scoreboard::new(mailbox #(MEM_Transaction) mon2sb);
    this.mon2sb = mon2sb;
endfunction:new

//*************************************//
//**golden_model task**//
task mem_scoreboard::golden_model(input logic EN,RST, W_R,[3:0] Address,[31:0] Data_in,input bit in_out);
if(!in_out) begin //case for input
    if(!RST) begin
        if(EN == 1) begin
            if(W_R == 0) begin
                memory[Address] = Data_in;
            end
            else begin
                this.data_q.push_back(memory[Address]);
                $display("[SCOREBOARD] /////////******the value of data_q is:%0h",memory[Address]);
                
            end
        end
    end
    else begin
        //*reset the memory*//
        //data_out = 32'h0;
        for(int i=0;i<16;i++) begin
            memory[i] = 32'h0;
        end
    end
end
endtask:golden_model

//*************************************//
//**run task**//
task mem_scoreboard::run;

        forever begin
            mon2sb.get(tran_mon2sb);
            $display("at time(%0t):[scoreboard] the value of transaction is equal : %p",$realtime,tran_mon2sb);
            $display("at time(%0t):[scoreboard] the value of valid_out : %0h",$realtime,tran_mon2sb.valid_out);
            if(tran_mon2sb.inp_trans)  //if inp_trans is 1 then it is input
            begin
                $display("[scoreboard] the inputs values is equal : %p",tran_mon2sb);
                in_out = 0;
                golden_model(tran_mon2sb.EN,tran_mon2sb.RST,tran_mon2sb.W_R,tran_mon2sb.Address,tran_mon2sb.Data_in,in_out);
            end
            else if(tran_mon2sb.valid_out ==1'b1)
            begin  // in case output is valid =1 then 
                $display("[scoreboard] the output values is equal : %p",tran_mon2sb);
                assert(tran_mon2sb.Data_out == this.data_q[0]) begin
                $display("at time(%0t): [scoreboard]************Data match************",$realtime);
                 $display("the value of tran_mon2sb.Data_out :%0d and this.data_q :%p",tran_mon2sb.Data_out,this.data_q);
                void'(this.data_q.delete(0)); 
                end
                else
                begin
                $display("at time(%0t): [scoreboard]************ Data mismatch***************",$realtime);
                $display("the value of tran_mon2sb.Data_out :%0d and this.data_q :%p",tran_mon2sb.Data_out,this.data_q);
                $stop;  //to found the errors 
                
                $display("[scoreboard]the inputs is : %p",tran_mon2sb);
                end
                
                end 
          end
endtask:run