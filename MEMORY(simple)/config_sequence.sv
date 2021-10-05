/*
*Author : Revanth Sai Nandamuri
*GitHUB : https://github.com/RevanthNandamuri1341b0
*Date of update : 06 August 2021
*Time of update : 13:44
*Project name : MEMORY DUT VERIFICATION
*Domain : UVM
*Description : 
File Name : config_sequence.sv
*File ID : 865667
*Modified by : #your name#
*/

class config_sequence extends base_sequence;
    `uvm_object_utils(config_sequence);

    function new(string name = "config_sequence");
        super.new(name);
    endfunction: new

    extern virtual task body();
    
endclass: config_sequence

task config_sequence::body();
    `uvm_create(req);
    req.addr='h20;
    req.data='h1;
    req.mode=CFG_REG_WRITE;
    start_item(req);
    finish_item(req);
    `uvm_info("CONFIG SEQ", "Config Sequence Transaction Started", UVM_MEDIUM)    
endtask: body
