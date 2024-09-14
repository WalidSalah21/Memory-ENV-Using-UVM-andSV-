class MEM_Monitor extends uvm_monitor;
`uvm_component_utils(MEM_Monitor)
// Constructor
function new(string name = "MEM_Monitor", uvm_component parent = null);
super.new(name, parent);
endfunction: new

//declare the interface
virtual MEM_INTERFACE vif;

//declare transaction 
MEM_Transaction my_trans;

//declare analysis port
uvm_analysis_port #(MEM_Transaction) port;

// Build function
function void build_phase(uvm_phase phase);
super.build_phase(phase);
port = new("port", this);
my_trans =MEM_Transaction::type_id::create("my_trans");

if(
        !uvm_config_db #(virtual MEM_INTERFACE)::get(this, "", "monitor2agent", vif)
  )
`uvm_fatal(get_full_name(), "[MEM_Monitor] vif not get")
endfunction: build_phase

// Connect function
function void connect_phase(uvm_phase phase);
super.connect_phase(phase);
endfunction: connect_phase

// Task: run_phase
task run_phase(uvm_phase phase);
        super.run_phase(phase);
        forever begin
        //sampling at negedge
         @(negedge vif.clk);
        //on both cases input or output transaction 
         wait ((vif.valid_out ==1) || (vif.set_inp_data ==1));
        if(vif.valid_out ==1)          //recieved output
        begin
                 my_trans =MEM_Transaction::type_id::create("my_trans");
                 my_trans.Data_out    = vif.Data_out;   //her "<=" make all values =0 ???????
                 my_trans.valid_out   = vif.valid_out;
                 //send to SB and SUB
                 port.write(my_trans);
                ;
                 #2ns; //this arbitary delay in case both condition right on th same time            
        end
        /*else if do mismatching*/
        if(vif.set_inp_data ==1)  //recieved input 
        begin
                 //$display("at time(%0t):[MONITOR] recieved from monitor input :%p", $realtime,MON_transaction);
                my_trans =MEM_Transaction::type_id::create("my_trans");
                vif.set_inp_data  =0;                    //rst the flag
                my_trans.inp_trans    =1;                //refer to it is input transaction
                my_trans.RST     = vif.RST;              //her "<=" make all values =0 ???????
                my_trans.EN      = vif.EN;
                my_trans.W_R     = vif.W_R;
                my_trans.Address = vif.Address;
                my_trans.Data_in = vif.Data_in; 
                 $display("at time(%0t):[MONITOR] recieved from monitor input :%p", $realtime,my_trans);
                //send to SB and SUB
                 port.write(my_trans);
        end   
end
endtask: run_phase
endclass: MEM_Monitor
