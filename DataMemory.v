/*
 
 Module Name: DataMemory
 
 Functionality:
 - The Data Memory is RAM
 - It Has One Read Port And One Write Port
 - Read Are Asynch While Writes Are Synch
 - Width = 32 Bits And It Has 100 Entries (Depth)
 
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

`include "MACROS.v"

module DataMemory (input wire [`DATA_MEM_ADD_WIDTH-1:0] ADDR,
                   input wire [`DATA_WIDTH-1:0] WD,
                   input wire CLK,
                   input wire WE,
                   input wire RST,

                   output wire [15:0] test_value, // The test_value is used for testing Only
                   output wire [`DATA_WIDTH-1:0] RD);

    reg [`DATA_WIDTH-1:0] DATA_MEM [`DATA_MEM_DEPTH-1:0];

    assign RD = DATA_MEM [ADDR];

    integer Entries_Count; // To Be Used In The Loop Clearing Diff. Mem locations

    always @(posedge CLK or negedge RST)
        begin

            if (!RST)
            begin
                for (Entries_Count = 0 ; Entries_Count < `DATA_MEM_DEPTH ; Entries_Count = Entries_Count + 1)
                    DATA_MEM [Entries_Count] <= 'd0;
            end
            
            else if (WE)
            begin
                DATA_MEM [ADDR] <= WD;
            end
                
        end

    localparam ADD_TO_BE_READ = 'd0;
    assign test_value = DATA_MEM [ADD_TO_BE_READ];
        
endmodule
