`timescale 1ns / 1ps

module sign_extender(
    src,
    out1
  );
  `include "params.v"
	 
  input [IMMEDIATE_WIDTH-1:0] src ;
  output reg [DATA_BUS_WIDTH-1:0] out1 ;

  always @ ( src ) begin
    out1[IMMEDIATE_WIDTH-1:0]  = src[IMMEDIATE_WIDTH-1:0];
    out1[DATA_BUS_WIDTH-1:IMMEDIATE_WIDTH] = {8{src[IMMEDIATE_WIDTH-1]}};

  end


endmodule