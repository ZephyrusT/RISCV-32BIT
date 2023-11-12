`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.10.2023 09:46:39
// Design Name: 
// Module Name: ALU_decoder
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



module ALU_Decoder(ALUOp,funct3,funct7,op,ALUControl);

    input [1:0]ALUOp;
    input [2:0]funct3;
    input [6:0]funct7,op;
    output [2:0]ALUControl;

  //internal wire
 wire [1:0] concatenation;
 
  assign concatenation ={op[5],funct7[5]};
  
  assign ALUControl = (ALUOp == 2'b00) ? 3'b000 :
                    (ALUOp == 2'b01) ? 3'b001 :
                    (ALUOp == 2'b11) ? 3'b111 :
 //                   ((ALUOp == 2'b10) & (funct3 == 3'b100)) ? 3'b100: 
                    ((ALUOp == 2'b10) & (funct3 == 3'b000)&(concatenation  ==2'b11)) ? 3'b001 : 
                    ((ALUOp == 2'b10) & (funct3 == 3'b000))&(concatenation !=2'b11) ? 3'b000 :
                    ((ALUOp == 2'b10) & (funct3 == 3'b010))  ? 3'b101 : 
                    ((ALUOp == 2'b10) & (funct3 == 3'b110))  ? 3'b011 : 
                    ((ALUOp == 2'b10) & (funct3 == 3'b111)) ?  3'b010 : 
                                                               3'b000;
endmodule
