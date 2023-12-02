module extend(
    input logic [31:7] Imm,
    input logic [2:0] ImmSrc,
    output logic [31:0] ImmExt
);

    logic msb;
    assign msb = Imm[31];

    always_comb 
        if (ImmSrc == 3'd0) ImmExt = {{20{msb}}, Imm[31:20]}; // Regular
        else if (ImmSrc == 3'd1) ImmExt = {{19{msb}}, Imm[31], Imm[7], Imm[30:25], Imm[11:8], 1'b0}; // B Type Ins
        else if (ImmSrc == 3'd2) ImmExt = {{20{msb}}, Imm[31:25], Imm[11:7]}; // S Type Ins
        else if (ImmSrc == 3'd3) ImmExt = {{12{msb}}, Imm[31], Imm[19:12], Imm[20], Imm[30:21]}; // J Type Ins
        else if (ImmSrc == 3'd4) ImmExt = {Imm[31:12], 12'b0}; // LUI Ins

endmodule
