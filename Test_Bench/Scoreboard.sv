class fifo_scoreboard extends uvm_scoreboard;
  
  `uvm_component_utils(fifo_scoreboard)
  uvm_analysis_imp #(fifo_transaction, fifo_scoreboard) analysis_imp;
  int errors = 0;
  int checked_flags = 0;
  int checked_data =0;
  bit read_pending;
  bit [7:0] expected_fifo[$];
  
  bit [7:0]expected_data;
  
  localparam DEPTH = 16;
  
  function new(
    string name = "fifo_scoreboard",
    uvm_component parent = null
  );
    
    super.new(name,parent);
    analysis_imp = new("analysis_imp",this);
  endfunction
  
  
  function void write( fifo_transaction tr);
    
    bit acc_rd;
    bit acc_wr;
    
    
    
           //read part 
    
       if(read_pending) begin 
         checked_data++;
         if( tr.rd_data !== expected_data) begin 
           errors++;
           `uvm_error("SCB",$sformatf("DATA MISMATCH: expected %0h, got %0h", expected_data, tr.rd_data))
         end 
         
         read_pending = 0;
       end 
       
    
    
    
      
    checked_flags++;
    if( tr.empty !== (expected_fifo.size() == 0)) begin 
      errors++;
      
      `uvm_error("SCB",$sformatf("EMPTY wrong: dut=%0b, model size=%0d",
                                 tr.empty, expected_fifo.size()))
    end 
       
    if( tr.full !== (expected_fifo.size() == DEPTH)) begin
         
         errors++;
         
         `uvm_error("SCB",$sformatf("FULL wrong: dut=%0b, model size=%0d",
                                    tr.full, expected_fifo.size()))
       end 
    
    
    
    
    acc_rd = tr.rd_en && (expected_fifo.size()!== 0);
    acc_wr = tr.wr_en && (expected_fifo.size()!== DEPTH);
    
    if(acc_rd) begin 
      expected_data = expected_fifo.pop_front();
      read_pending = 1;
    end
    
    if(acc_wr) begin 
      
      expected_fifo.push_back(tr.wr_data);
    end
    
    
  endfunction
  
endclass