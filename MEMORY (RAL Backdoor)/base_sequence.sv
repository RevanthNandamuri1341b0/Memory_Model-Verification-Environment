/*
*Author : Revanth Sai Nandamuri
*GitHUB : https://github.com/RevanthNandamuri1341b0
*Date of update : 05 October 2021
*Project name : Verification of Memory Model using RAL Verification with Backdoor access
*Domain : UVM
*Description : 
*File Name : base_sequence.sv
*File ID : 594297
*Modified by : #your name#
*/

class base_sequence extends uvm_sequence#(packet);
    
    int unsigned item_count;
    `uvm_object_utils(base_sequence);
    
    function new(string name = "base_sequence");
        super.new(name);
        set_automatic_phase_objection(1);//uvm 1.2 onwards
    endfunction: new
    
    extern virtual task pre_start();
    extern virtual task body();

endclass: base_sequence

task base_sequence::pre_start();
    if(!uvm_config_db#(int)::get(null, this.get_full_name, "item_count", item_count))
    begin
        `uvm_warning(get_full_name(), "Item Count not set")
        item_count = 10; 
    end
endtask: pre_start

task base_sequence::body();
    `uvm_do(req);
endtask: body


