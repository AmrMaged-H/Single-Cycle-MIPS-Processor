/*
 
 Module Name: InstructionMemory
 
 Functionality:
 - The PC Register Is Connected To The Address Port Of the Instruction Memory
 - The Instruction Memory is ROM
 - The Instruction Is Read Asynchronously
 - Width = 32 Bits And It Has 100 Entries (Depth)
 
 Inputs:
 1) Instr_Add  (32 Bits Wide)
 
 Outputs:
 1) Instr_RD   (32 Bits Wide)
 
 */

`include "MACROS.v"

module InstructionMemory (input wire [`INST_ADD_WIDTH-1:0] Instr_Add,

                          output wire [`INST_WIDTH-1:0] Instr_RD);

    reg [`INST_WIDTH-1:0] INST_MEM [`INST_MEM_DEPTH-1:0];

    initial begin
        $readmemh("Testing/Program 4_Machine Code.txt",INST_MEM) ;
    end

    assign Instr_RD = INST_MEM [Instr_Add >> 2];

endmodule
