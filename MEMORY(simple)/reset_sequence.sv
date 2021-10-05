/*
*Author : Revanth Sai Nandamuri
*GitHUB : https://github.com/RevanthNandamuri1341b0
*Date of update : 06 August 2021
*Time of update : 13:43
*Project name : MEMORY DUT VERIFICATION
*Domain : UVM
*Description : 
File Name : reset_sequence.sv
*File ID : 334015
*Modified by : #your name#
*/

class reset_sequence extends base_sequence;
    `uvm_object_utils(reset_sequence);

    function new(string name = "reset_sequence");
        super.new(name);
    endfunction: new
    extern virtual task body();
endclass: reset_sequence

task reset_sequence::body();
    begin
        `uvm_create(req);
        req.mode=RESET;
        start_item(req);
        finish_item(req);
        `uvm_info("RESET", "RESET Transaction DONE", UVM_MEDIUM)
    end
endtask: body
