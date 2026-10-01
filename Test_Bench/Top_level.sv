module tb;
  
  fifo_if intf();
  
   sync_fifo dut (
     .clk  (intf.clk),
     .rst_n   (intf.rst_n),
     .rd_en (intf.rd_en),
     .wr_en(intf.wr_en),
     .wr_data(intf.wr_data),
     .full(intf.full),
     .empty(intf.empty),
     .rd_data(intf.rd_data)
     
  );
  
   
  initial intf.clk = 0;
  always #5 intf.clk = ~intf.clk;

  initial begin
    intf.rst_n = 0;
    repeat (3) @(posedge intf.clk);
    #1 intf.rst_n = 1;     // release away from the clock edge
  end

  initial begin
    uvm_config_db #(virtual fifo_if)::set(null, "*", "vif", intf);
    run_test("fifo_test");
  end
endmodule
   