class MEM_TEST extends uvm_test;
`uvm_component_utils(MEM_TEST)
// Constructor
function new(string name = "MEM_TEST", uvm_component parent = null);
super.new(name, parent);
endfunction: new

//declare the environment and sequence
MEM_env my_env;
MEM_Sequence my_seq;

//declare the interface
virtual MEM_INTERFACE vif;

//declare the build function
function void build_phase(uvm_phase phase);
super.build_phase(phase);
my_env = MEM_env::type_id::create("my_env", this);
my_seq = MEM_Sequence::type_id::create("my_seq", this);

if (
    !uvm_config_db #(virtual MEM_INTERFACE)::get(this,"", "top2tast", vif)
    ) begin
        `uvm_fatal(get_full_name(), "[MEM_TEST] vif not get");
end
    uvm_config_db #(virtual MEM_INTERFACE)::set(this, "my_env", "test2env", vif);
endfunction: build_phase

//declare the connect function
function void connect_phase(uvm_phase phase);
super.connect_phase(phase);

endfunction: connect_phase

// Task: run_phase
task run_phase(uvm_phase phase);
super.run_phase(phase);
phase.raise_objection(this);
$display("Starting the test");
my_seq.start(my_env.my_agent.m_sequencer);
phase.drop_objection(this);
$display("Ending the test");
endtask: run_phase

endclass: MEM_TEST

