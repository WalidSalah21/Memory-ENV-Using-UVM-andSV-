class MEM_Sequencer extends uvm_sequencer #(MEM_Transaction);
    `uvm_component_utils(MEM_Sequencer)
    // Constructor
    function new(string name = "MEM_Sequencer", uvm_component parent = null);
    super.new(name, parent);
    endfunction: new

    // Build function 
    function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    endfunction: build_phase

    // Connect function
    function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    endfunction: connect_phase

    // Task: run_phase
    task run_phase(uvm_phase phase);
    super.run_phase(phase);
    endtask: run_phase 
endclass: MEM_Sequencer
