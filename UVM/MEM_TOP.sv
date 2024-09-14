`timescale 1ns/1ps
`include"MEM_INTERFACE.sv"
import uvm_pkg::*;
import MEM_Package::*;

module  MEM_TOP;
parameter clk_period =10; 
bit clk;
//interface instantiation
MEM_INTERFACE intf(clk);

//dut instantiation
Memory  mem_dut(.CLK(clk),
                .Data_in(intf.Data_in),
                .Data_out(intf.Data_out),
                .Address(intf.Address),
                .EN(intf.EN),
                .RST(intf.RST),
                .W_R(intf.W_R),
                .valid_out(intf.valid_out)
                );
                
//clk triggering
initial begin
    clk=0;
    forever 
    begin
        #(clk_period/2) clk=~clk;
    end
end

initial begin
    uvm_config_db#(virtual MEM_INTERFACE)::set(null,"uvm_test_top","top2tast",intf);
    run_test("MEM_TEST");
end   
endmodule
