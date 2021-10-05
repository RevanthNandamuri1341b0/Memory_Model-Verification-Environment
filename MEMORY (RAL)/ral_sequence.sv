/*
*Author : Revanth Sai Nandamuri
*GitHUB : https://github.com/RevanthNandamuri1341b0
*Date of update : 04 October 2021
*Project name : Verification of Memory Model using RAL Verification
*Domain : UVM
*Description : 
*File Name : ral_sequence.sv
*File ID : 852339
*Modified by : #your name#
*/

class ral_sequence extends uvm_reg_sequence;
    `uvm_object_utils(ral_sequence);

    reg_model_block model;
    
    function new(string name = "ral_sequence");
        super.new(name);
        set_automatic_phase_objection(1);//uvm 1.2 onwards
    endfunction: new

    virtual task pre_start();
        if(!uvm_config_db#(reg_model_block)::get(get_sequencer(), "", "regmodel", model))
        begin
            `uvm_fatal("RAL_SEQ", "[RAL ERROR]  register model is not set in RAL_SEQUENCE")
        end
    endtask

    virtual task body();
        uvm_reg_data_t rdata;
        uvm_status_e status;
        `uvm_info("RAL_WRITE", "RAL Before Write value 'h1 to register csr2_chip_en", UVM_MEDIUM)
        model.csr2_chip_en.write(status,'h1,.parent(this));
        `uvm_info("RAL_WRITE", "RAL Written value 'h1 to register csr2_chip_en", UVM_MEDIUM)
        model.csr2_chip_en.read(status,rdata,.parent(this));
        `uvm_info("RAL_READ",$sformatf("RAL Read value = %0h for register csr2_chip_en",rdata),UVM_MEDIUM)
    endtask
endclass: ral_sequence