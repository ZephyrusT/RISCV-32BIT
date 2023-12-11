`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.10.2023 10:08:01
// Design Name: 
// Module Name: Reg_file
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
// Assembly level code : add x3, x1, x2;
// here the register file consists of the registers x1, x2, x3
//A 32 by 32register file accepting three 5 bit addresses and giving output RD1 and RD2 based on 
// the address input on A1 and A2 respectively. The other address is for writing in register file
// when write signal is enabled. Writing is performed on posedge clk.
//////////////////////////////////////////////////////////////////////////////////


module Reg_file(
    RD1, RD2,
    A1, A2, A3, WD3,
    clk, rst, WE3
//    digits_to_display //fpga to display
    );
    reg [31:0]Register_file[31:0]; //main reg_file of 32 by 32 bits
    input [31:0]WD3;
    input [4:0]A1, A2, A3;
    input clk, rst;
    input [2:0]WE3;
    output [31:0]RD1, RD2;
    integer i;
    assign RD1 = (!rst)?31'h00000000:Register_file[A1];
    assign RD2 = (!rst)?31'h00000000:Register_file[A2];
    always@(negedge clk or negedge rst) begin
    if(!rst) begin
         for(i=0; i<32; i=i+1) begin
                Register_file[i] <=32'h0000_0000;
            end
    end
    else
    if(WE3 == 3'b001) 
         Register_file[A3]<=WD3;   
    else if (WE3 == 3'b010)
        Register_file[A3] <=(WD3[7] ==1'b1)?{{24{1'b1}},WD3[7:0]}:WD3[7:0];   //lb
    else if (WE3 == 3'b011)    
        Register_file[A3] <=(WD3[15] ==1'b1)?{{16{1'b1}},WD3[15:0]}:WD3[15:0];   //lh  
    else if(WE3[2] == 1'b1)
        Register_file[A3] <=(WE3[0] ==1'b0)?WD3[7:0]:WD3[15:0];    // lbu and lbh
    end
    //check the WE3 signal
    // if we signal is 001==>
    
//    assign digits_to_display = Register_file[7];
    initial begin
     Register_file[0] = 32'h0000_0000;//hardwiring x0 register with value =0
//     Register_file[5] = 32'h0000_0009;
//     Register_file[4] = 32'h0000_00f0;
    end
endmodule
