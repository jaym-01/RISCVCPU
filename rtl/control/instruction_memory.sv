module instruction_memory #(
    parameter 
    A_WIDTH = 12,
    D_WIDTH = 32
)(
    input logic [A_WIDTH-1:0] A,
    output logic [31:0] RD,
);
    // byte addressing:
    logic [7:0] instr_arr [2**A_WIDTH-1:0];
    $readmemh("reference/program.mem", instr_arr);

    RD = {instr_arr[A+3], instr_arr[A+2], instr_arr[A+1], instr_arr[A]};
endmodule