/*
*Author : Revanth Sai Nandamuri
*GitHUB : https://github.com/RevanthNandamuri1341b0
*Date of update : 05 October 2021
*Project name : Verification of Memory Model using RAL Verification with Backdoor access
*Domain : UVM
*Description : 
*File Name : reg_model.sv
*File ID : 124292
*Modified by : #your name#
*/

class csr3 extends uvm_reg;
    
    `uvm_object_utils(csr3);
    uvm_reg_field F;

    function new(string name = "csr3");
        super.new(name,32,UVM_NO_COVERAGE);
    endfunction: new
    
    virtual function void build();
        this.F=uvm_reg_field::type_id::create("F");
        this.F.configure(this,32,0,"RW",0,32'h1,1,0,1);
    endfunction

endclass: csr3


class csr3_backdoor extends uvm_reg_backdoor;
    
    function new(string name);
        super.new(name);
    endfunction 

    virtual task write(uvm_reg_item rw);
        do_pre_write(rw);
        top.dut_inst.csr3 = rw.value[0];
        rw.status = UVM_IS_OK;
        do_post_write(rw);
    endtask

    virtual task read(uvm_reg_item rw);
        do_pre_read(rw);
        rw.value[0] = top.dut_inst.csr3;
        rw.status = UVM_IS_OK;
        do_post_read(rw);
    endtask

endclass: csr3_backdoor


class csr2_CHIP_EN extends uvm_reg;
    `uvm_object_utils(csr2_CHIP_EN);

    uvm_reg_field F;

    function new(string name = "csr2_CHIP_EN");
        super.new(name,8,UVM_NO_COVERAGE);
    endfunction: new
    
    virtual function void build();
        this.F=uvm_reg_field::type_id::create("F");
        this.F.configure(this,8,0,"RW",0,0,1,0,1);
    endfunction
endclass: csr2_CHIP_EN


class csr1_wr_count extends uvm_reg;
    `uvm_object_utils(csr1_wr_count);

    uvm_reg_field wr_count;
    uvm_reg_field rd_count;
    uvm_reg_field unused;
    
    function new(string name = "csr1_wr_count");
        super.new(name,32,UVM_NO_COVERAGE);
    endfunction: new

    virtual function void build();
        wr_count = uvm_reg_field::type_id::create("wr_count");
      wr_count.configure(this,8,0,"RO",0,8'h0,1,0,1);
        rd_count = uvm_reg_field::type_id::create("rd_count");
      rd_count.configure(this,8,8,"RO",0,8'h0,1,0,1);
        unused   = uvm_reg_field::type_id::create("unused");
      unused.configure(this,16,16,"RO",0,16'h0,1,0,1);
    endfunction
    
endclass: csr1_wr_count


//  Class: reg_model_block
//
class reg_model_block extends uvm_reg_block;
    `uvm_object_utils(reg_model_block);

    csr1_wr_count   csr1_wr_count_reg;
    csr2_CHIP_EN    csr2_chip_en;
    csr3            csr3_reg;
    csr3_backdoor   csr3_bkdr;

    function new(string name = "reg_model_block");
        super.new(name);
    endfunction: new

    virtual function void build();
        csr2_chip_en = csr2_CHIP_EN::type_id::create("csr2_chip_en");
        csr2_chip_en.configure(this,null,"csr2_CHIP_EN");
        csr2_chip_en.build();
      default_map  = create_map("default_map",.base_addr('h0),.n_bytes(4),.endian(UVM_LITTLE_ENDIAN),.byte_addressing(1));
        default_map.add_reg(csr2_chip_en,'h20,"RW");

        csr1_wr_count_reg = csr1_wr_count::type_id::create("csr1_wr_count_reg");
        csr1_wr_count_reg.configure(this,null,"csr1_wr_count");
        csr1_wr_count_reg.build();
      	default_map.add_reg(csr1_wr_count_reg,'h18,"RO");

        csr3_reg = csr3::type_id::create("csr3_reg");
        csr3_reg.configure(this,null,"csr3_reg");
        csr3_reg.build();
        default_map.add_reg(csr3_reg,'h24,"RW");

        csr3_bkdr = new(this.csr3_reg.get_full_name());
        this.csr3_reg.set_backdoor(csr3_bkdr);
    endfunction
endclass: reg_model_block
