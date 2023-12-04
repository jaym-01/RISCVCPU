module instruction_memory #(
    parameter A_WIDTH = 12
)(
    input logic [A_WIDTH-1:0] A,
    output logic [31:0] RD
);
    // byte addressing:
    logic [7:0] instr_arr [2**A_WIDTH-1:0];

    initial begin
        // $readmemh("src/myprog/f1.s.hex", instr_arr);
        // $readmemh("src/myprog/test.s.hex", instr_arr);
        $readmemh("reference/pdf.hex", instr_arr);
    end

    assign RD = {instr_arr[A+3], instr_arr[A+2], instr_arr[A+1], instr_arr[A]};
endmodule
