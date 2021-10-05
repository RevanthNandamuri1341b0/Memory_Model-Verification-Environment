/*
*Author : Revanth Sai Nandamuri
*GitHUB : https://github.com/RevanthNandamuri1341b0
*Date of update : 04 October 2021
*Project name : Verification of Memory Model using RAL Verification
*Domain : UVM 
*Description : 
*File Name : report_server.sv
*File ID : 594066
*Modified by : #your name#
*/

class disable_report_summary extends uvm_default_report_server;
    function void report_summarize(UVM_FILE file=0);
	`uvm_info("REPORT","Disabled UVM summary",UVM_NONE)
    endfunction
endclass

