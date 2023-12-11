`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Prabhat
// 
// Create Date: 23.10.2023 10:44:53
// Design Name: 
// Module Name: Fetch_Cycle
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
// Fetch cycle stage
//////////////////////////////////////////////////////////////////////////////////

`include "Instruction_Memory.v"
`include "Prog_count.v"
`include "Mux.v"
`include "PC_Adder.v"
module Fetch_Cycle(
    clk, rst, PCSrcE, PCTargetE, InstrD, PCD, PCPlus4D, en_sf, en_sd,FlushD
    );
    input clk, rst, PCSrcE, en_sf, en_sd,FlushD;
    input [31:0]PCTargetE;
    output [31:0]InstrD, PCD, PCPlus4D;
    wire [31:0]PC_F, PCF, PCPlus4F, InstrF;
    reg [31:0]InstrF_reg, PCF_reg, PCPlus4F_reg;
    Mux Mux(
        .Y(PC_F), 
        .A(PCPlus4F), 
        .B(PCTargetE), 
        .S(PCSrcE)
    );
    Prog_count Program_counter(
    .clk(clk), 
    .rst(rst),
    .PCNext(PC_F), 
    .PC(PCF),
    .en(en_sf)
    
    );
    Instruction_Memory IMEM(
        .A(PCF), 
        .rst(rst), 
        .RD(InstrF)
    );
    PC_Adder PC_Adder(
        .a(PCF), 
        .b(32'h0000_0004), 
        .sum(PCPlus4F)
    );
    
    always@(posedge clk or negedge rst) begin
     if(rst==1'b0 | FlushD==1'b1) begin
        InstrF_reg <= 32'h0000_0000;
        PCF_reg <= 32'h0000_0000; 
        PCPlus4F_reg<= 32'h0000_0000;
     end
     else if(!en_sd) begin
        InstrF_reg <= InstrF;
        PCF_reg <= PCF; 
        PCPlus4F_reg<= PCPlus4F;
        end
    end
    
    assign InstrD = (rst==1'b0)?32'h0000_0000:InstrF_reg;
    assign PCD = (rst==1'b0)?32'h0000_0000:PCF_reg;
    assign PCPlus4D = (rst==1'b0)?32'h0000_0000:PCPlus4F_reg;
    
endmodule
