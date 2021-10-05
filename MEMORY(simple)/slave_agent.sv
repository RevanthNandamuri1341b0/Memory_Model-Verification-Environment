/*
*Author : Revanth Sai Nandamuri
*GitHUB : https://github.com/RevanthNandamuri1341b0
*Date of update : 11 August 2021
*Time of update : 16:04
*Project name : MEMORY VERIFICATION ENVIRONMENT
*Domain : UVM
*Description : 
File Name : slave_agent.sv
*File ID : 881345
*Modified by : #your name#
*/

class slave_agent extends uvm_agent;
    `uvm_component_utils(slave_agent);

    oMonitor oMon;
    uvm_analysis_port#(packet)ap;
    
    function new(string name = "slave_agent", uvm_component parent);
        super.new(name, parent);
    endfunction: new

    extern virtual function void build_phase(uvm_phase phase);
    extern virtual function void connect_phase(uvm_phase phase);
    
endclass: slave_agent

function void slave_agent::build_phase(uvm_phase phase);
    super.build_phase(phase);
    ap=new("slave_ap",this);
    oMon=oMonitor::type_id::create("oMon",this);
endfunction: build_phase

function void slave_agent::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    oMon.analysis_port.connect(this.ap);
endfunction: connect_phase

