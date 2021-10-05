/*
*Author : Revanth Sai Nandamuri
*GitHUB : https://github.com/RevanthNandamuri1341b0
*Date of update : 06 August 2021
*Time of update : 13:43
*Project name : MEMORY DUT VERIFICATION
*Domain : UVM
*Description : 
File Name : base_sequence.sv
*File ID : 041868
*Modified by : #your name#
*/

class base_sequence extends uvm_sequence#(packet);
    int unsigned pkt_count;

`uvm_object_utils(base_sequence)

function new (string name="base_sequence");
	super.new(name);
	set_automatic_phase_objection(1);//uvm-1.2 only
endfunction

extern virtual task pre_start();
extern virtual task body();
endclass

task base_sequence::pre_start();
string str;
//below one is for when setting item_count at agent level in test
//uvm_sequencer_base sqr=get_sequencer(); 
  //if(!uvm_config_db #(int):: get(sqr.get_parent(),"","item_count",pkt_count))

//below one is for when setting item_count at sequence level in test
//  if(!uvm_config_db #(int):: get(null,this.get_full_name,"item_count",pkt_count))

  //below one is for when setting item_count at sequencer level in test
if(!uvm_config_db #(int):: get(this.get_sequencer(),"","item_count",pkt_count))
  begin
    `uvm_warning(get_full_name(),"Packet count is not set hence generating 1 transaction")
   pkt_count=1;
end
  
`uvm_info("PKT_CNT",$sformatf("Packet count in sequence=%0d",pkt_count),UVM_NONE)
  

  if ( uvm_config_db#(string)::get(null,"lucid_vlsi","testing",str))
    `uvm_info("Testing",$sformatf("Test string received in sequence=%0s",str),UVM_NONE)
    
endtask

task base_sequence::body();
      repeat(pkt_count) begin
       `uvm_do(req); 
      end
endtask

