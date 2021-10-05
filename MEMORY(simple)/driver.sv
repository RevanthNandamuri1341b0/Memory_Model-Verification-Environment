/*
*Author : Revanth Sai Nandamuri
*GitHUB : https://github.com/RevanthNandamuri1341b0
*Date of update : 11 August 2021
*Time of update : 15:41
*Project name : MEMORY DUT VERIFICATION  
*Domain : UVM
*Description : 
File Name : driver.sv
*File ID : 536728
*Modified by : #your name#
*/

class driver extends uvm_driver#(packet);
    `uvm_component_utils(driver);

    bit [31:0]pkt_id;
    virtual memory_if.tb vif;
    bit send_resp;

    function new(string name = "driver", uvm_component parent);
        super.new(name, parent);
    endfunction: new

    extern virtual task run_phase(uvm_phase phase);
    extern virtual function void connect_phase(uvm_phase phase);
    extern virtual task write(input packet pkt);
    extern virtual task read(input packet pkt);
    extern virtual task drive(packet pkt);
    extern virtual task drive_reset();
    extern virtual task config_reg_read(packet pkt);
    extern virtual task config_reg_write(packet pkt);
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

    function void driver::connect_phase(uvm_phase phase);
        super.connect_phase(phase);
      uvm_config_db#(bit)::get(this,"","set_resp_for_drvr",send_resp);
      uvm_config_db#(virtual memory_if.tb)::get(get_parent(), "", "drvr_if", vif);
        if(vif==null)
        begin
            `uvm_fatal("VIF_ERR_DRVR", "Virtual interface in DRIVER is NULL")
        end
    endfunction: connect_phase
    

    task driver::drive(packet pkt);
        case (req.mode)
            RESET            : drive_reset();
            CFG_REG_WRITE : config_reg_write(req);
            CFG_REG_READ  : config_reg_read(req); 
            default          : drive_stimulus(req);
        endcase
    endtask: drive
    

    task driver::drive_reset();
        `uvm_info(get_type_name(),"Reset transaction started...",UVM_FULL);
        vif.reset<=1;
        repeat(2)@(vif.cb);
        vif.reset<=0;
        `uvm_info(get_type_name(),"Reset transaction ended ",UVM_HIGH);
    endtask: drive_reset

task driver::config_reg_write(packet pkt);
    `uvm_info("CSR_W","Configuration WRITE transaction started...",UVM_FULL);
    vif.cb.addr<=pkt.addr;
    vif.cb.wdata<=pkt.data;
    vif.cb.wr<=1'b1;
    repeat(2)@(vif.cb);
    vif.cb.wr<=1'b0;
    `uvm_info("CSR_W","Configuration WRITE transaction ended ",UVM_HIGH);
endtask: config_reg_write

task driver::config_reg_read(packet pkt);
    `uvm_info("CSR_RD","Configuration READ transaction started...",UVM_FULL);
    vif.cb.addr<=pkt.addr;
    vif.cb.rd<=1'b1;
    repeat(2)@(vif.cb);
    vif.cb.rd<=1'b0;
    pkt.data=vif.cb.rdata;
    `uvm_info("CSR_RD","Configuration READ transaction ended ",UVM_HIGH);
endtask: config_reg_read


task driver::write(input packet pkt);
    `uvm_info("DRV_WS"," Write transaction started...",UVM_FULL);
    @(vif.cb);
    vif.cb.wr<=1;
    vif.cb.addr<=pkt.addr;
    vif.cb.wdata<=pkt.data;
    @(vif.cb);
    vif.cb.wr<=0;
    `uvm_info("DRV_WE",$sformatf("Write transaction ended with addr=%0d data=%0d",pkt.addr,pkt.data) ,UVM_HIGH);
endtask: write

task driver::read(input packet pkt);
    `uvm_info("RD_S"," Read transaction started...",UVM_FULL);
    @(vif.cb);
    vif.cb.rd<=1;
    vif.cb.addr<=pkt.addr;
    @(vif.cb);
    pkt.data<=vif.cb.rdata;
    vif.cb.rd<=0;
    `uvm_info("RD_E",$sformatf("Read transaction ended with addr=%0d ",pkt.addr) ,UVM_HIGH);
endtask: read


task driver::drive_stimulus(packet pkt);
    write(req);
    if(send_resp==1)
    begin
        rsp=packet::type_id::create("rsp",this);
        rsp.slv_rsp=(vif.slv_rsp==1'b1)?OK:ERROR;
        rsp.set_id_info(req);
        seq_item_port.put_response(rsp);
    end
    read(req);
endtask: drive_stimulus
