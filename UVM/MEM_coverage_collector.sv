class MEM_coverage_collector extends uvm_subscriber #(MEM_Transaction);
`uvm_component_utils(MEM_coverage_collector)

//transaction object
MEM_Transaction tran_mon2sub;

//coverage group
covergroup cov;
ENABLE: coverpoint tran_mon2sub.EN { bins H_EN={1'd1};
                                     bins L_EN={1'd0};
                                    }
RESET: coverpoint tran_mon2sub.RST{ bins H_RST={1'd1};
                                    bins L_RST={1'd0};
                                  }
TRANS_RST:coverpoint tran_mon2sub.RST{bins trans_H2L=(1'd1 => 1'd0);
                                  }                                  
W_R: coverpoint tran_mon2sub.W_R{ bins H_W_R={1'd1};
                                  bins L_W_R={1'd0};
                                }
TRANS_W_R:coverpoint tran_mon2sub.W_R{
                                    bins trans_L2H=(1'd0 => 1'd1);
                                    }                               
ADDRESS: coverpoint tran_mon2sub.Address{bins low_add ={4'd0};
                                         bins med_add[]={[4'd1:4'd14]};
                                         bins high_add={4'd15};
                                        }  
DATA_IN: coverpoint tran_mon2sub.Data_in{bins low_data  ={32'h0};
                                         bins med_data  ={[32'h1:32'hfffffffe]};
                                         bins high_data ={32'hffffffff};
                               }                                                                                                           
check_check_W_R_all_addresses :cross ENABLE, W_R ,DATA_IN , ADDRESS ; //check read and write on all addresses
check_rst :cross RESET, ENABLE, W_R, ADDRESS ,DATA_IN ;  //check rst is domenant on all cases on the other values for variables
endgroup:cov

  // Constructor
  function new(string name = "MEM_coverage_collector", uvm_component parent = null);
  super.new(name, parent);
  cov  = new();
  endfunction: new

  //declare the build function
  function void build_phase(uvm_phase phase);
  super.build_phase(phase);
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
  function void write(MEM_Transaction t);
  tran_mon2sub =t;
  if(tran_mon2sub.inp_trans ==1)
  cov.sample();
  endfunction: write

endclass 
