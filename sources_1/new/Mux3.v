`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.10.2023 23:14:04
// Design Name: 
// Module Name: Mux3
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


module Mux3(
    a, b, c, s, y
    );
    input [31:0]a, b, c;
    input [1:0]s;
    output [31:0]y;
    assign y = (s==2'b00)?a:
               (s==2'b01)?b:
               (s==2'b10)?c:
               32'h0000_0000;
endmodule
