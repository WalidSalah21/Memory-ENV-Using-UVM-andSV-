class MEM_Scoreboard extends uvm_scoreboard;
`uvm_component_utils(MEM_Scoreboard)

logic [31:0] data_q[$];
bit          in_out;    // 0 for input, 1 for output

static logic [31:0] memory [0:15];   //declare memory to analogy the behavioural of DUT

// Constructor
function new(string name = "MEM_Scoreboard", uvm_component parent = null);
super.new(name, parent);
endfunction: new

//declare the analysis imp
uvm_analysis_imp #(MEM_Transaction, MEM_Scoreboard) imp;

//declare the build function
function void build_phase(uvm_phase phase);
super.build_phase(phase);
imp = new("imp", this);
endfunction: build_phase

//declare the connect function
function void connect_phase(uvm_phase phase);
super.connect_phase(phase);
endfunction: connect_phase

// Task: run_phase
task run_phase(uvm_phase phase);
super.run_phase(phase);
endtask: run_phase

//write function
function void write(MEM_Transaction tran_mon2sb  );

            $display("at time(%0t):[scoreboard] the value of transaction is equal : %p",$realtime,tran_mon2sb);
            $display("at time(%0t):[scoreboard] the value of valid_out : %0h",$realtime,tran_mon2sb.valid_out);
            if(tran_mon2sb.inp_trans)  //if inp_trans is 1 then it is input
            begin
                $display("[scoreboard] the inputs values is equal : %p",tran_mon2sb);
                in_out = 0;
                golden_model(tran_mon2sb.EN,tran_mon2sb.RST,tran_mon2sb.W_R,tran_mon2sb.Address,tran_mon2sb.Data_in,in_out);
                $display("[scoreboard] the output of tran_mon2sb.valid_out  : %0d",tran_mon2sb.valid_out);
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
endfunction: write

//*************************************//
//**golden_model task**//
task golden_model(input logic EN,RST, W_R,[3:0] Address,[31:0] Data_in,input bit in_out);
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
        for(int i=0;i<16;i++) begin
            memory[i] = 32'h0;
        end
    end
end
endtask:golden_model


endclass: MEM_Scoreboard
