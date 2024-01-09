`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Prabhat
// 
// Create Date: 24.10.2023 17:26:04
// Design Name: 
// Module Name: Pipelined_Top_tb
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


module Pipelined_Top_tb();
reg clk, rst;
initial clk = 1'b0;
always begin
    clk=~clk;
    #20;
end
Pipelined_Top Pipelined_Top(
    .clk(clk), 
    .rst(rst)    
    );
    
initial begin
    rst<=1'b0;
    #50;
    rst<=1'b1;
    #10000;
    $finish;
end

endmodule
