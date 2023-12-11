`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.10.2023 15:20:58
// Design Name: 
// Module Name: single_cycle_top
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
// instantiating all  the modules in a single module and connecting appropiate wires
//////////////////////////////////////////////////////////////////////////////////
`include "Prog_count.v"
`include "Instruction_Memory.v"
`include "Reg_file.v"
`include "Sign_extend.v"
`include "ALU.v"
`include "Control_Unit_Top.v"
`include "Data_Memory.v"
`include "PC_Adder.v"
`include "Mux.v"
module single_cycle_top(
    clk, rst
    );
    input clk, rst;
    wire [31:0]PC_A, RD_Instr, RD1_ALU, PCTarget,ImmExt_top, ALUResult,ReadData,Mux_PCNext,PCPlus4,RD2_top, SrcB, Result;
    wire [2:0]ALUControl_Top;
    wire [1:0]ImmSrc,ResultSrc;
    wire RegWrite,MemWrite, ALUSrc, PCSrc,zero;
Prog_count Prog_count(
    .clk(clk), 
    .PCNext(Mux_PCNext), 
    .PC(PC_A), 
    .rst(rst)
    );
PC_Adder PC_Adder(
    .a(PC_A), 
    .b(32'd4), 
    .sum(PCPlus4)
    );
    
Mux PC_mux(
    .Y(Mux_PCNext), 
    .A(PCPlus4), 
    .B(PCTarget), 
    .S(PCSrc)
);

PC_Adder PC_target_Adder(
    .a(PC_A), 
    .b(ImmExt_top), 
    .sum(PCTarget)
    );

 Control_Unit_Top Control_Unit_Top( 
    .Op(RD_Instr[6:0]),
    .RegWrite(RegWrite),
    .ImmSrc(ImmSrc),
    .ALUSrc(ALUSrc),
    .MemWrite(MemWrite),
    .ResultSrc(ResultSrc),
    .Branch(),
    .ALUOp(), 
    .zero(zero),
    .funct3(RD_Instr[14:12]),
    .funct7(RD_Instr[31:25]),//////////////////////////////////////////////////////////////
    .ALUControl(ALUControl_Top),
    .PCSrc(PCSrc)
    );    

Instruction_Memory Instruction_Memory(
    .A(PC_A), 
    .rst(rst), 
    .RD(RD_Instr)
    );
Reg_file Reg_file(
    .RD1(RD1_ALU), 
    .RD2(RD2_top),
    .A1(RD_Instr[19:15]), 
    .A2(RD_Instr[24:20]), 
    .A3(RD_Instr[11:7]), 
    .WD3(Result),
    .clk(clk), 
    .rst(rst), 
    .WE3(RegWrite)
    );
Mux Reg_AlU(
    .Y(SrcB), 
    .A(RD2_top), 
    .B(ImmExt_top), 
    .S(ALUSrc)
);
Sign_extend Sign_extend(
    .Imm_Ext(ImmExt_top), 
    .ImmSrc(ImmSrc),
    .In(RD_Instr)
    );
ALU ALU(
    .A(RD1_ALU), 
    .B(SrcB),  //need modification!!!!!
    .Result(ALUResult), 
    .Carry(), 
    .Zero(zero), 
    .Negative(), 
    .OverFlow(), 
    .ALUControl(ALUControl_Top));

Data_Memory Data_Memory(
    .A(ALUResult), 
    .WD(RD2_top), 
    .RD(ReadData), 
    .WE(MemWrite), 
    .rst(rst), 
    .clk(clk)
    );
Mux3 Datamem_reg(
    .a(ALUResult), 
    .b(ReadData), 
    .c(PCPlus4), 
    .s(ResultSrc), 
    .y(Result)
    );    
endmodule
