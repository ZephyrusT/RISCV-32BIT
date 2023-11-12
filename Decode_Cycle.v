`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.10.2023 08:37:50
// Design Name: 
// Module Name: Decode_Cycle
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
`include "Reg_file.v"
`include "Sign_extend.v"
`include "Control_Unit_Top.v"

module Decode_Cycle(
    InstrD, PCD, PCPlus4D, 
    RegWriteE, ResultSrcE,JumpE, MemWriteE, BranchE, ALUControlE, ALUSrcE,
    RD1E, RD2E, PCE, RDE, ImmExtE, PCPlus4E, RS1E, RS2E,
    RegWriteW,RDW, ResultW,
    clk, rst,
    Flush,RS1D_haz,RS2D_haz,//stalling logic
   // digits_to_display ///fpga modifications
    );
    input [31:0]InstrD, PCD, PCPlus4D, ResultW;
    input clk, rst,RegWriteW;
    input [4:0]RDW;
    input Flush;
    
    output [31:0]RD1E, RD2E, PCE, ImmExtE, PCPlus4E;
    output RegWriteE, MemWriteE, BranchE, ALUSrcE, JumpE;
    output [2:0]ALUControlE;
    output [4:0]RS1E, RS2E, RDE;
    output [1:0]ResultSrcE;
    output [4:0]RS1D_haz,RS2D_haz;
  //  output [31:0]digits_to_display; //fpga display
    
    wire [31:0]RD1D, RD2D, Imm_ExtD;
    wire RegWriteD, MemWriteD, ALUSrcD, BranchD,JumpD; 
    wire [1:0]ResultSrcD;
    wire [2:0]ImmSrcD;
    wire [2:0]ALUControlD;
    //Intermediate Registers
    reg [31:0]RD1D_r, RD2D_r, Imm_ExtD_r,PCD_r, PCPlus4D_r;
    reg RegWriteD_r, MemWriteD_r, ALUSrcD_r, BranchD_r, JumpD_r; 
    reg [1:0]ResultSrcD_r;
    reg [2:0]ALUControlD_r;
    reg [4:0]RdD_r, RS1D_r, RS2D_r;
    
    Control_Unit_Top Control_Unit( 
    .Op(InstrD[6:0]),
    .funct3(InstrD[14:12]),
    .funct7(InstrD[31:25]),
    .RegWrite(RegWriteD),
    .ImmSrc(ImmSrcD),
    .ALUSrc(ALUSrcD),
    .MemWrite(MemWriteD),
    .ResultSrc(ResultSrcD),
    .Branch(BranchD),
    .ALUControl(ALUControlD),
    .Jump(JumpD)
    );
    
       
    
    Reg_file Reg_file(
    .RD1(RD1D), 
    .RD2(RD2D),
    .A1(InstrD[19:15]), 
    .A2(InstrD[24:20]), 
    .A3(RDW), 
    .WD3(ResultW),
    .clk(clk), 
    .rst(rst), 
    .WE3(RegWriteW)
    //.digits_to_display(digits_to_display)
    );
     
    Sign_extend Sign_extend(
    .Imm_Ext(Imm_ExtD), 
    .In(InstrD[31:0]), 
    .ImmSrc(ImmSrcD)
    );     
    //registers
    always@(posedge clk or negedge rst) begin
        if(rst==1'b0) begin
            RegWriteD_r <=1'b0;
            ALUSrcD_r<=1'b0;
            MemWriteD_r<=1'b0;
            JumpD_r<=1'b0;
            ResultSrcD_r<=2'b00;        //what signals to reset during stalling
            BranchD_r<=1'b0;
            ALUControlD_r <=3'b000;
            RD1D_r<=32'h0000_0000;
            RD2D_r<=32'h0000_0000;
            Imm_ExtD_r<=32'h0000_0000;
            RdD_r<=5'h00;
            PCD_r<=32'h0000_0000;
            PCPlus4D_r<=32'h0000_0000;
            RS1D_r <=5'h00;
            RS2D_r<=5'h00;
        end
     else if (Flush) begin
            RegWriteD_r <=1'b0;
            ALUSrcD_r<=1'b0;
            MemWriteD_r<=1'b0;
            JumpD_r<=1'b0;
            ResultSrcD_r<=2'b00;        //what signals to reset during stalling
            BranchD_r<=1'b0;
            ALUControlD_r <=3'b000;
end
        else begin
            RegWriteD_r <=RegWriteD;
            ResultSrcD_r<=ResultSrcD;
            MemWriteD_r<=MemWriteD;
            JumpD_r<=JumpD;
            BranchD_r<=BranchD;
            ALUControlD_r <=ALUControlD;
            ALUSrcD_r<=ALUSrcD;
            RD1D_r<=RD1D;
            RD2D_r<=RD2D;
            Imm_ExtD_r<=Imm_ExtD;
            RdD_r<=InstrD[11:7];
            PCD_r<=PCD;
            PCPlus4D_r<=PCPlus4D;
            RS1D_r <=InstrD[19:15];
            RS2D_r<=InstrD[24:20];
            
        end
       end
        assign RegWriteE = (rst==1'b0)?1'b0:RegWriteD_r;
        assign ResultSrcE = (rst==1'b0)?2'b00:ResultSrcD_r;
        assign MemWriteE = (rst==1'b0)?1'b0:MemWriteD_r;
        assign JumpE = (rst==1'b0)?1'b0:JumpD_r;
        assign BranchE = (rst==1'b0)?1'b0:BranchD_r;
        assign ALUControlE = (rst==1'b0)?3'b000:ALUControlD_r;
        assign ALUSrcE = (rst==1'b0)?1'b0:ALUSrcD_r;
        
        assign RD1E = (rst==1'b0)?32'h0000_0000:RD1D_r;
        assign RD2E = (rst==1'b0)?32'h0000_0000:RD2D_r;
        assign ImmExtE = (rst==1'b0)?32'h0000_0000:Imm_ExtD_r;
        assign RDE = (rst==1'b0)?5'b0_0000:RdD_r;        
        assign PCE = (rst==1'b0)?5'b0_0000:PCD_r;
        assign PCPlus4E = (rst==1'b0)?32'h0000_0000:PCPlus4D_r;
        assign RS1E = (rst==1'b0)?5'b0_0000:RS1D_r;
        assign RS2E = (rst==1'b0)?5'b0_0000:RS2D_r;
        //  Stalling logic
        assign RS1D_haz = (rst==1'b0)?5'b0_0000:InstrD[19:15];
        assign RS2D_haz = (rst==1'b0)?5'b0_0000:InstrD[24:20];
endmodule
