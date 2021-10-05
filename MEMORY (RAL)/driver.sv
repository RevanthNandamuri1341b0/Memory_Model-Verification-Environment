/*
*Author : Revanth Sai Nandamuri
*GitHUB : https://github.com/RevanthNandamuri1341b0
*Date of update : 04 October 2021
*Project name : Verification of Memory Model using RAL Verification
*Domain : UVM
*Description : 
*File Name : driver.sv
*File ID : 323593
*Modified by : #your name#
*/


class driver extends uvm_driver#(packet);
    `uvm_component_utils(driver);

    bit [31:0]pkt_id;
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
    extern virtual task ral_read(ref packet pkt);
    extern virtual task ral_write(packet pkt);
    extern virtual task drive_stimulus(packet pkt);
endclass: driver


    task driver::run_phase(uvm_phase phase);//seqr driver handshake
        forever 
        begin
            seq_item_port.get_next_item(req);
            pkt_id++;
            `uvm_info("DRVR",$sformatf("Received Transaction(%0s) %0d from TLM port",req.mode.name(),pkt_id),UVM_MEDIUM);
            drive(req);                    
            seq_item_port.item_done();
            `uvm_info("DRVR",$sformatf("Driver Transaction(%0s) %0d Done \n",req.mode.name(),pkt_id),UVM_MEDIUM);
        end
    endtask: run_phase

    task driver::drive(packet pkt);
            case (req.mode) 
                RESET: drive_reset();
                CONFIG : drive_config(req);
                REG_WRITE: ral_write(req);
                REG_READ : ral_read(req);
                default: drive_stimulus(req);
            endcase
    endtask: drive

    function void driver::connect_phase(uvm_phase phase);
        super.connect_phase(phase);
      //uvm_config_db#(bit)::get(this,"","set_resp_for_drvr",send_resp);
      uvm_config_db#(virtual memory_if.tb)::get(get_parent(), "", "drvr_if", vif);
        if(vif==null)
        begin
            `uvm_fatal("VIF_ERR_DRVR", "Virtual interface in DRIVER is NULL")
        end
    endfunction: connect_phase
    

    task driver::drive_config(packet pkt);
        `uvm_info(get_type_name(),"Configuration transaction started...",UVM_FULL);
        vif.cb.addr <= pkt.addr;
        vif.cb.wdata <= pkt.data;
        vif.cb.wr <= 1'b1;
        repeat (2) @(vif.cb);
        `uvm_info(get_type_name(),"Configuration transaction ended ",UVM_HIGH);
        endtask

    task driver::drive_reset();
        `uvm_info(get_type_name(),"Reset transaction started...",UVM_FULL);
        vif.reset<=1;
        repeat(2)@(vif.cb);
        vif.reset<=0;
        `uvm_info(get_type_name(),"Reset transaction ended ",UVM_HIGH);
    endtask: drive_reset

task driver::ral_write(packet pkt);
    `uvm_info("RAL_W","RAL WRITE transaction started...",UVM_FULL);
    vif.cb.addr     <=  pkt.addr;
    vif.cb.wdata    <=  pkt.data;
    vif.cb.wr       <=  1'b1;
    repeat(1)@(vif.cb);
    `uvm_info("RAL_W","RAL WRITE transaction ended ",UVM_HIGH);
endtask: ral_write

task driver::ral_read(ref packet pkt);
    `uvm_info("RAL_RD","RAL READ transaction started...",UVM_FULL);
    repeat(1)@(vif.cb);
    vif.cb.addr     <=  pkt.addr;
    vif.cb.wr       <=  1'b0;
    repeat(2)@(vif.cb);
    pkt.data        =   vif.cb.rdata;
    `uvm_info("RAL_RD","RAL READ transaction ended ",UVM_HIGH);
endtask: ral_read


task driver::write(input packet pkt);
    @(vif.cb);
    `uvm_info("DRV_WS"," Write transaction started...",UVM_FULL);
    vif.cb.wr       <=  1'b1;
    vif.cb.addr     <=  pkt.addr;
    vif.cb.wdata    <=  pkt.data;
    @(vif.cb);
    `uvm_info("DRV_WE",$sformatf("Write transaction ended with addr=%0d data=%0d",pkt.addr,pkt.data) ,UVM_HIGH);
endtask: write

task driver::read(input packet pkt);
    `uvm_info("RD_S"," Read transaction started...",UVM_FULL);
    vif.cb.wr       <=  1'b0;
    vif.cb.addr     <=  pkt.addr;
    @(vif.cb);
    vif.cb.wr       <=  1'bx;
    `uvm_info("RD_E",$sformatf("Read transaction ended with addr=%0d ",pkt.addr) ,UVM_HIGH);
endtask: read


task driver::drive_stimulus(packet pkt);
    rsp=packet::type_id::create("rsp",this);
    write(req);
    rsp.slv_rsp=(vif.slv_rsp==1'b1)?OK:ERROR;
    read(req);
    rsp.set_id_info(req);
    seq_item_port.put_response(rsp);
endtask: drive_stimulus
