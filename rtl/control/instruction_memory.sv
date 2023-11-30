module instruction_memory #(
    parameter 
    A_WIDTH = 12,
    D_WIDTH = 32
)(
    input logic [A_WIDTH-1:0] PC,
    output logic [31:0] Instr,
);
    // byte addressing:
    logic [7:0] instr_arr [2**A_WIDTH-1:0];
    $readmemh("reference/program.mem", instr_arr);

    Instr = {instr_arr[PC+3], instr_arr[PC+2], instr_arr[PC+1], instr_arr[PC]};
endmodule