`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.10.2023 23:05:53
// Design Name: 
// Module Name: Hazard_Unit
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


module Hazard_Unit(
    rst, RegWriteM, RegWriteW, RDM, RDW, RS1E, RS2E, ForwardAE, ForwardBE,//forward wires
    RS1D, RS2D, RDE, StallD, StallF,FlushD, FlushE,ResultSrcE,PCSrcE
    );
    //forwarding ports
    input rst, RegWriteM, RegWriteW;
    input ResultSrcE, PCSrcE;
    input [4:0]RDM, RDW, RS1E, RS2E;
    output [1:0]ForwardAE, ForwardBE;
    //stalling ports
    input [4:0]RS1D, RS2D, RDE;
    output StallD, StallF, FlushE,FlushD;
    
//    assign ForwardAE = (rst ==1'b0)?2'b00:
//                        ((RegWriteM ==1'b1) &(RDM != 5'h00) &(RDM ==RS1E))?2'b10:
//                        ((RegWriteW ==1'b1) &(RDW != 5'h00) &(RDW ==RS1E))?2'b01:2'b00;
                        
//    assign ForwardBE = (rst ==1'b0)?2'b00:
//                        ((RegWriteM ==1'b1) &(RDM != 5'h00) &(RDM ==RS2E))?2'b10:
//                        ((RegWriteW ==1'b1) &(RDW != 5'h00) &(RDW ==RS2E))?2'b01:2'b00;
    //data forwarding logic
    assign ForwardAE = (rst ==1'b0)?2'b00:
                        ((RegWriteM ==1'b1) &(RS1E==RDM) &(RS1E!=0))?2'b10:
                        ((RegWriteW ==1'b1) &(RS1E==RDW) &(RS1E!=0))?2'b01:2'b00;
                        
    assign ForwardBE = (rst ==1'b0)?2'b00:
                        ((RegWriteM ==1'b1) &(RS2E==RDM) &(RS2E!=0))?2'b10:
                        ((RegWriteW ==1'b1) &(RS2E==RDW) &(RS2E!=0))?2'b01:2'b00;
//    stalling logic
    assign StallF = (((RS1D==RDE) | (RS2D == RDE))&ResultSrcE)?1'b1:1'b0;
    assign StallD = (((RS1D==RDE) | (RS2D == RDE))&ResultSrcE)?1'b1:1'b0;
    assign FlushE = ((((RS1D==RDE) | (RS2D == RDE))&ResultSrcE))|PCSrcE?1'b1:1'b0;
    assign FlushD = PCSrcE?1'b1:1'b0;
//    assign StallF = 0;
//    assign StallD = 0;
//    assign FlushD = 0;
//    assign FlushE =0;                    
endmodule
