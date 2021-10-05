/*
*Author : Revanth Sai Nandamuri
*GitHUB : https://github.com/RevanthNandamuri1341b0
*Date of update : 04 October 2021
*Project name : Verification of Memory Model using RAL Verification
*Domain : UVM
*Description : 
*File Name : mem_env_pkg.sv
*File ID : 667995
*Modified by : #your name#
*/

package mem_env_pkg;

    typedef enum {PACKET,RESET,CONFIG,REG_WRITE,REG_READ,WRITE,READ}op_type;
    typedef enum {OK,ERROR} slv_response_type;
    
    import uvm_pkg::*;

    //`include "uvm_macros.svh"
    `include "packet.sv"
    `include "reg_model.sv"
    `include "ral_adapter.sv"
    
    `include "base_sequence.sv"
    `include "reset_sequence.sv"
    `include "config_sequence.sv"
    `include "rw_sequence.sv"
    `include "ral_sequence.sv"    
    
    `include "sequencer.sv"
    `include "driver.sv"
    `include "iMonitor.sv"
    `include "master_agent.sv"
    
    `include "oMonitor.sv"
    `include "slave_agent.sv"
    
    `include "coverage.sv"
    `include "report_server.sv"
    `include "scoreboard.sv"
    `include "environment.sv"
    
endpackage