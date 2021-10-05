/*
*Author : Revanth Sai Nandamuri
*GitHUB : https://github.com/RevanthNandamuri1341b0
*Date of update : 05 October 2021
*Project name : Verification of Memory Model using RAL Verification with Backdoor access
*Domain : UVM
*Description : 
*File Name : mem_uvm_pkg.sv
*File ID : 178766
*Modified by : #your name#
*/

package mem_env_pkg;
    typedef enum {PACKET,RESET,CONFIG,REG_WRITE,REG_READ,WRITE,READ} op_type;
    typedef enum {OK,ERROR} slv_response_type;
    import uvm_pkg::*;
        
    `include "packet.sv"
    `include "base_sequence.sv"
    `include "reset_sequence.sv"
    `include "config_sequence.sv"
    `include "rw_sequence.sv"
    `include "sequencer.sv"
    `include "driver.sv"
    `include "iMonitor.sv"
    `include "oMonitor.sv"
    `include "master_agent.sv"
    `include "slave_agent.sv"
    
    `include "coverage.sv"
    `include "report_server.sv"
    `include "scoreboard.sv"
    `include "environment.sv"
    
endpackage 
    