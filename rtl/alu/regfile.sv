module regfile #(
    parameter ADDRESS_WIDTH = 5,
    DATA_WIDTH = 32
)(
    input logic clk,
    input logic [ADDRESS_WIDTH-1:0] AD1,
    input logic [ADDRESS_WIDTH-1:0] AD2,
    input logic [ADDRESS_WIDTH-1:0] AD3,
    input logic WE3,
    input logic [DATA_WIDTH-1:0] WD3,
    output logic [DATA_WIDTH-1:0] a0,
    output logic [DATA_WIDTH-1:0] RD1,
    output logic [DATA_WIDTH-1:0] RD2
);

    logic [DATA_WIDTH-1:0] regs [2**ADDRESS_WIDTH-1:0];

    initial begin
        regs[0] = {DATA_WIDTH{1'b0}};
        regs['d10] = {DATA_WIDTH{1'b0}};
    end

    assign RD1 = regs[AD1];
    assign RD2 = regs[AD2];
    assign a0 = regs['d10];  // a0 made async **

    always_ff @(posedge clk) begin
        if(WE3 && AD3 != 0) regs[AD3] <= WD3;
    end

endmodule
