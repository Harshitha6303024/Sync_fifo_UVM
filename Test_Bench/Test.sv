class fifo_test extends uvm_test;
  
  `uvm_component_utils(fifo_test)
  
  fifo_env env;
  
  function new(
    string name = "fifo_test",
    uvm_component parent = null
  );
    
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    
    super.build_phase(phase);
    
    env = fifo_env::type_id::create("env",this);
    
  endfunction
  
  task run_phase(uvm_phase phase);
    
    fifo_sequence seq;
    
    phase.raise_objection(this);
    
    seq = fifo_sequence::type_id::create("seq");
    #1;
    
    
    seq.start(env.agent.sequencer);
    
    repeat (5) @(posedge env.agent.driver.vif.clk);
    
    `uvm_info("TEST", $sformatf("flags checked=%0d, data checked=%0d, errors=%0d",
              env.scoreboard.checked_flags,
              env.scoreboard.checked_data,
              env.scoreboard.errors), UVM_LOW)
    
    if(env.scoreboard.read_pending)
      `uvm_warning("TEST", "Last read was never checked")
    
    if(env.scoreboard.errors == 0 && env.scoreboard.checked_data > 0)
      `uvm_info("TEST", "*** TEST PASSED ***", UVM_LOW)
    else if(env.scoreboard.errors == 0)
      `uvm_warning("TEST", "No data was checked, so the test may be meaningless")
    else
      `uvm_error("TEST", "*** TEST FAILED ***")
    
    phase.drop_objection(this);
    
  endtask 
  
endclass
