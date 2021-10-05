/*
*Author : Revanth Sai Nandamuri
*GitHUB : https://github.com/RevanthNandamuri1341b0
*Date of update : 04 October 2021
*Project name : Verification of Memory Model using RAL Verification
*Domain : UVM
*Description : 
*File Name : packet.sv
*File ID : 413245
*Modified by : #your name#
*/

`define AWIDTH 8
`define DWIDTH 32

class packet extends uvm_sequence_item;

    rand logic [`AWIDTH-1:0]addr;
    rand logic [`DWIDTH-1:0]data;
  
    op_type mode;
    slv_response_type slv_rsp;

    bit [`AWIDTH-1:0]prev_addr;
    bit [`DWIDTH-1:0]prev_data;

    function new(string name = "packet");
        super.new(name);
    endfunction: new

    constraint valid
    {
        data inside {[10:9999]};    
        addr inside {[0:15]};    
        
        data!= prev_data;    
        addr!= prev_addr;    
    }

    function void post_randomize();
        prev_addr=addr;
        prev_data=data;
    endfunction
    
    `uvm_object_utils_begin(packet)
        `uvm_field_int(addr,UVM_ALL_ON)
        `uvm_field_int(data,UVM_ALL_ON)
    `uvm_object_utils_end
    
    virtual function string convert2string();
        return $sformatf("[%0s] addr=%0d data=%0d \n",get_type_name(),this.addr,this.data);
    endfunction
    
    
endclass: packet