/*
*Author : Revanth Sai Nandamuri
*GitHUB : https://github.com/RevanthNandamuri1341b0
*Date of update : 05 October 2021
*Project name : Verification of Memory Model using RAL Verification with Backdoor access
*Domain : UVM 
*Description : 
*File Name : environment.sv
*File ID : 086273
*Modified by : #your name#
*/

class environment extends uvm_env;
    `uvm_component_utils(environment);

    bit[31:0] exp_pkt_count;
    real tot_cov_score;
    bit[31:0] m_matches,mis_matches;

    master_agent    m_agent;
    slave_agent     s_agent;
    scoreboard      scb;
    coverage        cov_comp;

    function new(string name = "environment", uvm_component parent);
        super.new(name, parent);
    endfunction: new

    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);
    extern function void extract_phase(uvm_phase phase);
    extern function void report_phase(uvm_phase phase);
    
endclass: environment

function void environment::build_phase(uvm_phase phase);
    super.build_phase(phase);
    m_agent  = master_agent::type_id::create("m_agent",this);
    s_agent  = slave_agent::type_id::create("s_agent",this);
    scb      = scoreboard::type_id::create("scb",this);
    cov_comp = coverage::type_id::create("cov_comp",this);
endfunction: build_phase

function void environment::connect_phase(uvm_phase phase);
    m_agent.ap.connect(scb.mon_in);
    m_agent.ap.connect(cov_comp.analysis_export);
    s_agent.ap.connect(scb.mon_out);    
endfunction: connect_phase

function void environment::extract_phase(uvm_phase phase);
    uvm_config_db#(int)::get(this,"m_agent.seqr.*","item_count",exp_pkt_count); 
    uvm_config_db#(real)::get(this,"","cov_score",tot_cov_score);    
    uvm_config_db#(int)::get(this,"","matches",m_matches);    
    uvm_config_db#(int)::get(this,"","mis_matches",mis_matches);    
endfunction: extract_phase

function void environment::report_phase(uvm_phase phase);
    bit [31:0] tot_scb_cnt;
    tot_scb_cnt= m_matches + mis_matches;
    exp_pkt_count++;
    if(exp_pkt_count != tot_scb_cnt) 
    begin
      `uvm_info("FAIL","===========================================================",UVM_NONE);
        `uvm_info("FAIL","Test Failed due to packet count MIS_MATCH",UVM_NONE); 
        `uvm_info("FAIL",$sformatf("exp_pkt_count=%0d Received_in_scb=%0d ",exp_pkt_count,tot_scb_cnt),UVM_NONE); 
        `uvm_fatal("FAIL","======================= Test FAILED =======================");
    end
    else if(mis_matches != 0) 
    begin
        `uvm_info("FAIL","===========================================================",UVM_NONE);
        `uvm_info("FAIL","Test Failed due to mis_matched packets in scoreboard",UVM_NONE); 
        `uvm_info("FAIL",$sformatf("matched_pkt_count=%0d mis_matched_pkt_count=%0d ",m_matches,mis_matches),UVM_NONE); 
        `uvm_fatal("FAIL","======================= Test FAILED =======================");
    end
    else
    begin
        `uvm_info("PASS","======================= Test PASSED =======================",UVM_NONE);
        `uvm_info("PASS",$sformatf("exp_pkt_count=%0d Received_in_scb=%0d ",exp_pkt_count,tot_scb_cnt),UVM_NONE); 
        `uvm_info("PASS",$sformatf("matched_pkt_count=%0d mis_matched_pkt_count=%0d ",m_matches,mis_matches),UVM_NONE); 
        `uvm_info("PASS",$sformatf("Coverage=%0f%%",tot_cov_score),UVM_NONE); 
        `uvm_info("PASS","===========================================================",UVM_NONE);
    end
endfunction