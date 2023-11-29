module program_counter#(
    parameter DATA_WIDTH=32
)(
    input logic [DATA_WIDTH-1:0] PC,
    input logic [12:0] ImmExt,
    input logic PCsrc,
    input logic PC_target,
    output logic [DATA_WIDTH-1:0] next_PC,
);
 logic PC_target,inc_PC;
 assign PC_target=PC+ImmExt;
 assign inc_PC=PC+4;

 always_comb begin
    if(PCsrc) next_PC=PC_target
    else next_PC=inc_PC;
 end
endmodule 