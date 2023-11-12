`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Prabhat
// 
// Create Date: 24.10.2023 14:20:21
// Design Name: 
// Module Name: Pipelined_Top
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

//`include "Prog_count.v"
//`include "PC_Adder.v"
//`include "Mux.v"
//`include "Instruction_Memory.v"
//`include "Control_Unit_Top.v"
//`include "Reg_file.v"
//`include "Sign_extend.v"
//`include "ALU.v"
//`include "Data_Memory.v"   

`include "Fetch_Cycle.v"
`include "Decode_Cycle.v"
`include "Execute_Cycle.v"
`include "Memory_Cycle.v"
`include "WriteBack_Cycle.v" 
`include "Hazard_Unit.v"
module Pipelined_Top(
     rst,clk_100MHz, seg, digit
     ,clk
    );
    input rst;
    input clk;
    input clk_100MHz;       // from Basys 3
    //fpga
    output [0:6] seg;       // 7 segment display segment pattern
    output [3:0] digit;      // 7 segment display anodes
    
//     wire clk; //fpga modification
     wire [31:0]PCTargetE, InstrD, PCD,PCPlus4D, ResultW,RD1E,RD2E,
          ImmExtE,PCE,PCPlus4E,PCPlus4M,WriteDataM,ALUResultM,PCPlus4W,
          ALUResultW,ReadDataW;
     wire [4:0]RDW,RDE,RDM, RS1E, RS2E, RS1D, RS2D;
     wire RegWriteE,PCSrcE,ALUSrcE,RegWriteW,JumpE,FlushE,
          MemWriteE,BranchE,RegWriteM,MemWriteM,en_sf,en_sd,RS1D_haz,RS2D_haz;
     wire [2:0]ALUControlE;
     wire [1:0]ForwardAE,ForwardBE,ResultSrcE,ResultSrcW,ResultSrcM; //for handling hazards
     wire [31:0]digits_to_display, read_data;
     
     //fpga wires
    wire [3:0] w1, w2, w3, w4;    
    //Fetch cycle
    Fetch_Cycle Fetch_Cycle( 
    .clk(clk), 
    .rst(rst), 
    .PCSrcE(PCSrcE), 
    .PCTargetE(PCTargetE), 
    .PCD(PCD), 
    .InstrD(InstrD),
    .PCPlus4D(PCPlus4D),
    .en_sf(en_sf), 
    .en_sd(en_sd),
    .FlushD(FlushD)
    );
    //Decode cycle
    Decode_Cycle Decode_Cycle(
    .clk(clk), 
    .rst(rst),
    .InstrD(InstrD), 
    .PCD(PCD), 
    .PCPlus4D(PCPlus4D),
    .RegWriteW(RegWriteW), 
    .RDW(RDW), 
    .ResultW(ResultW), 
    .RegWriteE(RegWriteE),
    .ALUSrcE(ALUSrcE), 
    .MemWriteE(MemWriteE),
    .JumpE(JumpE), 
    .ResultSrcE(ResultSrcE), 
    .BranchE(BranchE),
    .ALUControlE(ALUControlE), 
    .ImmExtE(ImmExtE),
    .PCE(PCE), 
    .RDE(RDE),
    .PCPlus4E(PCPlus4E),
    .RD1E(RD1E), 
    .RD2E(RD2E), 
    .RS1E(RS1E),
    .RS2E(RS2E),
    //stalling logic
    .RS1D_haz(RS1D),
    .RS2D_haz(RS2D),
    .Flush(FlushE) 
//    .digits_to_display()//"digits_to_display" for fpga
    );
    //Execute cycle
    Execute_Cycle Execute_Cycle(
    .clk(clk), 
    .rst(rst),
    .RegWriteE(RegWriteE), 
    .ResultSrcE(ResultSrcE), 
    .MemWriteE(MemWriteE), 
    .BranchE(BranchE), 
    .JumpE(JumpE),
    .ALUControlE(ALUControlE), 
    .ALUSrcE(ALUSrcE),
    .RD1E(RD1E), 
    .RD2E(RD2E), 
    .PCE(PCE), 
    .RDE(RDE), 
    .ImmExtE(ImmExtE), 
    .PCPlus4E(PCPlus4E),
    .PCTargetE(PCTargetE),
    .PCSrcE(PCSrcE),
    .ALUResultM(ALUResultM), 
    .WriteDataM(WriteDataM), 
    .PCPlus4M(PCPlus4M), 
    .RDM(RDM), 
    .RegWriteM(RegWriteM),
    .MemWriteM(MemWriteM),
    .ResultSrcM(ResultSrcM),
    .ResultW(ResultW),
    .Forward_AE(ForwardAE), 
    .Forward_BE(ForwardBE)
    );
    
    //Memory cycle
    Memory_Cycle Memory_Cycle(
    .clk(clk), 
    .rst(rst),
    .ALUResultM(ALUResultM), 
    .WriteDataM(WriteDataM), 
    .PCPlus4M(PCPlus4M), 
    .RDM(RDM), 
    .RegWriteM(RegWriteM),
    .MemWriteM(MemWriteM),
    .ResultSrcM(ResultSrcM),
    .RegWriteW(RegWriteW), 
    .ResultSrcW(ResultSrcW), 
    .ALUResultW(ALUResultW), 
    .ReadDataW(ReadDataW), 
    .RDW(RDW),
    .PCPlus4W(PCPlus4W),
    .read_data(read_data) // for fpga 
    );
    
    WriteBack_Cycle  WriteBack_Cycle(
         .clk(clk), 
         .rst(rst),
         .ResultW(ResultW), 
         .ResultSrcW(ResultSrcW), 
         .ALUResultW(ALUResultW), 
         .ReadDataW(ReadDataW), 
         .PCPlus4W(PCPlus4W)   
    );
    Hazard_Unit hazard(
    .rst(rst), 
    .RegWriteM(RegWriteM), 
    .RegWriteW(RegWriteW), 
    .RDM(RDM), 
    .PCSrcE(PCSrcE),
    .RDW(RDW), 
    .RS1E(RS1E), 
    .RS2E(RS2E), 
    .ForwardAE(ForwardAE), 
    .ForwardBE(ForwardBE),
    .RS1D(RS1D),
    .RS2D(RS2D),
    .RDE(RDE),
    .StallD(en_sd), 
    .StallF(en_sf), 
    .FlushE(FlushE),
    .FlushD(FlushD),
    .ResultSrcE(ResultSrcE[0])
  );
  
  //7segment fpga modifications
  digits digits(
    .clk_10Hz(clk),
    .reset(rst),
    .digit_reg(read_data),
    .ones(w1),
    .tens(w2),
    .hundreds(w3),
    .thousands(w4)
    );
    
    tenHz_gen hz10(
    .clk_100MHz(clk_100MHz), 
    .reset(rst), 
    .clk_10Hz(clk));
    
    seg7_control seg7(
    .clk_100MHz(clk_100MHz), 
    .reset(rst), 
    .ones(w1), 
    .tens(w2),
    .hundreds(w3), 
    .thousands(w4), 
    .seg(seg), 
    .digit(digit));
  
    
endmodule
