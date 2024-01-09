`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.10.2023 11:17:09
// Design Name: 
// Module Name: Fetch_Cycle_tb
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


module Fetch_Cycle_tb();
    reg clk, rst, PCSrcE;
    reg [31:0]PCTargetE;
    wire [31:0] InstrD, PCD, PCPlus4D;
    Fetch_Cycle Fetch_Cycle(
        .clk(clk), 
        .rst(rst), 
        .PCSrcE(PCSrcE), 
        .PCTargetE(PCTargetE), 
        .InstrD(InstrD), 
        .PCD(PCD), 
        .PCPlus4D(PCPlus4D)
    );
    initial clk=1'b0;
    always begin
        clk = ~clk;
        #50;
    end
    initial begin
        rst <=1'b0;
        #200;
        rst <=1'b1;
        PCSrcE<=1'b0;
        PCTargetE<=32'h0000_0000;
        #500;
        $finish;
    end
endmodule
