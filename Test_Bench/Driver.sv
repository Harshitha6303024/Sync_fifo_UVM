class fifo_driver extends uvm_driver #(fifo_transaction);
  
  `uvm_component_utils(fifo_driver)
  virtual fifo_if vif;
  
  function new(
    string name = "fifo_driver",
    uvm_component parent = null
  );
    super.new(name,parent);
  endfunction 
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db #(virtual fifo_if)::get(this,"","vif",vif))
      `uvm_fatal("DRIVER","Virtual Interface not found")
  endfunction
    
  task run_phase( uvm_phase phase);
    
    fifo_transaction tr;
    
    vif.wr_en <= '0;
    vif.rd_en <= '0;
    vif.wr_data <= '0;
    
    wait(vif.rst_n == 1'b1);
    @(posedge vif.clk);
    
    forever begin
    
    seq_item_port.get_next_item(tr);
    
      @(posedge vif.clk) 
      vif.wr_en <= tr.wr_en;
      vif.rd_en <= tr.rd_en;
      vif.wr_data <= tr.wr_data;
      
    
    seq_item_port.item_done();
      
    end
      
  endtask 
  
endclass