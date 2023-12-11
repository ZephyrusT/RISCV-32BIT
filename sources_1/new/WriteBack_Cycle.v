`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Prabhat5156
// 
// Create Date: 24.10.2023 14:01:42
// Design Name: 
// Module Name: WriteBack_Cycle
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

`include "Mux3.v"
module WriteBack_Cycle(
         clk, rst,
          ResultW, ResultSrcW, ALUResultW, ReadDataW, PCPlus4W   
    );
    input clk, rst;
    input [1:0]ResultSrcW;
    input [31:0]PCPlus4W, ALUResultW, ReadDataW;
   
   output [31:0]ResultW;
   
    Mux3 Datamem_reg(
    .a(ALUResultW), 
    .b(ReadDataW), 
    .c(PCPlus4W), 
    .s(ResultSrcW), 
    .y(ResultW)
    );  
endmodule
