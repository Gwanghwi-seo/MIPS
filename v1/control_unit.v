module control_unit
(
    input   [5:0]   Op,
    input   [5:0]   Funct,
    output          MemtoReg,
    output          MemWrite,
    output  [2:0]   ALUControl,
    output  ALUSrc,
    output  RegDst,
    output  RegWrite
);

reg MemtoReg_r, MemWrite_r, ALUSrc_r,
    RegDst_r, RegWrite_r;
reg [1:0] ALUOp_r;
reg [2:0] ALUControl_r;

assign MemtoReg = MemtoReg_r;
assign MemWrite = MemWrite_r;
assign ALUControl = ALUControl_r;
assign ALUSrc = ALUSrc_r;
assign RegDst = RegDst_r;
assign RegWrite = RegWrite_r;

always @ (*) begin
    case ( Op )
        // R-type
        6'b000000: begin
            RegWrite_r  <= 1'b1;
            RegDst_r    <= 1'b1;
            ALUSrc_r    <= 1'b0;
            MemWrite_r  <= 1'b0;
            MemtoReg_r  <= 1'b0;
            ALUOp_r     <= 2'b10;
        end

        // lw
        6'b100011: begin
            RegWrite_r  <= 1'b1;
            RegDst_r    <= 1'b0;
            ALUSrc_r    <= 1'b1;
            MemWrite_r  <= 1'b0;
            MemtoReg_r  <= 1'b1;
            ALUOp_r     <= 2'b00;
        end

        // sw
        6'b101011: begin
            RegWrite_r  <= 1'b0;
            ALUSrc_r    <= 1'b1;
            MemWrite_r  <= 1'b1;
            ALUOp_r     <= 2'b00;
        end

        // addi
        6'b001000: begin
            RegWrite_r  <= 1'b1;
            RegDst_r    <= 1'b0;
            ALUSrc_r    <= 1'b1;
            MemWrite_r  <= 1'b0;
            MemtoReg_r  <= 1'b0;
            ALUOp_r     <= 2'b00;
        end

        default: begin
            RegWrite_r  <= 1'b1;
            RegDst_r    <= 1'b0;
            ALUSrc_r    <= 1'b1;
            MemWrite_r  <= 1'b0;
            MemtoReg_r  <= 1'b0;
            ALUOp_r     <= 2'b00;
        end
    endcase

    if ( ALUOp_r == 2'b00 )
        ALUControl_r <= 3'b010; // addition
    else if ( ALUOp_r == 2'b01 )
        ALUControl_r <= 3'b110; // subtraction
    else begin
        case ( Funct )
            6'b100000: ALUControl_r <= 3'b010; // addition
            6'b100010: ALUControl_r <= 3'b110; // subtraction
            6'b100100: ALUControl_r <= 3'b000; // bit-wise and
            6'b100101: ALUControl_r <= 3'b001; // bit-wise or
            6'b101010: ALUControl_r <= 3'b111; // set on less than
        endcase
    end
end
endmodule
