`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.10.2023 10:39:52
// Design Name: 
// Module Name: PC_Adder
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


module PC_Adder(
    a, b, sum
    );
    input [31:0]a, b;
    output [31:0]sum;
    
    assign sum = a+ b;
    
endmodule
