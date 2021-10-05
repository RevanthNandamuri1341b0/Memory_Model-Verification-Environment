/*
*Author : Revanth Sai Nandamuri
*GitHUB : https://github.com/RevanthNandamuri1341b0
*Date of update : 06 August 2021
*Time of update : 17:19
*Project name : MEMORY DUT VERIFICATION
*Domain : UVM
*Description : 
File Name : shutdown_sequence.sv
*File ID : 195462
*Modified by : #your name#
*/

class shutdown_sequence extends base_sequence;
    `uvm_object_utils(shutdown_sequence);
    bit[31:0]csr_dropped;
    function new(string name = "shutdown_sequence");
        super.new(name);
    endfunction: new

    extern virtual task body();
    
endclass: shutdown_sequence


task shutdown_sequence::body();
    `uvm_create(req);
    req.addr='h26;
    req.data='h0;
    req.mode=CFG_REG_READ;
    start_item(req);
    finish_item(req);
    csr_dropped=req.data;
    uvm_config_db#(bit[31:0])::set(get_sequencer(), "", "dropped_count", csr_dropped);
    `uvm_info("CONFIG_SEQ",$sformatf("csr_dropped_count=%0d",req.data),UVM_MEDIUM);
    `uvm_info("CONFIG_SEQ","Shutdown sequence Transaction Done ",UVM_MEDIUM);
endtask: body
