`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.10.2023 07:10:04
// Design Name: 
// Module Name: ALU_tb
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


module ALU_tb();
reg [31:0]A, B;
reg [2:0]ALUControl;
wire [31:0]Result;
wire Carry, Zero, Negative, OverFlow;
ALU ALu(A, B, Result, Carry, Zero, Negative, OverFlow, ALUControl);
initial begin 
ALUControl = 3'b000; A = 32'h0000_0000; B = 32'h0000_0000;
#10ALUControl = 3'b000; A = 32'h0000_0000; B = 32'h0000_0000;
#10ALUControl = 3'b000; A = 32'h0000_0001; B = 32'h0000_0005;
#10ALUControl = 3'b101; A = 32'h0000_0011; B = 32'h0000_0010;
#10ALUControl = 3'b011; A = 32'h0000_0110; B = 32'h1111_0000;
#10ALUControl = 3'b010; A = 32'h0000_1111; B = 32'h0000_1111;
end
endmodule
