/*
*Author : Revanth Sai Nandamuri
*GitHUB : https://github.com/RevanthNandamuri1341b0
*Date of update : 05 October 2021
*Project name : Verification of Memory Model using RAL Verification with Backdoor access
*Domain : UVM
*Description : 
*File Name : report_server.sv
*File ID : 594425
*Modified by : #your name#
*/

class disable_report_server extends uvm_default_report_server;
  function void report_summary(UVM_FILE,file = 0);
        `uvm_info("REPORT", "DIsabled UVM Summary", UVM_NONE)        
    endfunction
endclass