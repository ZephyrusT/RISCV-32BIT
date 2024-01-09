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
    input signed [31:0]A, B;
//    input [2:0]ALUControl;
    input [5:0]ALUControl;
    output Carry, OverFlow, Zero, Negative;
    output [31:0]Result;
    wire [31:0]ShiftRight;
    wire Cout;
    wire [31:0]Sum;
    wire [31:0]UnsignedA, UnsignedB;
    wire set_less_than,set_greater_than_or_equal,set_less_than_unsigned;
    wire set_greater_than_or_equal_unsigned;
    
    assign UnsignedA = A;
    assign UnsignedB = B;
    
    //ALUControl =000
    assign Sum = (ALUControl[0]==1'b0)?A+B:(A+((~B)+1));//sum or substract
    assign ShiftRight = (ALUControl[0]==1'b0)?A>>B:A>>>B;
    assign set_less_than = A<B;
    assign set_greater_than_or_equal = A>=B;
    assign set_less_than_unsigned = UnsignedA<UnsignedB;
    assign set_greater_than_or_equal_unsigned = UnsignedA>=UnsignedB;
    
    assign {Cout, Result} = (ALUControl == 6'b000_000)? Sum:
                            (ALUControl == 6'b000_001)? Sum://beq check if subtraction gives a zero
                            (ALUControl == 6'b000_010)? A&B:
                            (ALUControl == 6'b000_011)? A|B:
                            (ALUControl == 6'b000_100)? A^B:
                            (ALUControl == 6'b000_110)? A<<B://sll
                            (ALUControl == 6'b000_111)? B: //lui instruction
                            (ALUControl == 6'b001_000)? ShiftRight://srl
                            (ALUControl == 6'b001_001)? ShiftRight://sra
                            (ALUControl == 6'b001_010)? set_less_than_unsigned://sltu and bltu
                            (ALUControl == 6'b001_011)?Sum : // bne checks if subtraction is not equal to 0
                            (ALUControl == 6'b001_100)? set_greater_than_or_equal://bge
//                            (ALUControl == 6'b001_001)? ://
//                            (ALUControl == 6'b001_010)? ://
//                            (ALUControl == 6'b001_011)? ://
//                            (ALUControl == 6'b001_100)? ://
                            (ALUControl == 6'b001_101)? set_greater_than_or_equal_unsigned://bgeu
//                            (ALUControl == 6'b001_110)? ://
//                            (ALUControl == 6'b001_111)? ://
//                            (ALUControl == 6'b010_000)? ://
//                            (ALUControl == 6'b010_001)? ://
//                            (ALUControl == 6'b010_011)? ://                            
//                            (ALUControl == 6'b010_111)? ://                            
//                              (ALUControl == 6'b000_101)? {{32{1'b0}}, (Sum[31])}:
                              (ALUControl == 6'b000_101)? set_less_than://slt and slti
                              {33{1'b0}};
    assign overflow = ((Sum[31]^A[31]))&
                      (~(ALUControl[0]^B[31]^A[31]))&
                      (~ALUControl[1]);
    assign Carry = ((~ALUControl[0])&Cout);
//    assign Zero = &(~Result); //checks if Result is 0 then produces a 1.
    assign Zero = (ALUControl == 6'b000_001)?&(~Result): //beq
                  (ALUControl == 6'b001_011)?((Result!=6'b000_000)?1'b1:1'b0): //bge
                  (ALUControl == 6'b000_101)?set_less_than: //blt
                  (ALUControl == 6'b001_100)?set_greater_than_or_equal:
                  (ALUControl == 6'b001_010)? set_less_than_unsigned:
                  (ALUControl == 6'b001_101)? set_greater_than_or_equal_unsigned:
                  1'b0;   //bne                      
    assign Negative = Result[31];
                         //1000 0101 =>100001010   
endmodule

//    assign {Cout, Result} = (ALUControl == 3'b000)? Sum:
//                            (ALUControl == 3'b001)? Sum:
//                            (ALUControl == 3'b010)? A&B:
//                            (ALUControl == 3'b011)? A|B:
//                            (ALUControl == 3'b100)? A^B:
                            
//                            (ALUControl == 3'b110)?A<<B://sll
////                            (ALUControl == 3'byyy)?A>>B://sll
//                            (ALUControl == 3'b111)? B: //lui instruction
                            
//                            (ALUControl == 3'b101)? {{32{1'b0}}, (Sum[31])}:{33{1'b0}};