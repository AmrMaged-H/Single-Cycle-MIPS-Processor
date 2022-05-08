/*
 
 Module Name: ALU (Arithmetic Logic Unit)
 
 Functionality:
 - The ALU Used Implements One Of 6 Operations. So, It has 3 Control Lines
 
 Operations:
 1) AND
 2) OR
 3) Addition
 4) Subtraction
 5) Multiplication
 6) Set less Than --> Sets the to 1 if SrcA < SrcB and 0 Otherwise
 
 Inputs:
 1) SrcA         (32 Bits Wide)
 2) SrcB         (32 Bits Wide)
 3) ALUControl   (3 Bits Wide)
 
 Outputs:
 1) ALUResult    (32 Bits Wide)
 2) Zero         (Single Bit)
 
 */

`include "MACROS.v"

module ALU (input wire [`DATA_WIDTH-1:0] SrcA,
            input wire [`DATA_WIDTH-1:0] SrcB,
            input wire [`ALU_CTRL_WIDTH-1:0] ALUControl,
            
            output wire Zero,
            output reg [`DATA_WIDTH-1:0] ALUResult);

    assign Zero = ~|(ALUResult);
    // The Zero Flag Is Set When The ALU Output is Zero

    // Defining The Required Operations
    localparam AND = 3'd0;
    localparam OR  = 3'd1;
    localparam ADD = 3'd2;
    localparam SUB = 3'd4;
    localparam MUL = 3'd5;
    localparam SLT = 3'd6;


    always @ (*)
    begin
        
        case (ALUControl)
            
            AND: ALUResult     = SrcA & SrcB;
            OR:  ALUResult     = SrcA | SrcB;
            ADD: ALUResult     = SrcA + SrcB;
            SUB: ALUResult     = SrcA - SrcB;
            MUL: ALUResult     = SrcA * SrcB;
            SLT: ALUResult     = (SrcA < SrcB);
            default: ALUResult = 'd0;
            
        endcase
        
    end
    
endmodule
