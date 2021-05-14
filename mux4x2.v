`timescale 1ns / 1ps
// address_mux4  mux4(xxx)
// data_mux4 #(DATA_BUS_WIDTH) mux4(xxx)

module mux4(
    data0,
    data1,
    data2,
    data3,
    select,
    data_output,
);
  `include "params.v"
  parameter WIDTH = ADDRESS_BUS_WIDTH;  

  input [WIDTH-1:0] data0;
  input [WIDTH-1:0] data1;
  input [WIDTH-1:0] data2;
  input [WIDTH-1:0] data3;
  input [1:0] select;
  output [WIDTH-1:0] data_output;

reg [WIDTH-1:0] data_bus ;
  always @ (*) begin
    case (select)
      0: data_bus <= data_0 ;
      1: data_bus <= data_1 ;
      2: data_bus <= data_2 ;
      3: data_bus <= data_3 ;
    endcase
  end
  assign data_out = data_bus ;

endmodule


