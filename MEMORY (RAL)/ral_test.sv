/*
*Author : Revanth Sai Nandamuri
*GitHUB : https://github.com/RevanthNandamuri1341b0
*Date of update : 04 October 2021
*Project name : Verification of Memory Model using RAL Verification
*Domain : UVM 
*Description : 
*File Name : ral_test.sv
*File ID : 939556
*Modified by : #your name#
*/

class ral_test extends base_test;
    `uvm_component_utils(ral_test);

    reg_model_block regmodel;
    reg2bus_adapter adapter;

    function new(string name = "ral_test", uvm_component parent);
        super.new(name, parent);
    endfunction: new

    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);
    extern function void end_of_elaboration_phase(uvm_phase phase);
        
endclass: ral_test

function void ral_test::build_phase(uvm_phase phase);
    super.build_phase(phase);
    regmodel=reg_model_block::type_id::create("regmodel",this);
    regmodel.build();
    regmodel.lock_model();
    adapter=reg2bus_adapter::type_id::create("adapter",this);

    uvm_config_db#(reg_model_block)::set(this,"env.m_agent.seqr","regmodel",regmodel);
    uvm_config_db#(int)::set(this, "env.m_agent.seqr.*", "item_count", 10);
    uvm_config_db#(uvm_object_wrapper)::set(this, "env.m_agent.seqr.reset_phase", "default_sequence", reset_sequence::get_type());
    uvm_config_db#(uvm_object_wrapper)::set(this, "env.m_agent.seqr.configure_phase", "default_sequence", ral_sequence::get_type());
    uvm_config_db#(uvm_object_wrapper)::set(this, "env.m_agent.seqr.main_phase", "default_sequence", rw_sequence::get_type());
endfunction: build_phase

function void ral_test::connect_phase(uvm_phase phase);
    regmodel.default_map.set_sequence(this.env.m_agent.seqr,adapter);    
    regmodel.default_map.set_auto_predict(1);    
endfunction: connect_phase

function void ral_test::end_of_elaboration_phase(uvm_phase phase);
    regmodel.print();
endfunction: end_of_elaboration_phase
