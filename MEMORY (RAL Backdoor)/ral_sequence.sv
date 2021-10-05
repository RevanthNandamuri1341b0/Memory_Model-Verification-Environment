/*
*Author : Revanth Sai Nandamuri
*GitHUB : https://github.com/RevanthNandamuri1341b0
*Date of update : 05 October 2021
*Project name : Verification of Memory Model using RAL Verification with Backdoor access
*Domain : UVM 
*Description : 
*File Name : ral_sequence.sv
*File ID : 799446
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
        if(!uvm_config_db#(reg_model_block)::get(get_sequencer(),"","regmodel",model))
        begin
            `uvm_fatal("RAL_SEQ", "[RAL_ERROR] Register model is not set in ral_sequence")
        end
    endtask

    virtual task body();
        uvm_reg_data_t rdata;
        uvm_status_e status;

        /* Memory model configuration */
        `uvm_info("RAL_WRITE","RAL Before Write value 'h1 to register csr2_chip_en",UVM_MEDIUM)
        model.csr2_chip_en.write(status,'h1,.parent(this));
        `uvm_info("RAL_WRITE","RAL Written value 'h1 to register csr2_chip_en",UVM_MEDIUM)
        model.csr2_chip_en.read(status,rdata,.parent(this));
        `uvm_info("RAL_READ",$sformatf("RAL Read value =%0h from register csr2_chip_en",rdata),UVM_MEDIUM)
        model.csr1_wr_count_reg.read(status,rdata,.parent(this));
        `uvm_info("REG_COUNT",$sformatf("Write wr_count=%0d rd_count=%0d from register csr1_wr_count from DUT",rdata[7:0],rdata[15:8]),UVM_MEDIUM)

        /*  BACK_DOOR write to register csr3 */
        `uvm_info("RAL_WRITE","RAL UVM_BACKDOOR Before Write value 'habcd_ffff to register csr3",UVM_MEDIUM)
        model.csr3_reg.write(status,'habcd_ffff,.path(UVM_BACKDOOR),.parent(this));
        `uvm_info("RAL_WRITE","RAL UVM_BACKDOOR Written value 'habcd_ffff to register csr3",UVM_MEDIUM)
        model.csr3_reg.read(status,rdata,.path(UVM_BACKDOOR),.parent(this));
        `uvm_info("RAL_READ",$sformatf("RAL UVM_BACKDOOR Read value =%0h (expected abcd_ffff)from register csr3",rdata),UVM_MEDIUM)

    endtask

endclass: ral_sequence
