`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.11.2023 13:51:05
// Design Name: 
// Module Name: digits
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


module digits(
    clk_10Hz,
    reset,
    digit_reg,
    ones,
    tens,
    hundreds,
    thousands
    );
    input clk_10Hz,reset;
    input [31:0] digit_reg;
    output reg [3:0] ones,tens,hundreds,thousands;

    
    // ones reg control
    always @(posedge clk_10Hz or negedge reset)
        if(reset==1'b0)
            ones <= 0;
        else
            ones <= digit_reg[3:0];
         
    // tens reg control       
    always @(posedge clk_10Hz or negedge reset)
        if(reset==1'b0)
            tens <= 0;
        else
            tens <= digit_reg[7:4];
      
    // hundreds reg control              
    always @(posedge clk_10Hz or negedge reset)
        if(reset==1'b0)
            hundreds <= 0;
        else
             hundreds <= digit_reg[11:8];
     
    // thousands reg control                
    always @(posedge clk_10Hz or negedge reset)
        if(reset==1'b0)
            thousands <= 0;
        else

            thousands <= digit_reg[15:12];
  
endmodule
