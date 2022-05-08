/*
 Module Name: ControlUnit
 
 Functionality:
 - This block computes the control signals based on the opcode and funct fields of
 the instruction
 - The Control Unit is Divided into Two Blocks of Combinational Logic (Main Dec. + ALU Dec.)
 
 Inputs:
 1) Instruction   (32 Bits Wide)
 2) Zero          (Single Bit)
 
 Outputs:
 1) MemtoReg      (Single Bit)
 2) MemWrite      (Single Bit)
 3) PCSrc         (Single Bit)
 4) ALUSrc        (Single Bit)
 5) RegDst        (Single Bit)
 6) RegWrite      (Single Bit)
 7) Jump          (Single Bit)
 8) ALUControl    (3 Bits Wide)

 */

`include "MACROS.v"

module ControlUnit (input wire [`INST_WIDTH-1:0] Instruction,
                    input wire Zero,

                    output wire MemtoReg,
                    output wire MemWrite,
                    output wire PCSrc,
                    output wire ALUSrc,
                    output wire RegDst,
                    output wire RegWrite,
                    output wire Jump,
                    output reg [2:0] ALUControl);
    
    // Internal Signals
    reg  [1:0] ALUOp;
    reg  [6:0] MainDec_Outputs_Cat;
    wire [5:0] OpCode; // For The Main Dec.
    wire [5:0] Funct;  // For The ALU Dec.
    wire Branch;
    
    assign PCSrc  = Branch & Zero;
    assign Funct  = Instruction [5:0];
    assign OpCode = Instruction [31:26];
    
    assign {Jump, MemWrite, RegWrite, RegDst, ALUSrc, MemtoReg, Branch} = MainDec_Outputs_Cat;
    
    ///////////////////////////////////// Main Decoder ///////////////////////////////////////
    
    // OpCode Cases as parameters
    localparam loadWord      = 6'b10_0011;
    localparam storeWord     = 6'b10_1011;
    localparam rType         = 6'b00_0000;
    localparam addImmediate  = 6'b00_1000;
    localparam branchIfEqual = 6'b00_0100;
    localparam jump_inst     = 6'b00_0010;
    
    always @(*) begin
        case (OpCode)
            
            loadWord:
            begin
                MainDec_Outputs_Cat = 7'b001_0110;
                ALUOp               = 2'b00;
            end
            
            storeWord:
            begin
                MainDec_Outputs_Cat = 7'b010_0110;
                ALUOp               = 2'b00;
            end
            
            rType:
            begin
                MainDec_Outputs_Cat = 7'b001_1000;
                ALUOp               = 2'b10;
            end
            
            addImmediate:
            begin
                MainDec_Outputs_Cat = 7'b001_0100;
                ALUOp               = 2'b00;
            end
            
            branchIfEqual:
            begin
                MainDec_Outputs_Cat = 7'b000_0001;
                ALUOp               = 2'b01;
            end
            
            jump_inst:
            begin
                MainDec_Outputs_Cat = 7'b100_0000;
                ALUOp               = 2'b00;
            end
            
            default:
            begin
                MainDec_Outputs_Cat = 7'b000_0000;
                ALUOp               = 2'b00;
            end
        endcase
    end
    
    ////////////////////////////////////// ALU Decoder ///////////////////////////////////////
    
    // Funct Cases as parameters
    localparam AND = 6'b10_0100;
    localparam OR  = 6'b10_0101;
    localparam add = 6'b10_0000;
    localparam sub = 6'b10_0010;
    localparam slt = 6'b10_1010;
    localparam mul = 6'b01_1100;
    
    always @(*) begin
        case (ALUOp)
            
            2'b00:
                ALUControl = 3'b010;
            2'b01:
                ALUControl = 3'b100;
            2'b10:
            begin
                case (Funct)
                    AND:
                        ALUControl = 3'b000;
                    OR:
                        ALUControl = 3'b001;
                    add:
                        ALUControl = 3'b010;
                    sub:
                        ALUControl = 3'b100;
                    slt:
                        ALUControl = 3'b110;
                    mul:
                        ALUControl = 3'b101;
                    default:
                        ALUControl = 3'b000;
                endcase
            end
            default:
                ALUControl = 3'b010;
            
        endcase
    end

endmodule
