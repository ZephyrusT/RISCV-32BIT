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
   CSR_reg_wrE,CSR_reg_rdE,CSR_wd_selectE, RD1E_RS1E_sel//csr modifications
    );
    input [31:0]InstrD, PCD, PCPlus4D, ResultW;
    input clk, rst;
    input [2:0]RegWriteW;
    input [4:0]RDW;
    input Flush;
    
    output [31:0]RD1E, RD2E, PCE, ImmExtE, PCPlus4E;
    output  BranchE, ALUSrcE, CSR_reg_wrE, CSR_reg_rdE;
    output [2:0]RegWriteE;
    output [1:0]CSR_wd_selectE, JumpE;
    output RD1E_RS1E_sel;
    
//    output [2:0]ALUControlE;
    output [5:0]ALUControlE;
    output [4:0]RS1E, RS2E, RDE;
    output [1:0]ResultSrcE, MemWriteE;
    output [4:0]RS1D_haz,RS2D_haz;
  //  output [31:0]digits_to_display; //fpga display
    
    wire [31:0]RD1D, RD2D, Imm_ExtD;
    wire ALUSrcD, BranchD; 
    wire [2:0]RegWriteD;
    wire [1:0]ResultSrcD, MemWriteD,JumpD;
    wire [2:0]ImmSrcD;
//    wire [2:0]ALUControlD;
    wire [5:0]ALUControlD;
    wire CSR_reg_wrD,CSR_reg_rdD;
    wire [1:0]CSR_wd_selectD;
    //Intermediate Registers
    reg [31:0]RD1D_r, RD2D_r, Imm_ExtD_r,PCD_r, PCPlus4D_r;
    reg ALUSrcD_r, BranchD_r,CSR_reg_wrD_r, CSR_reg_rdD_r; 
    reg [1:0]CSR_wd_selectD_r, JumpD_r;
    reg [2:0]RegWriteD_r;
    reg [1:0]ResultSrcD_r, MemWriteD_r;
    reg RD1D_RS1D_sel_r;
//    reg [2:0]ALUControlD_r;
    reg [5:0]ALUControlD_r;
    reg [4:0]RdD_r, RS1D_r, RS2D_r;
    wire RD1D_RS1D_sel;
    
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
    .Jump(JumpD),
    .CSR_reg_wr(CSR_reg_wrD),
    .CSR_reg_rd(CSR_reg_rdD),
    .RS1D(InstrD[19:15]), // for CSRs
    .RdD(InstrD[11:7]),
    .CSR_wd_select(CSR_wd_selectD), 
    .RD1_RS1_sel(RD1D_RS1D_sel)
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
            RegWriteD_r <=3'b000;
            ALUSrcD_r<=1'b0;
            MemWriteD_r<=2'b00;
            JumpD_r<=2'b00;
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
            CSR_reg_wrD_r<=1'b0;
            CSR_reg_rdD_r<=1'b0;
            CSR_wd_selectD_r<=2'b00;
            RD1D_RS1D_sel_r<=1'b0;
        end
     else if (Flush) begin
            RegWriteD_r <=3'b000;
            ALUSrcD_r<=1'b0;
            MemWriteD_r<=2'b00;
            JumpD_r<=2'b00;
            ResultSrcD_r<=2'b00;        //what signals to reset during flush
            BranchD_r<=1'b0;
            ALUControlD_r <=6'b000_000;
            CSR_reg_wrD_r<=1'b0;
            CSR_reg_rdD_r<=1'b0;
            CSR_wd_selectD_r<=2'b00;
            RD1D_RS1D_sel_r<=1'b0;
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
            CSR_reg_wrD_r<= CSR_reg_wrD;
            CSR_reg_rdD_r<= CSR_reg_rdD;
            CSR_wd_selectD_r<=CSR_wd_selectD;
            RD1D_RS1D_sel_r<=RD1D_RS1D_sel;
            
        end
       end
        assign RegWriteE = (rst==1'b0)?3'b000:RegWriteD_r;
        assign ResultSrcE = (rst==1'b0)?2'b00:ResultSrcD_r;
        assign MemWriteE = (rst==1'b0)?2'b00:MemWriteD_r;
        assign JumpE = (rst==1'b0)?2'b00:JumpD_r;
        assign BranchE = (rst==1'b0)?1'b0:BranchD_r;
        assign ALUControlE = (rst==1'b0)?6'b000_000:ALUControlD_r;
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
        
        //csr control
        assign CSR_reg_wrE = (rst==1'b0)?1'b0:CSR_reg_wrD_r;
        assign CSR_reg_rdE = (rst==1'b0)?1'b0:CSR_reg_rdD_r;
        assign CSR_wd_selectE = (rst == 1'b0)?2'b00:CSR_wd_selectD_r;
        assign RD1E_RS1E_sel = (rst == 1'b0)?1'b0:RD1D_RS1D_sel_r;
endmodule
