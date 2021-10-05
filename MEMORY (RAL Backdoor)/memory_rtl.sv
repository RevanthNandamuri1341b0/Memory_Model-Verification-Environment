/*
*Author : Revanth Sai Nandamuri
*GitHUB : https://github.com/RevanthNandamuri1341b0
*Date of update : 05 October 2021
*Project name : Verification of Memory Model using RAL Verification with Backdoor access
*Domain : UVM 
*Description : 
*File Name : memory_rtl.sv
*File ID : 361221
*Modified by : #your name#
*/

module memory_rtl (clk,reset,wr,addr,wdata,rdata,response);
   parameter reg [15:0] ADDR_WIDTH = 4;
   parameter reg [15:0] DATA_WIDTH = 31;
   parameter reg [15:0] MEM_SIZE   = 16;
    
    input clk,reset;
    input wr;   //wr=1 --> Write
                //wr=0 --> Read
    input  [ADDR_WIDTH-1:0] addr;
    input  [DATA_WIDTH-1:0] wdata;
    output [DATA_WIDTH-1:0] rdata;

    output response;

    wire [DATA_WIDTH-1:0] rdata;
    reg  [DATA_WIDTH-1:0] mem [MEM_SIZE];
    reg  [DATA_WIDTH-1:0] data_out;

    reg [31:0] csr1_wr_count;       //addr => 'h18 = 'd24   //read_only
    reg [7:0]  csr2_CHIP_EN;        //addr => 'h20 = 'd32
    reg [31:0] csr3;                //addr => 'h24 = 'd36
    reg [31:0] csr4_dropped;        //addr => 'h26 = 'd38

    reg response;
    reg out_enable;

    assign rdata = (out_enable & csr2_CHIP_EN[0]) ? data_out : 'bz;

    always @(posedge clk or posedge reset) 
    begin
        if(reset)
        begin
            for(int i=0;i<MEM_SIZE;i++) mem[i] <= 'b0;
            csr1_wr_count <= 'b0;
            csr2_CHIP_EN  <= 'b0; 
            csr3          <= 'b0;
            csr4_dropped  <= 'b0;
        end
        else if(wr)
        begin
            casex (addr)
                16'h0020 : csr2_CHIP_EN <= wdata;
                16'h0024 : csr3         <= wdata;
                default  : begin
                            if(csr2_CHIP_EN[0] & (addr inside {[0:15]}))
                            begin
                                mem[addr[3:0]] <= wdata;
                                csr1_wr_count[7:0]++;
                                response<=1'b1;
                            end
                            else    csr4_dropped++;
                    end
            endcase
        end
        else response <= 1'b0;
    end

    always @(posedge clk) 
    begin
        if(wr==0)
        begin
            casex (addr)
                16'h0018 : data_out <= csr1_wr_count;
                16'h0020 : data_out <= {24'b0,csr2_CHIP_EN};
                16'h0024 : data_out <= csr3;
                default: 
                    begin
                        if(csr2_CHIP_EN[0] && (addr inside {[0:15]}))
                        begin
                            data_out <= mem[addr[3:0]];
                            csr1_wr_count[15:8]++;
                        end
                    end
            endcase
            out_enable <= 1'b1;
        end
        else out_enable <= 1'b0;
    end
endmodule