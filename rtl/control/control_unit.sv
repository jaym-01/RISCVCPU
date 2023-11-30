module control_unit #(
) (
    input logic [6:0] op,
    input logic [2:0] funct3,
    input logic [6:0] funct7, 
    input logic Zero,

    output logic PCSrc,
    output logic ResultSrc,
    output logic MemWrite,
    output logic [2:0] ALUControl,
    output logic ALUSrc,
    output logic ImmSrc,
    output logic RegWrite,
);
    

    always_comb begin
        // 1. PCSrc: 1 if branch is true, else 0
        if (op == 7'b0110011) {
            if (funct3 == 7'b001) PCSrc = !Zero; // BNE: Zero is 1 if equals 0 if not
        } else if (op == 7'b1101111) {
            PCSrc = 1 // JAL
        } else if (op == 7'b1100111) {
            PCSrc = 1 // JALR
        } else {
            PCSrc = 0 // Rest
        }

        // 2. ResultSrc: 1 read from Data MEM, else 0 (only LBU uses this)
        if (op == 7'b0000011) ResultSrc = 1;
        else ResultSrc = 0;    

        // 3. MemWrite: 1 if write to Data MEM, else 0 (only SB uses this)
        if (op == 7'b0100011) MemWrite = 1;
        else MemWrite = 0;

        // 4. ALUControl: Code for ALU operations (only have add & addi in )

        // ALUOp = 10
        if (op == 7'b0110011 || op == 7'b0010011) { 
            if (funct3 == 3'b000) {
                ALUControl = {op[5], funct7[5]} == 2'b11 ? 3'b001 : 3'b000 // 000 for add
            }
        } 
        // ALUOp = 00 (SW, LW)
        else if (op == 7'b0100011 || op == 7'b0000011) {
            ALUControl = 3'b000;
        } else ALUControl = 3'b001; // for BNE

        // 5. ALUSRC: 1 if IMM operation else 0
        if (op == 7'b0110011) ALUSrc = 0;
        else ALUSrc = 1;

        // 6. ImmSrc 2 bits: 1 if sign extended else 0
        // 0 for zero extend Imm[11:0] (JAL, JALR, ADDI)
        // Need a different ImmSrc for SB!
        if (op == 7'b1101111) ImmSrc = 1; // J type ins (JAL)
        else if (op == 7'b0110111) ImmSrc = 2; // U Type Ins (LUI)
        else if (op == 7'b1100011) ImmSrc = 3 // B Type Ins (BNE)
        else ImmSrc = 0 // default


        // 7. RegWrite: 1 if write to register else 0
        if (
            op == 7'b0110011 // add
            || op == 7'b0010011 // addi
            || op == 7'b0000011 // LB and other load ins
            || op == 7'b1100111 // JALR
            || op == 7'b1101111 // JAL
        ) RegWrite = 1;

        else RegWrite = 0;
    end
    

    


endmodule