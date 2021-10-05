/*
*Author : Revanth Sai Nandamuri
*GitHUB : https://github.com/RevanthNandamuri1341b0
*Date of update : 05 October 2021
*Project name : Verification of Memory Model using RAL Verification with Backdoor access
*Domain : UVM
*Description : 
*File Name : iMonitor.sv
*File ID : 057361
*Modified by : #your name#
*/

class iMonitor extends uvm_monitor;
    `uvm_component_utils(iMonitor);

    virtual memory_if.tb_mon_in vif;
    uvm_analysis_port #(packet) analysis_port;
    packet pkt;

    function new(string name = "iMonitor", uvm_component parent);
        super.new(name, parent);
    endfunction: new

    extern virtual task run_phase(uvm_phase phase);
    extern virtual function void build_phase(uvm_phase phase);
    extern virtual function void connect_phase(uvm_phase phase);

endclass: iMonitor

function void iMonitor::build_phase(uvm_phase phase);
    super.build_phase(phase);
    analysis_port = new("analysis_port",this);    
endfunction: build_phase

function void iMonitor::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if(!uvm_config_db#(virtual memory_if.tb_mon_in)::get(get_parent(), "", "iMon_if",vif))
    begin
        `uvm_fatal(get_type_name(), "iMonitor DUT Interface not set")
    end
endfunction: connect_phase

task iMonitor::run_phase(uvm_phase phase);
    forever 
    begin
        @(vif.cb_mon_in.wdata);
        pkt = packet::type_id::create("pkt",this);
        pkt.addr = vif.cb_mon_in.addr;    
        pkt.data = vif.cb_mon_in.wdata;
        `uvm_info(get_type_name(), pkt.convert2string(), UVM_MEDIUM)
        analysis_port.write(pkt);
    end
endtask: run_phase
