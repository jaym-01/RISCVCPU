module alu #(
    parameter DATA_WIDTH = 32
)(
    input logic [DATA_WIDTH-1:0] op1,
    input logic [DATA_WIDTH-1:0] op2,
    input logic [2:0] ALUctrl,
    output logic [DATA_WIDTH-1:0] SUM,
    output logic zero
);
    assign zero = op1 == op2;

    always_comb
        case(ALUctrl)
            3'b001: SUM = op1 - op2;
            3'b010: SUM = op2;
            default: SUM = op1 + op2;
        endcase

endmodule
