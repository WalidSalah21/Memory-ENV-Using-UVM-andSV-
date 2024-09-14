`timescale 1ns/1ns
/////**NOTE: import and include not defind inside a module and interface cann't defind inside package**/////
import mem_package::*; // Uncommented this line to import the package
`include "Interface.sv"
module MEM_top;
parameter  clk_period =10;
   bit clk;
   // Instantiate the MemoryInterface
    MemoryInterface I_F(clk);
   // Instantiate the Memory module
    Memory memory_inst (
       .Data_in(I_F.Data_in),
       .Address(I_F.Address),
       .EN(I_F.EN),
       .CLK(I_F.clk),
       .RST(I_F.RST),
       .W_R(I_F.W_R),
       .Data_out(I_F.Data_out),
       .valid_out(I_F.valid_out)
   );

   initial begin
        clk = 0;
        forever #(clk_period/2) clk = ~clk;
   end

   initial
   begin
    mem_env mem_env_inst;
    mem_env_inst =new(I_F);
    mem_env_inst.run();
   end
endmodule