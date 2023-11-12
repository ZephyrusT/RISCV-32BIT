`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.10.2023 08:44:47
// Design Name: 
// Module Name: Prog_count
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
// Consist of a reg which just takes the value
// of next value of program count and fed as the
// output of program counter. PCNext will be coming 
// from the processor. 
//////////////////////////////////////////////////////////////////////////////////


module Prog_count(
    clk, PCNext, PC, rst, en
    );
    input  clk, rst, en;
    input [31:0]PCNext;
    output reg [31:0]PC;
    always@(posedge clk or negedge rst) begin
        if(rst == 1'b0) PC<=32'h00000000;
        else if(!en) PC<=PCNext;
    end
endmodule
