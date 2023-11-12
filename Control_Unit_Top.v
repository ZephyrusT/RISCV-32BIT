`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.10.2023 09:52:28
// Design Name: 
// Module Name: Control_Unit_Top
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
`include "ALU_Decoder.v"
`include "Main_Decoder.v"

module Control_Unit_Top(
    Op,RegWrite,ImmSrc,ALUSrc,MemWrite,ResultSrc,Branch,ALUOp,Jump,funct3,funct7,ALUControl,PCSrc
    );
    input [2:0]funct3;
    input [6:0]funct7,Op;
//    input zero; not a input in pipelined version 
    output RegWrite,ALUSrc,MemWrite,Branch,PCSrc,Jump;
    output [1:0]ALUOp,ResultSrc;
    output [2:0]ALUControl;
    output [2:0]ImmSrc;
    wire [1:0]ALUOp;
    Main_Decoder Main_Decoder(
    .Op(Op),
    .RegWrite(RegWrite),
    .ImmSrc(ImmSrc),
    .ALUSrc(ALUSrc),
    .MemWrite(MemWrite),
    .ResultSrc(ResultSrc),
    .Branch(Branch),
    .ALUOp(ALUOp), 
    .PCSrc(PCSrc),
    .Jump(Jump)
    );
    
    ALU_Decoder ALU_Decoder(
    .ALUOp(ALUOp),
    .funct3(funct3),
    .funct7(funct7),
    .op(Op),
    .ALUControl(ALUControl)
    );

endmodule
