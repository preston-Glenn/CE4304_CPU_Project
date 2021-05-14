`timescale 1ns / 1ps


module dram(
    address,
    write_data,
    read_data,
    read_not_write,
    clk,
    cs
  );

  `include "params.v"

  input [ADDRESS_BUS_WIDTH-1:0] address ;
  input [DATA_BUS_WIDTH-1:0] write_data ;
  output [DATA_BUS_WIDTH-1:0] read_data ;
  input read_not_write ;
  input clk ;
  input cs;

  // NUM_ADDRESS x DATA_BUS_WIDTH bits 
  // Word oriented memory
  reg [DATA_BUS_WIDTH-1:0] data_memory [NUM_ADDRESS-1:0] ;
  reg [DATA_BUS_WIDTH-1:0] current_value ;

  // Load values into memory here
  initial begin
    data_memory[16] = 8'd10;
    data_memory[32] = 8'd23;
  end


  always @ (posedge clk) begin
    if(cs) begin 
      if (read_not_write) begin
        current_value <= data_memory[address];
      end else begin
        data_memory[address] <= write_data;
      end
    end  else 
      current_value <= 24'bz;
  end
  assign read_data = current_value;

endmodule