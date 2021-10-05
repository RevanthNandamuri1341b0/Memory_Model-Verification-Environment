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

`include "mem_env_pkg.sv"
program program_mem(memory_if pif);
    import uvm_pkg::*;
    import mem_env_pkg::*;
    `include "base_test.sv"
    `include "main_test.sv"
    initial begin
        $timeformat(-9, 1, "ns", 10);
        uvm_config_db#(virtual memory_if.tb)::set(null, "uvm_test_top", "master_if",pif.tb);
        uvm_config_db#(virtual memory_if.tb_mon_in)::set(null, "uvm_test_top", "mon_in",pif.tb_mon_in);
        uvm_config_db#(virtual memory_if.tb_mon_out)::set(null, "uvm_test_top", "mon_out",pif.tb_mon_out);
        run_test();
    end
endprogram //program_mem