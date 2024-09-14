class MEM_Driver extends uvm_driver #(MEM_Transaction);
    `uvm_component_utils(MEM_Driver)

    // Constructor
    function new(string name = "MEM_Driver", uvm_component parent = null);
    super.new(name, parent);
    endfunction: new

    //create transaction object
    MEM_Transaction my_trans;

    //declare the virtual interface
    virtual MEM_INTERFACE vif;
    // Build function 
    function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    my_trans =MEM_Transaction::type_id::create("my_trans");
    
    if(!uvm_config_db #(virtual MEM_INTERFACE)::get(this, "", "driver2agent", vif))
    `uvm_fatal(get_full_name(), "[MEM_Monitor] vif not get")
    endfunction: build_phase

    // Connect function
    function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    endfunction: connect_phase

    // Task: run_phase
    task run_phase(uvm_phase phase);
        forever begin   
        seq_item_port.get_next_item(my_trans);
         @(negedge vif.clk);
        $display("at time(%0t) :[DRIVER] ******transaction is %p",$realtime,my_trans);
        vif.EN      <= my_trans.EN;
        vif.RST     <= my_trans.RST;
        vif.W_R     <= my_trans.W_R;
        vif.Address <= my_trans.Address;
        vif.Data_in <= my_trans.Data_in;
        vif.set_inp_data <=1;               //to refer to Monitor i send input data
        seq_item_port.item_done();
        end
    endtask: run_phase
endclass: MEM_Driver