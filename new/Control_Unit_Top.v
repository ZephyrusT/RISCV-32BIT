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
    Op,RegWrite,ImmSrc,ALUSrc,MemWrite,ResultSrc,
    Branch,ALUOp,Jump,funct3,funct7,ALUControl,PCSrc
    ,CSR_reg_wr,CSR_reg_rd,RS1D, RdD,CSR_wd_select, RD1_RS1_sel
    );
    input [2:0]funct3;
    input [6:0]funct7,Op;
    input [4:0]RS1D, RdD;
//    input zero; not a input in pipelined version 
    output ALUSrc,Branch,PCSrc,Jump,CSR_reg_wr,CSR_reg_rd;
    output [2:0]RegWrite;
    output [1:0]ALUOp,ResultSrc,MemWrite;
//    output [2:0]ALUControl;
    output [5:0]ALUControl;
    output [2:0]ImmSrc;
    output [1:0]CSR_wd_select;
    output RD1_RS1_sel;
    
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
    .Jump(Jump),
    .funct3(funct3),
    .CSR_reg_wr(CSR_reg_wr),
    .CSR_reg_rd(CSR_reg_rd),
    .CSR_wd_select(CSR_wd_select),
    .RS1D(RS1D),
    .RdD(RdD),
    .RD1_RS1_sel(RD1_RS1_sel)
    );
    
    ALU_Decoder ALU_Decoder(
    .ALUOp(ALUOp),
    .funct3(funct3),
    .funct7(funct7),
    .op(Op),
    .ALUControl(ALUControl)
    );

endmodule
