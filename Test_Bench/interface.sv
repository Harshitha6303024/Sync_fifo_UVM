
`include "uvm_macros.svh"
import uvm_pkg::*;

interface fifo_if;
  logic clk;
  logic rst_n;
  logic rd_en; 
  logic wr_en;
  logic [7:0]wr_data;
  logic full;
  logic empty;
  logic [7:0]rd_data;
  
  
endinterface
