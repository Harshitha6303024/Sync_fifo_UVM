class fifo_monitor extends uvm_monitor;
  
  `uvm_component_utils(fifo_monitor)
  virtual fifo_if vif;
  uvm_analysis_port #(fifo_transaction) analysis_port;
  
  function new( string name = "fifo_monitor",
               uvm_component parent = null
              );
    
    super.new(name, parent);
    analysis_port = new("analysis_port",this);
  endfunction
  
  function void build_phase(uvm_phase phase);
    
    super.build_phase(phase);
    
    
    
    if(!uvm_config_db #(virtual fifo_if)::get(this,"","vif",vif))
       
       `uvm_fatal("MONITOR","Virtual Interface not found")
       
  endfunction
  
  task run_phase(uvm_phase phase);
    
    fifo_transaction tr;
    forever begin
      @(posedge vif.clk)
      
      if(vif.rst_n == 1'b1) begin
        tr = fifo_transaction::type_id::create("tr");
        tr.wr_en = vif.wr_en;
        tr.rd_en = vif.rd_en;
        tr.wr_data = vif.wr_data;
        tr.full = vif.full;
        tr.empty = vif.empty;
        tr.rd_data = vif.rd_data;
        
    
        analysis_port.write(tr);
      end
    end
    
  endtask 
  
endclass
