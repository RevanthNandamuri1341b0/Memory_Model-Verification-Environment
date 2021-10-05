/*
*Author : Revanth Sai Nandamuri
*GitHUB : https://github.com/RevanthNandamuri1341b0
*Date of update : 04 October 2021
*Project name : Verification of Memory Model using RAL Verification
*Domain : UVM
*Description : 
*File Name : base_test.sv
*File ID : 220689
*Modified by : #your name#
*/

class base_test extends uvm_test;
  `uvm_component_utils(base_test);

  environment env;
  virtual memory_if.tb mvif;
  virtual memory_if.tb_mon_in vif_min;
  virtual memory_if.tb_mon_out vif_mout;

  function new(string name = "base_test", uvm_component parent);
      super.new(name, parent);
  endfunction: new

  extern virtual function void build_phase(uvm_phase phase);
  extern virtual task main_phase(uvm_phase phase);
      
endclass: base_test

function void base_test::build_phase(uvm_phase phase);
  super.build_phase(phase);

  env=environment::type_id::create("env",this);

  uvm_config_db#(virtual memory_if.tb)::get(this,"","master_if",mvif);
  uvm_config_db#(virtual memory_if.tb_mon_in)::get(this,"","mon_in",vif_min);
  uvm_config_db#(virtual memory_if.tb_mon_out)::get(this,"","mon_out",vif_mout);

  uvm_config_db#(virtual memory_if.tb)::set(this,"env.m_agent","drvr_if",mvif);
  uvm_config_db#(virtual memory_if.tb_mon_in)::set(this,"env.m_agent","iMon_if",vif_min);
  uvm_config_db#(virtual memory_if.tb_mon_out)::set(this,"env.s_agent","oMon_if",vif_mout);

  uvm_config_db#(uvm_object_wrapper)::set(this,"env.m_agent.seqr.main_phase","default_sequence",base_sequence::get_type());

endfunction

task base_test::main_phase (uvm_phase phase);
  uvm_objection objection;
  super.main_phase(phase);
  objection=phase.get_objection();
  objection.set_drain_time(this,100ns);
endtask
