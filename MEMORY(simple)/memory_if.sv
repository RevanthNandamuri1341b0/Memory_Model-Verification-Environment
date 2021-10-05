/*
*Author : Revanth Sai Nandamuri
*GitHUB : https://github.com/RevanthNandamuri1341b0
*Date of update : 15 August 2021
*Time of update : 11:39
*Project name : MEMORY VERIFICATION ENVIRONMENT
*Domain : UVM
*Description : 
File Name : memory_if.sv
*File ID : 472087
*Modified by : #your name#
*/

interface memory_if(input clk);
    parameter reg[15:0]ADDR_WIDTH=8;
    parameter reg[15:0]DATA_WIDTH=32;
    parameter reg[15:0]MEM_SIZE=16;

    logic reset;
    logic slv_rsp;
    logic wr;
    logic rd;
    logic [ADDR_WIDTH-1:0] addr;
    logic [DATA_WIDTH-1:0] wdata;
    logic [DATA_WIDTH-1:0] rdata;

    clocking cb @(posedge clk);
        output wr,rd;
        output wdata;
        output addr;
        input rdata;
    endclocking //cb
    
    clocking cb_mon_in @(posedge clk);
        input wr,rd;
        input wdata;
        input addr;
    endclocking //cb_mon_in

    clocking cb_mon_out @(posedge clk);
        input rdata;
        input wr,rd;
        input addr;
    endclocking //cb_mon_out

    modport tb (clocking cb,output reset,input slv_rsp);
    modport tb_mon_in (clocking cb_mon_in);
    modport tb_mon_out (clocking cb_mon_out);

endinterface: memory_if
