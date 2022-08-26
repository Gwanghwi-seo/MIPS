module top ( input CLK );

wire [4:0] PC_next, PCPlus1;
reg [4:0] PC;

wire [31:0] Instr, Result, RD2_out;
wire [31:0] SrcA, SrcB, SignImm, ALUResult, WriteData, ReadData;
wire [4:0] WriteReg;
wire PCSrc, MemtoReg, MemWrite, ALUSrc, RegDst, RegWrite;
wire [2:0] ALUControl;

assign PCPlus1 = PC + 5'd1; // word-addressible memory
//assign PCPlus4 = PC + 5'd4; // byte-addressible memory
assign WriteReg = RegDst ? Instr[15:11] : Instr[20:16];
assign SrcB = ALUSrc ? SignImm : RD2_out;
assign SignImm = { {16{Instr[15]}}, Instr[15:0] };

inst_mem im ( .A(PC), .RD(Instr)  );

control_unit cu
( 
    .Op(Instr[31:26]), .Funct(Instr[5:0]), .MemtoReg(MemtoReg), .MemWrite(MemWrite),
    .ALUControl(ALUControl), .ALUSrc(ALUSrc), .RegDst(RegDst), .RegWrite(RegWrite) 
);

reg_file rf 
( 
    .A1(Instr[25:21]), .A2(Instr[20:16]), .A3(WriteReg), .WD3(Result), .CLK(CLK), .WE3(RegWrite),
    .RD1(SrcA), .RD2(RD2_out) 
);

alu alu 
( 
    .srcA(SrcA), .srcB(SrcB), .ALUControl(ALUControl), .zero(Zero), .ALUResult(ALUResult)  
);

data_mem dm 
( 
    .A(ALUResult), .WD(WriteData), .CLK(CLK), .WE(MemWrite), .RD(ReadData)  
);

initial begin
    PC <= 5'd0;
end

always @ (posedge CLK) begin
    PC <= PC_next;
end

endmodule
