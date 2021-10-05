/*
*Author : Revanth Sai Nandamuri
*GitHUB : https://github.com/RevanthNandamuri1341b0
*Date of update : 05 October 2021
*Project name : Verification of Memory Model using RAL Verification with Backdoor access
*Domain : UVM
*Description : 
*File Name : driver.sv
*File ID : 851346
*Modified by : #your name#
*/

class driver extends uvm_driver#(packet);
    `uvm_component_utils(driver);

    bit[31:0] pkt_id;
    virtual memory_if.tb vif;

    function new(string name = "driver", uvm_component parent);
        super.new(name, parent);
    endfunction: new

    extern virtual task run_phase(uvm_phase phase);
    extern virtual function void connect_phase(uvm_phase phase);
    extern virtual task write(input packet pkt);    
    extern virtual task read(input packet pkt);
    extern virtual task drive(packet pkt);
    extern virtual task drive_reset();
    extern virtual task drive_config(packet pkt);
    extern virtual task ral_write(packet pkt);
    extern virtual task ral_read(ref packet pkt);
    extern virtual task drive_stimulus(packet pkt);
        
endclass: driver

task driver::run_phase(uvm_phase phase);
    forever 
    begin
        seq_item_port.get_next_item(req);
        pkt_id++;
        `uvm_info("DRVR", $sformatf("Received Transaction (%0s) %0d from TLM port",req.mode.name(),pkt_id),UVM_MEDIUM)
      rsp=packet::type_id::create("rsp",this);
        drive(req);
        seq_item_port.item_done(req);
        `uvm_info("DRVR", $sformatf("DONE Transaction (%0s) %0d from TLM port",req.mode.name(),pkt_id), UVM_MEDIUM)
    end
endtask: run_phase

function void driver::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    uvm_config_db#(virtual memory_if.tb)::get(get_parent(), "", "drvr_if", vif);
    if(vif == null)
    begin
        `uvm_fatal("VIF_ERROR", "Virtual Interface in driver is null")
    end
endfunction: connect_phase

task driver::drive(packet pkt);
    case (req.mode)
        RESET       : drive_reset();
      	CONFIG      : drive_config(req);
        REG_WRITE   : ral_write(req);
        REG_READ    : ral_read(req);
        default     : drive_stimulus(req);
    endcase
endtask: drive

task driver::drive_reset();
    `uvm_info(get_type_name(), "RESET transaction Started ", UVM_FULL)
    vif.reset <= 1'b1;
    repeat(2) @(vif.cb);
    vif.reset <= 1'b0;
    `uvm_info(get_type_name(), "RESET transaction DONE ", UVM_HIGH)
endtask: drive_reset

task driver::drive_config(packet pkt);
    `uvm_info(get_type_name(), "Driver Configuration transaction Started ", UVM_HIGH)
    vif.cb.addr  <= pkt.addr;
    vif.cb.wdata <= pkt.data;
    vif.cb.wr    <= 1'b1;
    repeat(2)@(vif.cb);
    `uvm_info(get_type_name(), "Driver Configuration transaction DONE ", UVM_HIGH)
endtask: drive_config

task driver::write(input packet pkt);
    @(vif.cb);
    `uvm_info(get_type_name(), "Write Transaction Started", UVM_FULL)
    vif.cb.wr    <=  1'b1;
    vif.cb.wdata <=  pkt.data;
    vif.cb.addr  <=  pkt.addr;
    @(vif.cb);
  `uvm_info(get_type_name(), $sformatf("Write Transaction ADDR = %0d  DATA = %0d ENDED",pkt.addr,pkt.data), UVM_HIGH)
endtask: write


task driver::read(input packet pkt);
    `uvm_info(get_type_name(), "Read Transaction Started", UVM_FULL)
    vif.cb.wr   <=  1'b0;
    vif.cb.addr <=  pkt.addr;
    @(vif.cb);
    vif.cb.wr   <=  1'bx;
    `uvm_info(get_type_name(), "Read Transaction Ended", UVM_FULL)
endtask: read

task driver::ral_write(packet pkt);
    `uvm_info(get_type_name(), "Configuration RAL_WRITE Started", UVM_FULL)
    vif.cb.addr  <= pkt.addr;
    vif.cb.wdata <= pkt.data;
    vif.cb.wr    <= 1'b1;
    repeat(1) @(vif.cb);
    `uvm_info(get_type_name(), "Configuration RAL_WRITE Ended", UVM_HIGH)
endtask: ral_write

task driver::ral_read(ref packet pkt);
    @(vif.cb);
    vif.cb.addr <=  pkt.addr;
    vif.cb.wr   <=  1'b0;
    repeat(2)@(vif.cb);
    pkt.data    =   vif.cb.rdata;
endtask: ral_read

task driver::drive_stimulus(packet pkt);
    write(req);
    rsp.slv_rsp = vif.slv_rsp == 1'b1 ? OK : ERROR;
    read(req);
    rsp.set_id_info(req);
    seq_item_port.put_response(req);
endtask: drive_stimulus

