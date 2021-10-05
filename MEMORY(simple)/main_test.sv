class main_test extends base_test;
  `uvm_component_utils(main_test)
  
      function new (string name="main_test",uvm_component parent=null);
          super.new(name,parent);
      endfunction
  
      extern virtual function void build_phase(uvm_phase phase);
        extern virtual function void connect_phase(uvm_phase phase);
        
        extern virtual function void end_of_elaboration_phase(uvm_phase phase);
        extern virtual function void start_of_simulation_phase(uvm_phase phase);
  endclass	
  
  function void main_test::build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    uvm_config_db#(int)::set(this,"env.m_agent.seqr", "item_count", 10);
  
    
  uvm_config_db#(bit)::set(this,"env.m_agent.drvr", "set_resp_for_drvr", 1'b1);
  uvm_config_db#(bit)::set(this,"env","enable_coverage",1'b1);
    
  uvm_config_db#(string)::set(null,"lucid_vlsi","testing", "hello srinivas");
    
  uvm_config_db#(uvm_object_wrapper)::set(this,"env.m_agent.seqr.reset_phase","default_sequence",reset_sequence::get_type());
  uvm_config_db#(uvm_object_wrapper)::set(this,"env.m_agent.seqr.configure_phase","default_sequence",config_sequence::get_type());
  uvm_config_db#(uvm_object_wrapper)::set(this,"env.m_agent.seqr.main_phase","default_sequence",rw_sequence::get_type());
  uvm_config_db#(uvm_object_wrapper)::set(this,"env.m_agent.seqr.shutdown_phase","default_sequence",shutdown_sequence::get_type());
    
    //uvm_config_db#(int)::set(this,"env.m_agent.seqr", "item_count", 10);
  endfunction
  
  function void main_test::connect_phase(uvm_phase phase);
    //uvm_config_db#(int)::set(null,"lucid_vlsi","count", 30);
  endfunction
          
          
  function void main_test::end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    uvm_root::get().print_topology();
  endfunction
          
  function void main_test::start_of_simulation_phase(uvm_phase phase);
    `uvm_info ("SAMPLE_INFO","This is a SAMPLE uvm_info message 1 ",UVM_MEDIUM)
    for (int i=1; i<=5;i++) begin
      `uvm_error("SAMPLE_ERR",$sformatf("This is a SAMPLE uvm_error message %0d",i));
    end
    for (int i=1; i<=5;i++) begin
      `uvm_warning("SAMPLE_WARNING",$sformatf("This is a SAMPLE uvm_warning message %0d",i));
    end     
    `uvm_info ("SAMPLE_INFO_END","Original uvm_info message STUDY_INFO_END  ",UVM_MEDIUM)
    
    // `uvm_fatal("STUDY_FATAL", "This is a FATAL simulation is terminated") 
  
  endfunction