/*
*Author : Revanth Sai Nandamuri
*GitHUB : https://github.com/RevanthNandamuri1341b0
*Date of update : 05 October 2021
*Project name : Verification of Memory Model using RAL Verification with Backdoor access
*Domain : UVM
*Description : 
*File Name : coverage.sv
*File ID : 009827
*Modified by : #your name#
*/

class coverage extends uvm_subscriber#(packet);
    `uvm_component_utils(coverage);

    real coverage_score;
    packet pkt;

  covergroup cov_mem with function sample(packet pkt);
        coverpoint pkt.addr;
    endgroup: cov_mem

    extern virtual function void write(T t);
    extern virtual function void extract_phase(uvm_phase phase);
    
    function new(string name = "coverage", uvm_component parent);
        super.new(name, parent);
      cov_mem=new;
    endfunction: new
    
endclass: coverage

function void coverage::write(T t);
    if(!$cast(pkt,t.clone))
    begin
        `uvm_fatal("COV","Transaction object supplied is NULL in coverage component");     
    end
    cov_mem.sample(pkt);
    coverage_score = cov_mem.get_coverage();
    `uvm_info("COV",$sformatf("Coverage = %0f%%",coverage_score ),UVM_NONE)        
endfunction: write
      
function void coverage::extract_phase(uvm_phase phase);
  uvm_config_db#(real)::set(null,"uvm_test_top.env","cov_score",coverage_score);
endfunction: extract_phase

