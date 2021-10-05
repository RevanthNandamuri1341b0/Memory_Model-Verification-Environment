/*
*Author : Revanth Sai Nandamuri
*GitHUB : https://github.com/RevanthNandamuri1341b0
*Date of update : 04 October 2021
*Project name : Verification of Memory Model using RAL Verification
*Domain : UVM 
*Description : 
*File Name : reg_model.sv
*File ID : 301623
*Modified by : #your name#
*/

class csr2_CHIP_EN extends uvm_object;
    `uvm_object_utils(csr2_CHIP_EN);

    uvm_reg_field F;

    function new(string name = "csr2_CHIP_EN");
        super.new(name,UVM_NO_COVERAGE);
    endfunction: new
    
    virtual function void build();
        this.F = uvm_reg_field::type_id::create("F");
        this.F.configure(this,8,0,"RW",0,0,1,0,1);
    endfunction

endclass: csr2_CHIP_EN

class reg_model_block extends uvm_reg_block;
    `uvm_object_utils(reg_model_block);

    csr2_CHIP_EN csr2_chip_en;

    function new(string name = "reg_model_block");
        super.new(name,UVM_NO_COVERAGE);
    endfunction: new

    virtual function void build();
        csr2_chip_en=csr2_CHIP_EN::type_id::create("csr2_chip_en");
        csr2_chip_en.configure(this,null,"csr2_CHIP_EN");
        csr2_chip_en.build();
        default_map=create_map("default_map",.base_addr('h0),.n_byte(4),.endian(UVM_LITTLE_ENDIAN),.byte_addressing(1));
        default_map.add_reg(csr2_chip_en,'h20,"RW");
    endfunction
endclass: reg_model_block
