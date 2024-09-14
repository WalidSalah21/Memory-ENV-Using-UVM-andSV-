class MEM_Transaction extends uvm_sequence_item;
`uvm_object_utils(MEM_Transaction)
// function new
function new(string name = "MEM_Transaction");
super.new(name);
endfunction: new

//inputs to dut
    rand  bit EN;
    rand  bit RST;
    rand  bit W_R; // 0 for write, 1 for read
    randc bit [3:0] Address;
    rand  bit [31:0] Data_in;
    bit  inp_trans; //refer to the transaction is input transaction

    //outputs from dut
    bit valid_out;
    bit [31:0] Data_out;

    constraint c1 {RST  dist {0:=50, 1:=1};}  // 50% chance of RST being 0
    constraint c2 {Data_in  dist {0:=1,[32'h1 : 32'hfffffffe]:/1,32'hffffffff:=1};}  // 1% chance of Data_in being 0, 1% chance of Data_in being 0xffffffff
    constraint c3 {EN  dist {0:=1, 1:=1};}  // 50% chance of W_R being 0


endclass: MEM_Transaction

