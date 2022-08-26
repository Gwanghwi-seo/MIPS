module alu 
(
    input   [31:0]    srcA,
    input   [31:0]    srcB,
    input   [2:0]     ALUControl,
    output            zero,
    output  [31:0]    ALUResult
);

wire [31:0] ALUOutAdder;
wire [31:0] ALUOutAND;
wire [31:0] ALUOutOR;
wire        cin;
wire [31:0] b;

assign cin = ALUControl[2];
assign b = cin ? srcB ^ {32{1'b1}} : srcB;

assign ALUOutAdder = srcA + b + cin;
assign ALUOutAND = srcA & b;
assign ALUOutOR = srcA | b;

assign ALUResult = ( ALUControl[1:0] == 2'b00 ) ? ALUOutAND :
                   ( ALUControl[1:0] == 2'b01 ) ? ALUOutOR  :
                   ( ALUControl[1:0] == 2'b10 ) ? ALUOutAdder  :
                   ( ALUControl[1:0] == 2'b11 ) ? ALUOutAdder[31]  :  0;
assign zero = ALUOutAdder ? 0 : 1;

endmodule
