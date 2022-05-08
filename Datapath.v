/*
 Module Name: Datapath
 
 Functionality:
 - The Datapath is a collection of different functional units performing
 dataprocessing operations, Registers and Buses
 
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

`include "MACROS.v"

module Datapath (input wire CLK,
                 input wire RST,
                 input wire [`INST_WIDTH-1:0] Instruction,
                 input wire [`DATA_WIDTH-1:0] ReadData,
                 input wire [2:0] ALUControl,
                 input wire Jump,
                 input wire PCSrc,
                 input wire MemtoReg,
                 input wire ALUSrc,
                 input wire RegDst,
                 input wire RegWrite,

                 output wire [`INST_ADD_WIDTH-1:0] PC,
                 output wire [`DATA_WIDTH-1:0] ALUOut,
                 output wire [`DATA_WIDTH-1:0] WriteData,
                 output wire Zero);
    
    ///////////////////////// Internal Signals ///////////////////////////
    
    wire [`INST_ADD_WIDTH-1:0] PCPlus4;
    wire [`INST_ADD_WIDTH-1:0] PCBranch;
    wire [`INST_ADD_WIDTH-1:0] SignImmShiftOut;
    wire [`INST_ADD_WIDTH-1:0] PCSrc_MUX_OUT;
    wire [`INST_ADD_WIDTH-5:0] JumpShiftOut;
    wire [`INST_ADD_WIDTH-1:0] PC_Internal;

    wire [`DATA_WIDTH-1:0] SignImm;
    wire [`DATA_WIDTH-1:0] SrcA;
    wire [`DATA_WIDTH-1:0] SrcB;
    wire [`DATA_WIDTH-1:0] Result;
    
    wire [4:0] WriteReg;
    
    ////////////////////////////// Adders ////////////////////////////////
    /*
     Inputs:
     1) IN_1         (32 Bits Wide)
     2) IN_2         (32 Bits Wide)
     
     Outputs:
     1) OUT          (32 Bits Wide)
     */
    
    // The Adder Responsible for adding 4 to PC
    Adder PC_PLUS4_Adder (
    .IN_1 (PC),
    .IN_2 ({ {(`INST_ADD_WIDTH-3){1'd0}}, {3'd4}}), // Adding 4
    
    .OUT (PCPlus4) // PCPlus4 is an Internal Signal
    );
    
    // The Adder Responsible for Computing PCBranch
    Adder PC_Branch_Adder (
    .IN_1 (SignImmShiftOut), // SignImmShiftOut is an Internal Signal
    .IN_2 (PCPlus4),
    
    .OUT (PCBranch) // PCBranch is an Internal Signal
    );
    
    
    //////////////////////////// Multiplexers //////////////////////////////
    /*
     Inputs:
     1) IN_0         Parameterized
     2) IN_1         Parameterized
     3) SEL          (Single Bit)
     
     Outputs:
     1) OUT          Parameterized
     */
    
    MUX PCSrc_MUX (
    .IN_0 (PCPlus4),
    .IN_1 (PCBranch),
    .SEL (PCSrc),
    
    .OUT (PCSrc_MUX_OUT)
    );
    
    MUX Jump_MUX (
    .IN_0 (PCSrc_MUX_OUT),
    .IN_1 ({PCPlus4 [31:28], JumpShiftOut}),
    .SEL (Jump),
    
    .OUT (PC_Internal)
    );
    
    MUX #(.MUX_UNIT_WIDTH(5)) RegDst_MUX (
    .IN_0 (Instruction[20:16]),
    .IN_1 (Instruction[15:11]),
    .SEL (RegDst),
    
    .OUT (WriteReg)
    );
    
    MUX ALU_SrcB_MUX (
    .IN_0 (WriteData),
    .IN_1 (SignImm),
    .SEL (ALUSrc),
    
    .OUT (SrcB)
    );
    
    MUX WD3_MUX (
    .IN_0 (ALUOut),
    .IN_1 (ReadData),
    .SEL (MemtoReg),
    
    .OUT (Result)
    );
    
    ///////////////////////////// Program Counter //////////////////////////
    
    /*
     Inputs:
     1) CLK       (Single Bit)
     2) RST       (Single Bit)
     3) PC_IN     (32 Bits Wide)
     
     Outputs:
     1) PC        (32 Bits Wide)
     */
    
    ProgramCounter PC_Reg (
    .CLK (CLK),
    .RST (RST),
    .PC_IN (PC_Internal),
    
    .PC (PC)
    );
    
    ////////////////////////////////// ALU /////////////////////////////////
    /*
     Inputs:
     1) SrcA         (32 Bits Wide)
     2) SrcB         (32 Bits Wide)
     3) ALUControl   (3 Bits Wide)
     
     Outputs:
     1) ALUResult    (32 Bits Wide)
     2) Zero         (Single Bit)
     */
    
    ALU ALU_Module (
    .SrcA (SrcA),
    .SrcB (SrcB),
    .ALUControl (ALUControl),
    
    .ALUResult (ALUOut),
    .Zero (Zero)
    );
    
    ////////////////////////////// Register File ///////////////////////////
    /*
     Inputs:
     1) A1 Which Is The Address Of the 1st Reg to be Read        (5 Bits Wide)
     2) A2 Which Is The Address Of the 2nd Reg to be Read        (5 Bits Wide)
     3) A3 Which Is The Address Of the  Reg to be Written        (5 Bits Wide)
     4) WD3: The Input Data To Be Written in Reg With Add = A3   (32 Bits Wide)
     5) CLK                                                      (Single Bit)
     6) WE3: Write Enable                                        (Single Bit)
     7) RST: Active Low Asynch Signal                            (Single Bit)
     
     
     Outputs:
     1) RD1                                                      (32 Bits Wide)
     2) RD2                                                      (32 Bits Wide)
     */
    
    RegFile RegFile_Module (
    .A1 (Instruction[25:21]),
    .A2 (Instruction[20:16]),
    .A3 (WriteReg),
    .WD3 (Result),
    .CLK (CLK),
    .WE3 (RegWrite),
    .RST (RST),
    
    .RD1 (SrcA),
    .RD2 (WriteData)
    );
    
    ////////////////////////////// Shifters ////////////////////////////////
    /*
     Inputs:
     1) IN         Parameterized
     
     Outputs:
     1) OUT        Parameterized
     */
    
    ShiftLeft_Twice SignImmShift_Unit (
    .IN (SignImm),
    
    .OUT (SignImmShiftOut)
    );
    
    ShiftLeft_Twice #(.SHIFT_UNIT_WIDTH(28)) JumpShift_Unit (
    .IN ({2'd0, Instruction[25:0]}),
    
    .OUT (JumpShiftOut)
    );
    
    /////////////////////////////// Sign Extend ////////////////////////////
    /*
     Inputs:
     1) Instr_IN         (16 Bits Wide)
     
     Outputs:
     1) SignImm          (32 Bits Wide)
     */
    
    SignExtend SignExtend_Unit (
    .Instr_IN (Instruction[15:0]),
    
    .SignImm (SignImm)
    );
    
endmodule
