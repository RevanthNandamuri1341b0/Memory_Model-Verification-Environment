/*
*Author : Revanth Sai Nandamuri
*GitHUB : https://github.com/RevanthNandamuri1341b0
*Date of update : 05 October 2021
*Project name : Verification of Memory Model using RAL Verification with Backdoor access
*Domain : UVM
*Description : 
*File Name : oMonitor.sv
*File ID : 197791
*Modified by : #your name#
*/

class oMonitor extends uvm_monitor;
    `uvm_component_utils(oMonitor)

    virtual memory_if.tb_mon_out vif;
    uvm_analysis_port#(packet)analysis_port;
    packet pkt;

    function new(string name = "oMonitor", uvm_component parent);
        super.new(name, parent);
    endfunction: new

    extern virtual task run_phase(uvm_phase phase);
    extern virtual function void build_phase(uvm_phase phase);

endclass: oMonitor

function void oMonitor::build_phase(uvm_phase phase);
    super.build_phase(phase);
  if(!uvm_config_db#(virtual memory_if.tb_mon_out)::get(get_parent(),"" , "oMon_if", vif))
    begin
        `uvm_fatal(get_type_name(), "oMonitor DUT Interface not set")        
    end
    analysis_port=new("analysis_port",this);    
endfunction: build_phase

task oMonitor::run_phase(uvm_phase phase);
    forever 
    begin
        @(vif.cb_mon_out.rdata);
        if(vif.cb_mon_out.addr == 'h18) continue;
        if(vif.cb_mon_out.rdata === 'z || vif.cb_mon_out.rdata === 'x) continue;
        pkt = packet::type_id::create("pkt",this);
        pkt.addr = vif.cb_mon_out.addr;
        pkt.data = vif.cb_mon_out.rdata;
        `uvm_info(get_type_name(),pkt.convert2string(), UVM_MEDIUM)
      analysis_port.write(pkt);      
    end
endtask: run_phase
