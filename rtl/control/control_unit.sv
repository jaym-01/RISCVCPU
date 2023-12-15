module control_unit #(
) (
    input logic [6:0] op,
    input logic [2:0] funct3,
    input logic [6:0] funct7, 
    input logic Zero,

    output logic [1:0] PCSrc,
    output logic MemWrite,
    output logic [2:0] MemSrc,
    
    output logic [2:0] ALUControl,
    output logic ALUSrc,
    output logic [2:0] ImmSrc,
    output logic RegWrite,
    output logic [1:0] RegWSrc
);
    

    always_comb begin
        
        // 1. PCSrc: 0 for PC + 4, 1 for PC + Imm, 2 for RET
        case(op)
            7'b1101111: PCSrc = 2'b01; // JAL
            7'b1100011: PCSrc = Zero ? 2'b00 : 2'b01; // BNE
            7'b1100111: PCSrc = 2'b10; // JALR
            default: PCSrc = 2'b00;
        endcase

        // 3. MemWrite: 1 if write to Data MEM, else 0 (only SB uses this)
        MemWrite = (op == 7'b0100011) ? 1 : 0;

        // MemSrc = funct3 (just to make things clear)
        MemSrc = funct3;

        // 4. Reduced version of ALUControl to account for just 3 ins
        ALUControl = (op == 7'b0110111) ? 3'b010 : (funct7 == 7'b0100000 ? 3'b001 : 3'b000); // if LUI, then 010, else (if sub, then 001, else add (000))

        // 5. ALUSrc: 1 for Imm, 0 for rs2
        ALUSrc = (op == 7'b0000011 || op == 7'b0100011 || op == 7'b0010011 || op == 7'b0110111 || op == 7'b01100111) ? 1 : 0; // LBU, SB, ADDI, LUI: 1 else 0
        
        // 6. ImmSrc 3 bits
        case(op)
            7'b1100011: ImmSrc = 3'd1; // B Type Ins
            7'b0100011: ImmSrc = 3'd2; // S Type Ins
            7'b1101111: ImmSrc = 3'd3; // JAL Type Ins
            7'b0110111: ImmSrc = 3'd4; // LUI Ins
            default: ImmSrc = 3'd0; // Default
        endcase


        // 7. RegWrite: 1 if write to register else 0
        if (
            op == 7'b0110011 // add
            || op == 7'b0010011 // addi
            || op == 7'b0000011 // LB and other load ins
            || op == 7'b1100111 // JALR
            || op == 7'b1101111 // JAL
            || op == 7'b110111  // LUI
        ) RegWrite = 1;
        else RegWrite = 0;

        // 8: RWSrc: 1 if RegWrite Data = PC + 4 else 0
        case (op)
            7'b0000011: RegWSrc = 2'b01; // BNE
            7'b1100111: RegWSrc = 2'b10; // JALR
            7'b1101111: RegWSrc = 2'b10; // JAL
            default: RegWSrc = 2'b00; // ALURes
        endcase;
    end
    
endmodule
