/*
*Author : Revanth Sai Nandamuri
*GitHUB : https://github.com/RevanthNandamuri1341b0
*Date of update : 05 October 2021
*Project name : Verification of Memory Model using RAL Verification with Backdoor access
*Domain : UVM
*Description : 
*File Name : packet.sv
*File ID : 079874
*Modified by : #your name#
*/

`define AWIDTH 8
`define DWIDTH 32

//  Class: packet
//
class packet extends uvm_sequence_item;

    rand logic [`AWIDTH-1:0] addr;
    rand logic [`DWIDTH-1:0] data;

    op_type mode;
    slv_response_type slv_rsp;

    bit [`AWIDTH-1:0] prev_addr;
    bit [`DWIDTH-1:0] prev_data;

    constraint valid
    {
        data inside {[10:9999]};
        addr inside {[0:15]};
        data != prev_data;
        addr != prev_data;
    }
    
    function void post_randomize();
        prev_addr = addr;
        prev_data = data;        
    endfunction: post_randomize

    `uvm_object_utils_begin(packet)
        `uvm_field_int(addr,UVM_ALL_ON)
        `uvm_field_int(data,UVM_ALL_ON)
    `uvm_object_utils_end

    virtual function string convert2string();
        return $sformatf("[%0s] addr = %0d  data = %0d",get_type_name(),this.addr,this.data);        
    endfunction

    function new(string name = "packet");
        super.new(name);
    endfunction: new
    
endclass: packet
