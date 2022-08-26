module reg_file
(
    input           CLK,
    input           WE3,
    input   [4:0]   A1,
    input   [4:0]   A2,
    input   [4:0]   A3,
    input   [31:0]  WD3,
    output  [31:0]  RD1,
    output  [31:0]  RD2
);

parameter MAX_INDEX = 32;

reg [31:0] rf [MAX_INDEX-1:0];

initial begin
    rf [0] = 32'd0;
end

always @ (posedge CLK) begin
    if ( WE3 )
        rf [A3] <= WD3;
end

assign RD1 = rf [A1];
assign RD2 = rf [A2];

endmodule
