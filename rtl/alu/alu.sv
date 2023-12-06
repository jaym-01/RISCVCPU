module alu #(
    parameter DATA_WIDTH = 32
)(
    input logic [DATA_WIDTH-1:0] op1,
    input logic [DATA_WIDTH-1:0] op2,
    input logic [2:0] ALUctrl,
    output logic [DATA_WIDTH-1:0] SUM,
    output logic zero
);

always_comb begin
    case (ALUctrl)
        3'b001: SUM = op1 - op2;
        3'b000: SUM = op1 + op2;
        3'b010: SUM = op1 & op2;
        3'b011: SUM = op1 | op2;
        3'b101: if(op1<op2) SUM = {[DATA_WIDTH-1]{1‘b0}+{1‘b1}};
                else SUM = {[DATA_WIDTH]{1'b0}};
        default: SUM = op1 + op2;
    endcase
end

endmodule
