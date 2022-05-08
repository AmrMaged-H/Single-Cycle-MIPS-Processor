/*
 
 Module Name: ShiftLeft_Twice
 
 Functionality:
 - This block only shift the input to the left twice
 
 Inputs:
 1) IN         Parameterized
 
 Outputs:
 1) OUT        Parameterized
 
 */

module ShiftLeft_Twice #(parameter SHIFT_UNIT_WIDTH = 32)

                        (input wire [SHIFT_UNIT_WIDTH-1:0] IN,
                        
                         output wire [SHIFT_UNIT_WIDTH-1:0] OUT);
    
    assign OUT = IN << 2;
    
endmodule
