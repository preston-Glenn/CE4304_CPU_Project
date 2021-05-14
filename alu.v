`timescale 1ns / 1ps


module alu(
    A,
    B,
    result,
    Alu_Op,
    Z
  ) ;

  `include "params.v"
  parameter MSB = DATA_BUS_WIDTH-1 ;

  input [DATA_BUS_WIDTH-1:0] A ;
  input [DATA_BUS_WIDTH-1:0] B ;
  input [ALU_OP_NUM_BITS-1:0] Alu_Op ;
  output [DATA_BUS_WIDTH-1:0] result ;
  output Z ;


  reg [DATA_BUS_WIDTH:0] answer ;
  always @ ( * ) begin
    case (Alu_Op) 
      ALU_OP_ADD:
	      answer <= A + B ;
      ALU_OP_SUB:
	      answer <= A + ~(B) + 17'b1 ;
    default:
      answer <= 0 ;
    endcase 
  end


  assign result = answer[MSB:0] ;
  assign Z = ( answer ? 1'b0 : 1'b1 ) ;


endmodule