/*
*Author : Revanth Sai Nandamuri
*GitHUB : https://github.com/RevanthNandamuri1341b0
*Date of update : 04 October 2021
*Project name : Verification of Memory Model using RAL Verification
*Domain : UVM
*Description : 
*File Name : reset_sequence.sv
*File ID : 797301
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
        req.addr='b0;
        req.data='b0;
        start_item(req);
        finish_item(req);
        `uvm_info("RESET", "RESET Transaction DONE", UVM_MEDIUM)
    end
endtask: body
