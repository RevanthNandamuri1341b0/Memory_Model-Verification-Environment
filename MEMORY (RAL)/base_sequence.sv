/*
*Author : Revanth Sai Nandamuri
*GitHUB : https://github.com/RevanthNandamuri1341b0
*Date of update : 04 October 2021
*Project name : Verification of Memory Model using RAL Verification
*Domain : UVM
*Description : 
*File Name : base_sequence.sv
*File ID : 065383
*Modified by : #your name#
*/


class base_sequence extends uvm_sequence#(packet);
  int unsigned item_count;
  `uvm_object_utils(base_sequence)
  function new (string name="base_sequence");
    super.new(name);
    set_automatic_phase_objection(1);//uvm-1.2 only
  endfunction

  extern virtual task pre_start();
  extern virtual task body();
endclass

task base_sequence::pre_start();
if(!uvm_config_db #(int):: get(this.get_full_name(),"","item_count",item_count))
  begin
    `uvm_warning(get_full_name(),"Packet count is not set hence generating 1 transaction")
   item_count=10;
end
`uvm_info("PKT_CNT",$sformatf("Packet count in sequence=%0d",item_count),UVM_NONE)
endtask

task base_sequence::body();
  `uvm_do(req); 
endtask

//below one is for when setting item_count at agent level in test

//uvm_sequencer_base sqr=get_sequencer(); 
//if(!uvm_config_db #(int):: get(sqr.get_parent(),"","item_count",item_count))

//below one is for when setting item_count at sequencer level in test
//if(!uvm_config_db #(int):: get(this.get_sequencer(),"","item_count",item_count))

//below one is for when setting item_count at sequence level in test
//if(!uvm_config_db #(int):: get(null,this.get_full_name,"item_count",item_count))