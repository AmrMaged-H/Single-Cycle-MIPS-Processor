/*
 
 Module Name: SignExtend
 
 Functionality:
 - Sign extension simply copies the sign bit (most significant bit) of a short input (16 bits)
 into all of the upper bits of the longer output (32 bits)
 
 Inputs:
 1) Instr_IN         (16 Bits Wide)
 
 Outputs:
 1) SignImm          (32 Bits Wide)
 
 */

`include "MACROS.v"

module SignExtend (input wire [`INSTR_IN_WIDTH-1:0] Instr_IN,

                   output wire [`INST_WIDTH-1:0] SignImm);
    
    assign SignImm = {      { (`INST_WIDTH-`INSTR_IN_WIDTH) {Instr_IN[`INSTR_IN_WIDTH-1]} }     ,       Instr_IN     };

endmodule
