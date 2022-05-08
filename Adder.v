/*
 
 Module Name: Adder
 
 Functionality:
 - This is a simple combination block. It is an adder block that adds two 32-bit data inputs
 to each other (IN_1 and IN_2) and produces the output to the 32-bit port OUT, To Be Used
 for Incrementing The PC
 
 Inputs:
 1) IN_1         (32 Bits Wide)
 2) IN_2         (32 Bits Wide)
 
 Outputs:
 1) OUT          (32 Bits Wide)
 
*/

`include "MACROS.v"

module Adder (input wire [`DATA_WIDTH-1:0] IN_1,
              input wire [`DATA_WIDTH-1:0] IN_2,

              output wire [`DATA_WIDTH-1:0] OUT);
    
    assign OUT = IN_1 + IN_2;
    
endmodule
