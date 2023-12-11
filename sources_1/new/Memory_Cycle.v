`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Prabhat@51056
// 
// Create Date: 24.10.2023 12:06:51
// Design Name: 
// Module Name: Memory_Cycle
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
`include "Data_Memory.v"
module Memory_Cycle(
    clk, rst,
    ALUResultM, WriteDataM, PCPlus4M, RDM, RegWriteM,MemWriteM,ResultSrcM,
    RegWriteW, ResultSrcW, ALUResultW, ReadDataW, RDW,PCPlus4W,   
    read_data
    );
    input [31:0]ALUResultM, WriteDataM, PCPlus4M;
    input [4:0]RDM;
    input [2:0]RegWriteM;
    input [1:0]ResultSrcM, MemWriteM;
    input clk, rst;
    
    output [2:0]RegWriteW  ;
    output [31:0]ALUResultW, ReadDataW,PCPlus4W;
    output [4:0] RDW;
    output [1:0]ResultSrcW;
    output [31:0]read_data;
    
    wire[31:0]ReadDataM;
    
 // Intermediate Registers
    reg [2:0]RegWriteM_r;
    reg [1:0]ResultSrcM_r;
    reg [31:0]ALUResultM_r, ReadDataM_r, PCPlus4M_r;
    reg [4:0]RDM_r;
    
    Data_Memory Data_Memory(
    .A(ALUResultM), 
    .WD(WriteDataM), 
    .RD(ReadDataM), 
    .WE(MemWriteM), 
    .rst(rst), 
    .clk(clk),
    .read_data(read_data)
    );
    
    always @(posedge clk or negedge rst) begin
         if(rst==1'b0) begin
            ReadDataM_r<=32'h0000_0000;
            ALUResultM_r <=32'h0000_0000;
            RDM_r<=5'h00;
            PCPlus4M_r<=32'h0000_0000;
            RegWriteM_r<=3'b000;
            ResultSrcM_r<=2'b00;    
         end  
         else begin
            ReadDataM_r<=ReadDataM;
            ALUResultM_r <=ALUResultM;
            RDM_r<=RDM;
            PCPlus4M_r<=PCPlus4M;
            RegWriteM_r<=RegWriteM;
            ResultSrcM_r<=ResultSrcM; 
         end        
    end
         assign ReadDataW = (rst==1'b0)?1'b0:ReadDataM_r;
         assign ALUResultW = (rst==1'b0)?32'h0000_0000:ALUResultM_r;
         assign RDW = (rst==1'b0)?5'b0_0000:RDM_r;
         assign PCPlus4W = (rst==1'b0)?32'h0000_0000:PCPlus4M_r;
         assign RegWriteW = (rst==1'b0)?3'b000:RegWriteM_r;
         assign ResultSrcW = (rst==1'b0)?2'b00:ResultSrcM_r;
endmodule
