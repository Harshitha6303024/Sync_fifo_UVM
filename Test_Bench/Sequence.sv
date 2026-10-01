class fifo_sequence extends uvm_sequence #(fifo_transaction);
  
  `uvm_object_utils(fifo_sequence)
   int num_items = 60; 
  
  function new(
    string name = "fifo_sequence");
    
    super.new(name);
  endfunction 
  
  
  
  task body();
    
    fifo_transaction tr;
    
    //Write Sequence
    repeat(num_items) begin 
      
      tr = fifo_transaction::type_id::create("tr");
      start_item(tr);
      if(!tr.randomize() with {
        wr_en dist {1 := 7, 0 := 3};
        rd_en dist {1 := 3, 0 := 7};
      })
        `uvm_error("SEQ","RANDOMIZATION FAILED")
      finish_item(tr);
        end
    
    //Read Sequence 
    
     repeat(num_items) begin 
       
       tr = fifo_transaction::type_id::create("tr");
       start_item(tr);
       if(!tr.randomize() with {
         wr_en dist {1 := 3, 0 := 7};
         rd_en dist {1 := 7, 0 := 3};
       })
         `uvm_error("SEQ","RANDOMIZATION FAILED")
        finish_item(tr);
        end
    
    //Random Sequence 
    
     repeat(num_items) begin 
       tr = fifo_transaction::type_id::create("tr");
       start_item(tr);
       if(!tr.randomize())
         `uvm_error("SEQ","RANDOMIZATION FAILED")
        finish_item(tr);
        end
    
    tr = fifo_transaction::type_id::create("tr");
    start_item(tr);
    tr.wr_en = 0; tr.rd_en = 0; tr.wr_data = 0;
    finish_item(tr);
    
  endtask       
  
endclass
