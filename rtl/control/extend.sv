module extend (
    input logic [31:7] Imm,
    input logic [1:0] ImmSrc,
    output logic [31:0] ImmExt
);

    // How about U Type instruction?
    always_comb begin 
        if (ImmSrc == 2'd0) {
            ImmExt = {20{Imm[31]}, Imm[31:20]}; // Regular
        } else if (ImmSrc == 2'd1) {
            ImmExt = {12{Imm[31]}, Imm[31], Imm[19:12], Imm[20], Imm[30:21]}; // J Type Ins
        } else if (ImmSrc == 2'd2) {
            ImmExt = {Imm[31:12], 12'b0}; // UType Ins
        } else if (ImmSrc == 2'd3) {
            ImmExt = {{19{Imm[31]}}, Imm[31], Imm[7], Imm[30:25], Imm[11:8], 1'b0}; // BType Ins
        }
    end;
endmodule