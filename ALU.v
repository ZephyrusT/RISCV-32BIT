`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.10.2023 15:59:50
// Design Name: 
// Module Name: ALU
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ALU(
    A, B, Result, Carry, Zero, Negative, OverFlow, ALUControl
    );
    input [31:0]A, B;
    input [2:0]ALUControl;
    output Carry, OverFlow, Zero, Negative;
    output [31:0]Result;
    
    wire Cout;
    wire [31:0]Sum;
    //ALUControl =000
    assign Sum = (ALUControl[0]==1'b0)?A+B:(A+((~B)+1));
    assign {Cout, Result} = (ALUControl == 3'b000)? Sum:
                            (ALUControl == 3'b001)? Sum:
                            (ALUControl == 3'b010)? A&B:
                            (ALUControl == 3'b011)? A|B:
                            (ALUControl == 3'b111)?B: //lui instruction
//                            (ALUControl == 3'b100)? A^B:
                            (ALUControl == 3'b101)? {{32{1'b0}}, (Sum[31])}:{33{1'b0}};
    assign overflow = ((Sum[31]^A[31]))&
                      (~(ALUControl[0]^B[31]^A[31]))&
                      (~ALUControl[1]);
    assign Carry = ((~ALUControl[0])&Cout);
    assign Zero = &(~Result);
    assign Negative = Result[31];
                             
endmodule
