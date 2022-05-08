/*
 
 Module Name: ProgramCounter
 
 Functionality:
 - The PC Register Provides The address of the Next Instruction To The Instruction Memory (Harvard Arch.)
 - It is a Synchronous Unit With Asynchronous RST (Active Low)
 
 Inputs:
 1) CLK       (Single Bit)
 2) RST       (Single Bit)
 3) PC_IN     (32 Bits Wide)
 
 Outputs:
 1) PC        (32 Bits Wide)
 
*/

`include "MACROS.v"

module ProgramCounter (input wire CLK,
                       input wire [`INST_ADD_WIDTH-1:0] PC_IN,
                       input wire RST,

                       output reg [`INST_ADD_WIDTH-1:0] PC);
    
    
    always @ (posedge CLK or negedge RST)
    begin
        
        if (!RST)
            PC <= 'd0;
        else
            PC <= PC_IN;
        
    end
    
endmodule
    
