/*
*Author : Revanth Sai Nandamuri
*GitHUB : https://github.com/RevanthNandamuri1341b0
*Date of update : 04 October 2021
*Project name : Verification of Memory Model using RAL Verification
*Domain : UVM
*Description : 
*File Name : ral_adapter.sv
*File ID : 127887
*Modified by : #your name#
*/

class reg2bus_adapter extends uvm_reg_adapter;
    `uvm_object_utils(reg2bus_adapter);

    function new(string name = "reg2bus_adapter");
        super.new(name);
    endfunction: new
    
    virtual function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
        packet reg_pkt;
        reg_pkt=packet::type_id::create("reg_pkt");
        reg_pkt.mod=(rw.kind == UVM_READ)? REG_READ:REG_WRITE;
        reg_pkt.addr=rw.addr;
        reg_pkt.data=rw.data;
        `uvm_info("RAL_ADAPTER",$sformatf("RAL REG-BUS Adapter  addr = %0h  data = %0d",rw.addr,rw.data),UVM_DEBUG)
        return reg_pkt;
    endfunction
    
    virtual function void bus2reg(uvm_sequence_item bus_item, ref uvm_reg_bus_op rw);
        packet reg_pkt;
        if(!$cast(reg_pkt, bus_item))
        begin
            `uvm_error("REL_ADAPTER_ERROR", "bus_item provided in bus2item in adapter in not a bus transaction type")
            return;           
        end
        rw.kind = (reg_pkt.mode==REG_READ)?UVM_READ:UVM_WRITE;
        rw.addr = reg_pkt.addr;
        rw.data = reg_pkt.data;
        `uvm_info("RAL_ADAPTER",$sformatf("RAL BUS-REG Adapter  addr = %0h  data = %0d",reg_pkt.addr,reg_pkt.data),UVM_DEBUG)
    endfunction

endclass: reg2bus_adapter
