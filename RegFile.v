/*
 
 Module Name: RegFile
 
 Functionality:
 - The Reg File Is Read Asynchronously And Written Synchronously
 - It Has 2 Read Ports And One Write Port
 - Supports Simultaneous Read And Writes
 - Width = 32 Bits And It Has 32 Entries (Depth)
 
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

`include "MACROS.v"

module RegFile (input wire [`REG_ADD_WIDTH-1:0] A1,
                input wire [`REG_ADD_WIDTH-1:0] A2,
                input wire [`REG_ADD_WIDTH-1:0] A3,
                input wire [`REG_WIDTH-1:0] WD3,
                input wire WE3,
                input wire CLK,
                input wire RST,
                
                output wire [`REG_WIDTH-1:0] RD1,
                output wire [`REG_WIDTH-1:0] RD2);

    // Defining Registers
    reg [`REG_WIDTH-1:0] REG [`REG_FILE_DEPTH-1:0];

    // Implementing Asynch Read Operations
    assign RD1 = REG [A1];
    assign RD2 = REG [A2];

    integer REG_COUNT; // To Be Used In The Loop Clearing The Registers

    always @(posedge CLK or negedge RST)
    begin
        if (!RST)
        begin
            for (REG_COUNT = 0 ; REG_COUNT < `REG_FILE_DEPTH ; REG_COUNT = REG_COUNT + 1)
                REG [REG_COUNT] <= 'd0;
        end
        
        else if (WE3)
        begin
        REG [A3] <= WD3;
        end
    end

endmodule
