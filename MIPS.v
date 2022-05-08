/*
 Module Name: MIPS
 
 Functionality:
 - The Top Module Connecting The Datapath, Control Unit, Instruction
 and Data Memory together
 */

`include "MACROS.v"

module MIPS (input  wire CLK,
             input  wire RST,
             output wire [15:0] test_value);
    
    ////////////////////////// Internal Signals ////////////////////////////
    wire [`INST_WIDTH-1:0] Instr;
    wire [`DATA_WIDTH-1:0] ReadData;
    wire [`DATA_WIDTH-1:0] ALUOut;
    wire [`DATA_WIDTH-1:0] WriteData;
    wire [`INST_ADD_WIDTH-1:0] PC;
    wire [2:0] ALUControl;
    wire Jump;
    wire Zero;
    wire PCSrc;
    wire MemtoReg;
    wire ALUSrc;
    wire RegDst;
    wire RegWrite;
    wire MemWrite;
    
    ////////////////////////////// Datapath ////////////////////////////////
    /*
     Inputs:
     1)  CLK           (Single Bit)
     2)  RST           (Single Bit)
     3)  Instruction   (32 Bits Wide)
     4)  ReadData      (32 Bits Wide)
     5)  ALUControl    (3 Bits Wide)
     6)  Jump          (Single Bit)
     7)  PCSrc         (Single Bit)
     8)  MemtoReg      (Single Bit)
     9)  ALUSrc        (Single Bit)
     10) RegDst        (Single Bit)
     11) RegWrite      (Single Bit)
     
     
     Outputs:
     1) PC             (32 Bits Wide)
     2) ALUOut         (32 Bits Wide)
     3) WriteData      (32 Bits Wide)
     4) Zero           (Single Bit)
     */
    
    Datapath DP (
    .CLK (CLK),
    .RST (RST),
    .Instruction (Instr),
    .ReadData (ReadData),
    .ALUControl (ALUControl),
    .Jump (Jump),
    .PCSrc (PCSrc),
    .MemtoReg (MemtoReg),
    .ALUSrc (ALUSrc),
    .RegDst (RegDst),
    .RegWrite (RegWrite),
    
    .PC (PC),
    .ALUOut (ALUOut),
    .WriteData (WriteData),
    .Zero (Zero)
    );
    
    //////////////////////////// Control Unit //////////////////////////////
    /*
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
    
    ControlUnit CU (
    .Instruction (Instr),
    .Zero (Zero),
    
    .MemtoReg (MemtoReg),
    .MemWrite (MemWrite),
    .PCSrc (PCSrc),
    .ALUSrc (ALUSrc),
    .RegDst (RegDst),
    .RegWrite (RegWrite),
    .Jump (Jump),
    .ALUControl (ALUControl)
    );
    
    ///////////////////////// Instruction Memory ///////////////////////////
    /*
     Inputs:
     1) Instr_Add  (32 Bits Wide)
     
     Outputs:
     1) Instr_RD   (32 Bits Wide)
     */
    
    InstructionMemory Inst_Mem (
    .Instr_Add (PC),
    .Instr_RD (Instr)
    );
    
    ///////////////////////////// Data Memory //////////////////////////////
    /*
     Inputs:
     1) ADDR                        (32 Bits Wide)
     2) WD                          (32 Bits Wide)
     3) CLK                         (Single Bit)
     4) WE                          (Single Bit)
     5) RST: Active Low Signal      (Single Bit)
     
     Outputs:
     1) RD                          (32 Bits Wide)
     2) test_value                  (16 Bits Wide)

     */
    
    DataMemory Data_Mem (
    .ADDR (ALUOut),
    .WD (WriteData),
    .CLK (CLK),
    .WE (MemWrite),
    .RST (RST),
    
    .RD (ReadData),
    .test_value (test_value)
    );
endmodule
