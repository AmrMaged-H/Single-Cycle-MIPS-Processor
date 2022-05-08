/*
 
 Module Name: MUX
 
 Functionality:
 - This block Passes One Of The Inputs (IN_0, IN_1) To The Output Port (OUT), To
 Be Used In The Datapath
 
 Inputs:
 1) IN_0         Parameterized
 2) IN_1         Parameterized
 3) SEL          (Single Bit)
 
 Outputs:
 1) OUT          Parameterized
 
 */

module MUX #(parameter MUX_UNIT_WIDTH = 32)

            (input wire [MUX_UNIT_WIDTH-1:0] IN_0,
             input wire [MUX_UNIT_WIDTH-1:0] IN_1,
             input wire SEL,
             
             output wire [MUX_UNIT_WIDTH-1:0] OUT);
    
    assign OUT = (SEL == 0)? IN_0 : IN_1;
    
endmodule
