/*
*Author : Revanth Sai Nandamuri
*GitHUB : https://github.com/RevanthNandamuri1341b0
*Date of update : 05 October 2021
*Project name : Verification of Memory Model using RAL Verification with Backdoor access
*Domain : UVM
*Description : 
*File Name : rw_sequence.sv
*File ID : 965384
*Modified by : #your name#
*/

class rw_sequence extends base_sequence;
    `uvm_object_utils(rw_sequence);

    function new(string name = "rw_sequence");
        super.new(name);
    endfunction: new

    extern virtual task body();

endclass: rw_sequence

task rw_sequence::body();
    bit[31:0] count;
    REQ ref_pkt;
    ref_pkt = packet::type_id::create("ref_pkt",,get_full_name());
    repeat(item_count)
    begin
        `uvm_create(req);
        assert(ref_pkt.randomize());
        req.copy(ref_pkt);
        start_item(req);
        finish_item(req);
        get_response(rsp);
        count++;
        `uvm_info("RW_SEQ",$sformatf("Transaction %0d Done with resp=%0s ",count,rsp.slv_rsp.name()),UVM_MEDIUM);        
    end
endtask: body

