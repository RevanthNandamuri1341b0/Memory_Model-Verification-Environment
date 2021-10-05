/*
*Author : Revanth Sai Nandamuri
*GitHUB : https://github.com/RevanthNandamuri1341b0
*Date of update : 15 August 2021
*Time of update : 12:39
*Project name : MEMORY VERIFICATION ENVIRONMENT
*Domain : UVM
*Description : 
File Name : top.sv
*File ID : 261612
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
      .rd(mem_if.rd),
      .addr(mem_if.addr),
      .wdata(mem_if.wdata),
      .rdata(mem_if.rdata),
      .response(mem_if.slv_rsp)
    );
    program_mem p_test(mem_if);
    
endmodule: top
