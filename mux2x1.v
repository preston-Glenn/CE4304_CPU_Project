


module address_mux2(
    data0,
    data1,
    select,
    data_output,
);
    `include "params.v"

    input [ADDRESS_BUS_WIDTH-1:0] data0;
    input [ADDRESS_BUS_WIDTH-1:0] data1;
    input select;
    output [ADDRESS_BUS_WIDTH-1:0] data_output;

    assign data_output = select ? data1 : data0;

endmodule

module data_mux2(
    data0,
    data1,
    select,
    data_output,
);
    `include "params.v"

    input [DATA_BUS_WIDTH-1:0] data0;
    input [DATA_BUS_WIDTH-1:0] data1;
    input select;
    output [DATA_BUS_WIDTH-1:0] data_output;

    assign data_output = select ? data1 : data0;

endmodule