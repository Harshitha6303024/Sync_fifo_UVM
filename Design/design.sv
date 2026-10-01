
module sync_fifo(
  input clk,
  input rst_n,
  input rd_en, 
  input wr_en,
  input [7:0]wr_data,
  output full,
  output empty,
  output reg [7:0]rd_data
);
  
  reg [4:0]rd_ptr;
  reg [4:0]wr_ptr;
  reg [7:0] mem [0:15];
  
  always @(posedge clk or negedge rst_n)
    begin 
      if(!rst_n)
        begin
          rd_ptr <= '0;
        end
      else if( rd_en && !empty)
        begin
          rd_ptr <= rd_ptr + 1;
        end
    end
  
    always @(posedge clk or negedge rst_n)
    begin 
      if(!rst_n)
        begin
          wr_ptr <= '0;
        end
      else if( wr_en && !full)
        begin
          wr_ptr <= wr_ptr + 1;
        end
    end
  
    always @(posedge clk)
    begin 
      if( wr_en && !full)
        begin
          mem[wr_ptr[3:0]] <= wr_data ;
        end
    end
  
  always @(posedge clk or negedge rst_n)
    begin
      if (!rst_n)
        rd_data <= '0;
      else if( rd_en && !empty)
        begin
          rd_data <= mem[rd_ptr[3:0]];
        end
    end
  
  assign empty = (rd_ptr == wr_ptr);
  assign full = (rd_ptr[4] != wr_ptr[4]) && (rd_ptr[3:0] == wr_ptr[3:0]);
  
endmodule