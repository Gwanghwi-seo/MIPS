module data_mem
(
    input           CLK,
    input           WE,
    input   [31:0]  A,
    input   [31:0]  WD,
    output  [31:0]  RD
);

parameter MAX_INDEX = 32;

reg [31:0] dm [MAX_INDEX-1:0];

always @ (posedge CLK) begin
    if ( WE )
        dm [A] <= WD;
end

assign RD = dm [A];

endmodule
