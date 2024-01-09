`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.10.2023 07:25:12
// Design Name: 
// Module Name: Data_Memory
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
// It is like a intermediate memory which stores ALU computation results
// and uses it to store intermediate values of calculation through the 
// write data pin WD which can be later accessed with the Address A pin. 
//////////////////////////////////////////////////////////////////////////////////


module Data_Memory(
    A, WD, RD, WE, rst, clk,read_data
    );
    input [31:0]A, WD;
    output [31:0]RD;
    input  clk, rst;
    input [1:0]WE;
    output reg [31:0]read_data;
    integer i;
    reg [31:0]Data_Mem[1023:0];
    // Reading from data memory for fpga
    always @(posedge clk or negedge rst) begin
        if(!rst) begin
            for(i=0; i<32; i=i+1) begin
                read_data <=32'h00000000;
            end
        end
        else
            if (WE!=2'b00) begin
                read_data[3:0] <= Data_Mem[A]%10;
                read_data[7:4] <= (Data_Mem[A]/10)%10;
                read_data[11:8] <= (Data_Mem[A]/100)%10;
                read_data[15:12] <= (Data_Mem[A]/1000)%10;
        end
    end
    
    // Writing in data memory
     always@(WE) begin
        if(!rst) begin
            for(i=0; i<32; i=i+1) begin
                Data_Mem[i] <=32'h00000000;
            end
        end
        else 
            if(WE ==2'b01)
               Data_Mem[A]<=WD;
            else if(WE == 2'b11)
               Data_Mem[A]<=WD[7:0];
            else if(WE == 2'b10)
               Data_Mem[A]<=WD[15:0];
            
    end
        assign RD = Data_Mem[A];
//    initial begin 
//        Data_Mem[0] = 32'h0000_0000;
//        Data_Mem[10] = 32'h0000_00ff;
//        Data_Mem[4] = 32'h0000_0018;
//        Data_Mem[32] = 32'h0000_0045;
//    end   
endmodule
