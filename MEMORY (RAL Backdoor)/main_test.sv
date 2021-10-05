/*
*Author : Revanth Sai Nandamuri
*GitHUB : https://github.com/RevanthNandamuri1341b0
*Date of update : 05 October 2021
*Project name : Verification of Memory Model using RAL Verification with Backdoor access
*Domain : UVM
*Description : 
*File Name : main_test.sv
*File ID : 539761
*Modified by : #your name#
*/

class main_test extends base_test;
    `uvm_component_utils(main_test)
    
        function new (string name="main_test",uvm_component parent=null);
            super.new(name,parent);
        endfunction
    
        extern virtual function void build_phase(uvm_phase phase);
  endclass	
    
function void main_test::build_phase(uvm_phase phase);
  super.build_phase(phase);  
  uvm_config_db#(int)::set(this,"env.m_agent.seqr", "item_count", 30);
  uvm_config_db#(uvm_object_wrapper)::set(this,"env.m_agent.seqr.reset_phase","default_sequence",reset_sequence::get_type());
  uvm_config_db#(uvm_object_wrapper)::set(this,"env.m_agent.seqr.configure_phase","default_sequence",config_sequence::get_type());
  uvm_config_db#(uvm_object_wrapper)::set(this,"env.m_agent.seqr.main_phase","default_sequence",rw_sequence::get_type());
endfunction