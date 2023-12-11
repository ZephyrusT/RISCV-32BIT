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
//    output [2:0]ALUControl;
    output [5:0]ALUControl;
  //internal wire
 wire [1:0] concatenation;
 
//  assign concatenation ={op[5],funct7[5]};
  
//  assign ALUControl = (ALUOp == 2'b00) ? 3'b000 :
//                    (ALUOp == 2'b01) ? 3'b001 :
//                    (ALUOp == 2'b11) ? 3'b111 :
//                    ((ALUOp == 2'b10) & (funct3 == 3'b100)) ? 3'b100: 
//                    ((ALUOp == 2'b10) & (funct3 == 3'b001)) ? 3'b110: //ll
//                    ((ALUOp == 2'b10) & (funct3 == 3'b000)&(concatenation  == 2'b11)) ? 3'b001 : 
//                    ((ALUOp == 2'b10) & (funct3 == 3'b000))&(concatenation != 2'b11) ? 3'b000 :
//                    ((ALUOp == 2'b10) & (funct3 == 3'b010))  ? 3'b101 : 
//                    ((ALUOp == 2'b10) & (funct3 == 3'b110))  ? 3'b011 : 
//                    ((ALUOp == 2'b10) & (funct3 == 3'b111)) ?  3'b010 : 
//                                                               3'b000;
  assign ALUControl = (ALUOp == 2'b00) ? 6'b000_000 :
  
                    ((ALUOp == 2'b01) & (funct3 == 3'b000))? 6'b000_001 ://beq
                    ((ALUOp == 2'b01)& (funct3 == 3'b001)) ? 6'b001_011 ://bne
                    ((ALUOp == 2'b01)& (funct3 == 3'b100)) ? 6'b000_101 ://blt
                    ((ALUOp == 2'b01)& (funct3 == 3'b101)) ? 6'b001_100 ://bge
                    ((ALUOp == 2'b01)& (funct3 == 3'b110)) ? 6'b001_010 ://bltu
                    ((ALUOp == 2'b01)& (funct3 == 3'b111)) ? 6'b001_101 ://bltu
                    
                    (ALUOp == 2'b11) ? 6'b000_111 :
                    
                    //R-type instructions and I-type instructions
                    ((ALUOp == 2'b10) & (funct3 == 3'b100)) ? 6'b000_100: //xor and xori
                    ((ALUOp == 2'b10) & (funct3 == 3'b001)) ? 6'b000_110: //sll  and sli
                    ((ALUOp == 2'b10) & (funct3 == 3'b101)&({op[4],funct7[5]}  != 2'b11)) ? 6'b001_000: //srl and srli
                    ((ALUOp == 2'b10) & (funct3 == 3'b101)&({op[4],funct7[5]}  == 2'b11)) ? 6'b001_001: //sra and srai
                    ((ALUOp == 2'b10) & (funct3 == 3'b011)) ? 6'b001_010: //sltu and sltiu
                    ((ALUOp == 2'b10) & (funct3 == 3'b000)&({op[5],funct7[5]}  == 2'b11)) ? 6'b000_001 : 
                    ((ALUOp == 2'b10) & (funct3 == 3'b000))&({op[5],funct7[5]} != 2'b11) ? 6'b000_000 : //[5] for differentiating between I-type and R-type
                    ((ALUOp == 2'b10) & (funct3 == 3'b010))  ? 6'b000_101 : //for slt and slti
                    ((ALUOp == 2'b10) & (funct3 == 3'b110))  ? 6'b000_011 : 
                    ((ALUOp == 2'b10) & (funct3 == 3'b111)) ?  6'b000_010 : 
                                                               6'b000_000;
                                                               
                                                               //

endmodule
