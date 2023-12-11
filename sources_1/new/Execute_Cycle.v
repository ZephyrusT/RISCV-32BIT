`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.10.2023 10:38:51
// Design Name: 
// Module Name: Execute_Cycle
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
`include "ALU.v"
`include "Mux.v"
`include "PC_Adder.v"
`include "Mux3.v"

module Execute_Cycle(
    clk, rst,
    RegWriteE, ResultSrcE, MemWriteE, BranchE, ALUControlE, ALUSrcE,
    RD1E, RD2E, PCE, RDE, ImmExtE, PCPlus4E,
    PCTargetE,PCSrcE,
    ALUResultM, WriteDataM, PCPlus4M, RDM, RegWriteM,MemWriteM,ResultSrcM,
    ResultW,JumpE,
    Forward_AE, Forward_BE
    );
    
    input clk, rst;
    
    input [31:0]RD1E, RD2E, PCE, ImmExtE, PCPlus4E;
    input BranchE,JumpE, ALUSrcE;
    input [2:0]RegWriteE;
    input [1:0]MemWriteE;
//    input [2:0]ALUControlE;
    input [5:0]ALUControlE;
    input [4:0]RDE;
    input [31:0]ResultW; // for hazard
    input [1:0]Forward_AE, Forward_BE,ResultSrcE;
    
    output [31:0]PCTargetE;
    output [31:0]ALUResultM, WriteDataM, PCPlus4M;
    output [4:0]RDM;
    output  PCSrcE;
    output [2:0]RegWriteM;
    output [1:0]MemWriteM;
    output [1:0]ResultSrcM;
//    output 
    
    //intermediate registers
    reg [2:0]RegWriteE_r;
    reg [1:0]ResultSrcE_r, MemWriteE_r;
//    reg [2:0]ALUControlE_r;
    reg [5:0]ALUControlE_r;
    reg [31:0]ResultE_r, WriteDataE_r, PCPlus4E_r;
    reg [4:0]RDE_r;
    
    wire zeroE;
    wire [31:0]SrcBE, ResultE, SrcAE, SrcBE_haz;
    
    ALU ALU(
    .A(SrcAE), 
    .B(SrcBE), 
    .Result(ResultE), 
    .Carry(), 
    .Zero(zeroE), 
    .Negative(), 
    .OverFlow(), 
    .ALUControl(ALUControlE)
    );
    
    Mux3 Mux3a(
    .a(RD1E), 
    .b(ResultW), 
    .c(ALUResultM), 
    .s(Forward_AE), 
    .y(SrcAE)
    );
    
     Mux3 Mux3b(
    .a(RD2E), 
    .b(ResultW), 
    .c(ALUResultM), 
    .s(Forward_BE), 
    .y(SrcBE_haz)
    );
    
    Mux ALU_mux(
    .Y(SrcBE), 
    .A(SrcBE_haz), 
    .B(ImmExtE), 
    .S(ALUSrcE)
    );
    
    PC_Adder PC_Adder(
    .a(PCE), 
    .b(ImmExtE), 
    .sum(PCTargetE)
    );
    
  
    always @(posedge clk or negedge rst) begin
        if(rst==1'b0) begin
            RegWriteE_r <=3'b000;
            ResultSrcE_r <=2'b00;
            MemWriteE_r <=2'b00;
            ResultE_r<=32'h0000_0000;
            WriteDataE_r <=32'h0000_0000;
            RDE_r <=5'h00;
            PCPlus4E_r <=32'h0000_0000;
        end
        else begin
            RegWriteE_r <=RegWriteE;
            ResultSrcE_r <=ResultSrcE;
            MemWriteE_r <=MemWriteE;
            ResultE_r<=ResultE;
//            WriteDataE_r <= RD2E;(without hazard unit)
            WriteDataE_r <=SrcBE_haz ;
            RDE_r <= RDE;
            PCPlus4E_r <=PCPlus4E;
        end
    end
    
    assign PCSrcE = (rst==1'b0)?1'b0:
                    ((zeroE & BranchE==1'b1)|JumpE)?1'b1:
                                                    1'b0;
 
    assign RegWriteM = (rst==1'b0)?3'b000:RegWriteE_r;
    assign ResultSrcM = (rst==1'b0)?2'b00:ResultSrcE_r;
    assign MemWriteM = (rst==1'b0)?2'b00:MemWriteE_r;
    assign ALUResultM = (rst==1'b0)?32'h0000_0000:ResultE_r;
    assign WriteDataM = (rst==1'b0)?32'h0000_0000:WriteDataE_r;
    assign RDM = (rst==1'b0)?5'b0_0000:RDE_r;
    assign PCPlus4M = (rst==1'b0)?32'h0000_0000:PCPlus4E_r;  
    
    
endmodule
