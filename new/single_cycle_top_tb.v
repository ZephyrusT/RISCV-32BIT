`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.10.2023 10:44:20
// Design Name: 
// Module Name: single_cycle_top_tb
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


module single_cycle_top_tb();
    reg clk, rst;   
    single_cycle_top single_cycle_top(
        .clk(clk), 
        .rst(rst)
    );
    initial clk = 1'b1;
    always begin 
    clk = ~clk;
        #50;
    end
    initial begin 
        rst = 1'b0;
        #100;
        
        rst = 1'b1;
        #5000;
        $finish;
    end
endmodule
