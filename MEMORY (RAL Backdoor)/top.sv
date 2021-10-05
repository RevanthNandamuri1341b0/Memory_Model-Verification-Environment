/*
*Author : Revanth Sai Nandamuri
*GitHUB : https://github.com/RevanthNandamuri1341b0
*Date of update : 05 October 2021
*Project name : Verification of Memory Model using RAL Verification with Backdoor access
*Domain : UVM
*Description : 
*File Name : top.sv
*File ID : 242281
*Modified by : #your name#
*/

`include "memory_if.sv"
`include "memory_rtl.sv"
`include "program_mem.sv"
module top;
    
    parameter reg [15:0] ADDR_WIDTH=8;
    parameter reg [15:0] DATA_WIDTH=32;
    parameter reg [15:0] MEM_SIZE=16;
    
    bit clk;
    
    always #10 clk=!clk;
    
    memory_if  #(ADDR_WIDTH,DATA_WIDTH,MEM_SIZE) mem_if(clk);
    memory_rtl #(ADDR_WIDTH,DATA_WIDTH,MEM_SIZE) dut_inst
    (
      .clk(clk),
      .reset(mem_if.reset),
      .wr(mem_if.wr),
      .addr(mem_if.addr),
      .wdata(mem_if.wdata),
      .rdata(mem_if.rdata),
      .response(mem_if.slv_rsp)
    );
    program_mem p_test(mem_if);
    
endmodule: top
