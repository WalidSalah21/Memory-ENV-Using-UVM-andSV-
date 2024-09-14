interface MemoryInterface(input logic clk);
    // Declare logic signals for inputs
    logic [31:0] Data_in;
    logic [3:0] Address;
    logic EN;
    logic RST;
    logic W_R; // 0 for write, 1 for read
    logic set_inp_data;

    // Declare logic signals for outputs
    logic [31:0] Data_out;
    logic valid_out;
endinterface