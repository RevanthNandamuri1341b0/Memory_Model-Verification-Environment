/*
*Author : Revanth Sai Nandamuri
*GitHUB : https://github.com/RevanthNandamuri1341b0
*Date of update : 15 August 2021
*Time of update : 12:04
*Project name : MEMORY VERIFICATION ENVIRONMENT
*Domain : UVM
*Description : 
File Name : memory_rtl.sv
*File ID : 785638
*Modified by : #your name#
*/


package mem_env_pkg;

    typedef enum {NORMAL,RESET,WRITE,READ,CFG_REG_WRITE,CFG_REG_READ}op_type;
    typedef enum {OK,ERROR} slv_response_type;
    
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    `include "packet.sv"
    
    `include "base_sequence.sv"
    `include "reset_sequence.sv"
    `include "config_sequence.sv"
    `include "shutdown_sequence.sv"
    `include "rw_sequence.sv"
    
    `include "sequencer.sv"
    `include "driver.sv"
    `include "iMonitor.sv"
    `include "master_agent.sv"
    
    `include "oMonitor.sv"
    `include "slave_agent.sv"
    
    `include "scoreboard.sv"
    `include "coverage.sv"
    `include "environment.sv"
    
endpackage