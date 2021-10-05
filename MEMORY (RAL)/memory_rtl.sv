/*
*Author : Revanth Sai Nandamuri
*GitHUB : https://github.com/RevanthNandamuri1341b0
*Date of update : 04 October 2021
*Project name : Verification of Memory Model using RAL Verification
*Domain : UVM
*Description : 
*File Name : memory_rtl.sv
*File ID : 696054
*Modified by : #your name#
*/

module memory_rtl (clk,reset,wr,addr,wdata,rdata,response);

  //Synchronous write read memory
  parameter reg [15:0] ADDR_WIDTH=4;
  parameter reg [15:0] DATA_WIDTH=31;
  parameter reg [15:0] MEM_SIZE=16;
  
  input   clk,reset;
  input   wr;// for write wr=1;
             // for read  wr=0;
  input   [ADDR_WIDTH-1:0] addr;
  input   [DATA_WIDTH-1:0] wdata;
  output  [DATA_WIDTH-1:0] rdata;
  output response;
  
  wire    [DATA_WIDTH-1:0] rdata;
  reg     [DATA_WIDTH-1:0] mem [MEM_SIZE];
  reg     [DATA_WIDTH-1:0] data_out;
  
  //csr1_wr_count is a read only register
  reg [31:0] csr1_wr_count;//addr 'h18 = 'd24
  reg [7:0]  csr2_CHIP_EN;//addr 'h20 = 'd32
  reg [31:0] csr3;//addr 'h24 = 'd36
  reg [31:0] csr4_dropped;//addr 'h26 = 'd38
  
  reg response ;//Provides response to master on successful write
  reg out_enable;//controls when to pass read data on rdata pin
  
  //if wr=1 rdata should be in high impedance state
  //if wr=0 rdata should be content of memory with given address
  assign rdata = (out_enable & csr2_CHIP_EN[0])  ? data_out : 'bz;
  
  //asynchronous reset and synchronous write
  always @(posedge clk or posedge reset)
  begin
      if (reset) begin
          for(int i=0;i<MEM_SIZE;i++)
              mem[i] <= 'b0;
  
        csr1_wr_count <='b0;
        csr2_CHIP_EN <='b0;
        csr3 <='b0;
        csr4_dropped <= 'b0;
    end
      else if(wr ) begin
     casex (addr) 
      16'h0020 : csr2_CHIP_EN <= wdata;
      16'h0024 : csr3  <= wdata;
      default  : begin
             if(csr2_CHIP_EN[0] && (addr inside {[0:15]}) ) begin
           mem[addr[3:0]] <= wdata ;
                             csr1_wr_count[7:0]++;
           response <=1'b1;
             end else
           csr4_dropped++;
         end//end_of_default
        endcase //end_of_case
          end
      else response <=1'b0;
  end//end_of_write
  
  
  //Synchronous Read
  always @(posedge clk )
  begin
    if(wr==0) begin
          casex(addr)
           16'h0018 : data_out <= csr1_wr_count;
           16'h0020 : data_out <= {24'h0,csr2_CHIP_EN};
       16'h0024 : data_out <= csr3;
       default  : begin
           if(csr2_CHIP_EN[0] && (addr inside {[0:15]})) begin
            data_out <= mem[addr[3:0]] ;
            csr1_wr_count[15:8]++;
              end
            end
  
            endcase //end_of_case
        out_enable <= 1'b1;
    end
    else out_enable <=1'b0;
  
  end//end_of_read
  
  endmodule
  