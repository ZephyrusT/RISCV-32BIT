`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.10.2023 09:45:52
// Design Name: 
// Module Name: Main_Decoder
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


module Main_Decoder(Op,RegWrite,Jump,ImmSrc,ALUSrc,MemWrite,ResultSrc,Branch,ALUOp, PCSrc);
    
//    input zero; not input in pipelined version 
    input [6:0]Op;
    output  RegWrite,ALUSrc,MemWrite,Branch, PCSrc,Jump;
    output [1:0]ALUOp,ResultSrc;
    output [2:0]ImmSrc;

    wire branch;
    
    assign RegWrite = (Op == 7'b0000011 | Op == 7'b0110011 | Op == 7'b0010011|Op == 7'b1101111 |Op==7'b0110111) ? 1'b1 :
                                                              1'b0 ;
    assign ImmSrc = (Op == 7'b1101111) ? 3'b011 :
                    (Op == 7'b0100011) ? 3'b001 : 
                    (Op == 7'b1100011) ? 3'b010 :   
                    (Op == 7'b0110111) ? 3'b100 :
                                         3'b000 ;
                                         
    assign ALUSrc = (Op == 7'b0000011 | Op == 7'b0100011 | Op == 7'b0010011 |Op==7'b0110111) ? 1'b1 :
                                                            1'b0 ;
    assign MemWrite = (Op == 7'b0100011) ? 1'b1 :
                                           1'b0 ;
                                           
    assign ResultSrc =  (Op == 7'b0000011) ? 2'b01 :
                        (Op == 7'b0110011|Op == 7'b0010011) ? 2'b00 :
                        (Op == 7'b1101111) ? 2'b10 :
                                            2'b00 ;
                                            
    assign Branch = (Op == 7'b1100011) ? 1'b1 :
                                         1'b0 ;
                                         
    assign ALUOp = (Op==7'b0110111)?2'b11:
                   (Op == 7'b0110011|Op == 7'b0010011) ? 2'b10 :
                   (Op == 7'b1100011) ? 2'b01 :
                                        2'b00 ;
    assign Jump = (Op==7'b1101111)?1'b1:1'b0;                                   
endmodule                                        



