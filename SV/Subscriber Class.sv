class mem_coverage_collector;

//declare mailbox
mailbox #(MEM_Transaction) mon2sub;
//declare transactions  
MEM_Transaction tran_mon2sub;
//covergroup
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

//new construnctor
function  new(mailbox #(MEM_Transaction) mon2sub);
this.mon2sub = mon2sub;
cov  = new();
endfunction
//run task
task run();
forever begin
mon2sub.get(tran_mon2sub);
if(tran_mon2sub.inp_trans ==1)   //refer to it is input transaction
cov.sample();                    //sample the transaction
end
endtask:run
endclass:mem_coverage_collector