/*
*Author : Revanth Sai Nandamuri
*GitHUB : https://github.com/RevanthNandamuri1341b0
*Date of update : 11 August 2021
*Time of update : 15:42
*Project name : MEMORY DUT VERIFICATION  
*Domain : UVM
*Description : 
File Name : oMonitor.sv
*File ID : 154145
*Modified by : #your name#
*/

class oMonitor extends uvm_monitor;
    `uvm_component_utils(oMonitor);
    virtual memory_if.tb_mon_out vif;
    uvm_analysis_port#(packet) analysis_port;
    packet pkt;

    function new(string name = "oMonitor", uvm_component parent);
        super.new(name, parent);
    endfunction: new

    extern virtual task run_phase(uvm_phase phase);
    extern virtual function void build_phase(uvm_phase phase);
    extern virtual function void connect_phase(uvm_phase phase);
        
endclass: oMonitor

task oMonitor::run_phase(uvm_phase phase);
    forever 
    begin
        @(vif.cb_mon_out.rdata);
      if(vif.cb_mon_out.addr=='h26)continue;
      if(vif.cb_mon_out.rdata==='x || vif.cb_mon_out.rdata==='z) continue;
        pkt=packet::type_id::create("pkt",this);
        pkt.addr=vif.cb_mon_out.addr;
        pkt.data=vif.cb_mon_out.rdata;
        `uvm_info(get_type_name(),pkt.convert2string(),UVM_MEDIUM);
        analysis_port.write(pkt);
    end
endtask: run_phase

function void oMonitor::build_phase(uvm_phase phase);
    super.build_phase(phase);
    analysis_port=new("analysis_port",this);    
endfunction: build_phase

function void oMonitor::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
  if(!uvm_config_db#(virtual memory_if.tb_mon_out)::get(get_parent(), "", "oMon_if",vif))
    begin
        `uvm_fatal(get_type_name(), "out Monitor DUT interface NOT set-------------!")    
    end
endfunction: connect_phase