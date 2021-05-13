
// address_mux2  mux2(xxx)
// data_mux2 #(DATA_BUS_WIDTH) mux2(xxx)

module mux2(
    data0,
    data1,
    select,
    data_output,
);
    `include "params.v"

    parameter WIDTH = ADDRESS_BUS_WIDTH;

    input [WIDTH-1:0] data0;
    input [WIDTH-1:0] data1;
    input select;
    output [WIDTH-1:0] data_output;

    assign data_output = select ? data1 : data0;

endmodule
