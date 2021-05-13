


module address_mux4(
    data0,
    data1,
    data2,
    data3,
    select,
    data_output,
);
    `include "params.v"

    input [ADDRESS_BUS_WIDTH-1:0] data0;
    input [ADDRESS_BUS_WIDTH-1:0] data1;
    input [ADDRESS_BUS_WIDTH-1:0] data2;
    input [ADDRESS_BUS_WIDTH-1:0] data3;
    input [1:0] select;
    output [ADDRESS_BUS_WIDTH-1:0] data_output;

reg [ADDRESS_BUS_WIDTH-1:0] data_bus ;
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


module data_mux4(
    data0,
    data1,
    data2,
    data3,
    select,
    data_output,
);
    `include "params.v"

    input [DATA_BUS_WIDTH-1:0] data0;
    input [DATA_BUS_WIDTH-1:0] data1;
    input [DATA_BUS_WIDTH-1:0] data2;
    input [DATA_BUS_WIDTH-1:0] data3;
    input [1:0] select;
    output [DATA_BUS_WIDTH-1:0] data_output;

reg [DATA_BUS_WIDTH-1:0] data_bus ;
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