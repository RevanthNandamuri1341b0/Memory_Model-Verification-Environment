/*
*Author : Revanth Sai Nandamuri
*GitHUB : https://github.com/RevanthNandamuri1341b0
*Date of update : 04 October 2021
*Project name : Verification of Memory Model using RAL Verification
*Domain : UVM
*Description : 
*File Name : memory_if.sv
*File ID : 942375
*Modified by : #your name#
*/

interface memory_if(input clk);
    parameter reg[15:0] ADDR_WIDTH = 8;
    parameter reg[15:0] DATA_WIDTH = 31;
    parameter reg[15:0] MEM_SIZE   = 16;

    logic reset;
    logic slv_rsp;
    logic wr;

    logic [ADDR_WIDTH-1:0] addr;
    logic [DATA_WIDTH-1:0] wdata;
    logic [DATA_WIDTH-1:0] rdata;

    clocking cb @(posedge clk);
        output wr;
        output wdata;
        output addr;
        input  rdata;
    endclocking //cb

    clocking cb_mon_in @(posedge clk);
        input wr;
        input wdata;
        input addr;
    endclocking //cb_mon_in


    clocking cb_mon_out @(posedge clk);
        input wr;
        input rdata;
        input addr;
    endclocking //cb_mon_out

    modport tb (clocking cb,output reset,input slv_rsp);
    modport tb_mon_in (clocking cb_mon_in);
    modport tb_mon_out (clocking cb_mon_out);

endinterface //memory_if