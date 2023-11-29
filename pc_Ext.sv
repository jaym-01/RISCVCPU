module pc_Ext#(
    parameter DATA_WIDTH=32
)(
    input logic [1:0] ImmSrc,
    input logic [12:0] ImmOp,
    input logic [31:7] instr,
    output logic ImmExt,
);

    always_comb
      case ImmExt
        2'b10: assign ImmExt={ImmOp[12],ImmOp[1],ImmOp[10:5],ImmOp[4:1],0};
        2'b00: assign ImmEXt=13'b0000000000;
        2'b01: assign ImmEXt=13'b0000000000;
        2'b??: assign ImmEXt=13'b0000000000;
      endcase

endmodule
