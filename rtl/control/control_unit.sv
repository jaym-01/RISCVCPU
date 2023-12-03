module control_unit #(
) (
    input logic [6:0] op,
    input logic [2:0] funct3,
    input logic [6:0] funct7, 
    input logic Zero,

    output logic [1:0] PCSrc,
    output logic ResultSrc,
    output logic MemWrite,
    output logic [2:0] MemSrc,
    
    output logic [2:0] ALUControl,
    output logic ALUSrc,
    output logic [2:0] ImmSrc,
    output logic RegWrite,
    output logic RWSrc
);
    

    always_comb begin
        
        // 1. PCSrc: 0 for PC + 4, 1 for PC + Imm, 2 for RET
        case(op)
            7'b1101111: PCSrc = 2'b01; // JAL
            7'b1100011: PCSrc = Zero ? 2'b00 : 2'b01; // BNE
            7'b1100111: PCSrc = 2'b10; // JALR
            default: PCSrc = 2'b00;
        endcase
        

        // 2. ResultSrc: 1 read from Data MEM, else 0 (only LBU uses this)
        ResultSrc = (op == 7'b0000011) ? 1 : 0;

        // 3. MemWrite: 1 if write to Data MEM, else 0 (only SB uses this)
        MemWrite = (op == 7'b0100011) ? 1 : 0;

        // MemSrc = funct3 (just to make things clear)
        MemSrc = funct3;

        // 4. Reduced version of ALUControl to account for just 3 ins
        ALUControl = (op == 7'b0110111) ? 3'b010 : (funct7 == 7'b0100000 ? 3'b001 : 3'b000); // if LUI, then 010, else (if sub, then 001, else add (000))

        // 5. ALUSrc: 1 for Imm, 0 for rs2
        ALUSrc = (op == 7'b0000011 || op == 7'b0100011 || op == 7'b0010011 || op == 7'b0110111) ? 1 : 0; // LBU, SB, ADDI, LUI: 1 else 0
        
        // 6. ImmSrc 3 bits
        case(op)
            7'b1100011: ImmSrc = 1; // B Type Ins
            7'b0100011: ImmSrc = 2; // S Type Ins
            7'b1101111: ImmSrc = 3; // J Type Ins
            7'b0110111: ImmSrc = 4; // LUI Ins
            default: ImmSrc = 0; // Default
        endcase


        // 7. RegWrite: 1 if write to register else 0
        if (
            op == 7'b0110011 // add
            || op == 7'b0010011 // addi
            || op == 7'b0000011 // LB and other load ins
            || op == 7'b1100111 // JALR
            || op == 7'b1101111 // JAL
        ) RegWrite = 1;
        else RegWrite = 0;

        // 8: RWSrc: 1 if RegWrite Data = PC + 4 else 0
        RWSrc = (op == 7'b1100111 || op == 7'b1101111) ? 1 : 0;  // JAL & JALR 
    end
    
endmodule
