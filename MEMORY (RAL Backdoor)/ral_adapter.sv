/*
*Author : Revanth Sai Nandamuri
*GitHUB : https://github.com/RevanthNandamuri1341b0
*Date of update : 05 October 2021
*Project name : Verification of Memory Model using RAL Verification with Backdoor access
*Domain : UVM 
*Description : 
*File Name : ral_adapter.sv
*File ID : 543165
*Modified by : #your name#
*/

class reg2bus_adapter extends uvm_reg_adapter;
    `uvm_object_utils(reg2bus_adapter)
    
    function new(string name = "reg2bus_adapter");
        super.new(name);
    endfunction

    virtual function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
        packet reg_pkt;
        reg_pkt=packet::type_id::create("reg_pkt");
        reg_pkt.mode = (rw.kind == UVM_READ) ? REG_READ : REG_WRITE;
        reg_pkt.addr = rw.addr;
        reg_pkt.data = rw.data;
        `uvm_info("RAL_ADAPTER",$sformatf("RAL reg2bus Adapter addr=%0h data=%0d  register csr2_chip_en",rw.addr,rw.data),UVM_DEBUG)
        return reg_pkt;
    endfunction
    
    virtual function void bus2reg(uvm_sequence_item bus_item, ref uvm_reg_bus_op rw);
        packet reg_pkt;
        if(!$cast(reg_pkt, bus_item))
        begin
            `uvm_fatal("REG_ADAPTER_ERR", "bus_item provided to bus2reg in adapter is not a bus transaction type")
            return;
        end
      rw.kind = (reg_pkt.mode == REG_READ) ? UVM_READ : UVM_WRITE;
        rw.addr = reg_pkt.addr;
        rw.data = reg_pkt.data;
        rw.status = UVM_IS_OK;
        `uvm_info("RAL_ADAPTER",$sformatf("RAL bus2reg Adapter addr=%0h data=%0d  register csr2_chip_en",reg_pkt.addr,reg_pkt.data),UVM_DEBUG)
    endfunction
endclass

/*
    Variables of structure 	uvm_reg_bus_op
    kind	= Kind of access: UVM_READ or UVM_WRITE.
    addr	= The bus address.
    data	= The data to write.
    n_bits	= The number of bits of uvm_reg_item::value being transferred by this transaction.
    byte_en	= Enables for the byte lanes on the bus.
    status	= The result of the transaction: UVM_IS_OK, UVM_HAS_X, UVM_NOT_OK.
*/
