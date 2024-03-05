`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.10.2023 07:26:27
// Design Name: 
// Module Name: Instruction_Memory
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
// Takes in the address from the Program counter
// looks up what is present in that address of the Instruction memory
// and outputs that instruction through RD wire.
//////////////////////////////////////////////////////////////////////////////////


module Instruction_Memory(
    A, rst, RD
    );
    input [31:0]A;
    input rst;
    output [31:0]RD;
    reg [31:0] Mem[1024:0];// 1024 registers of 32 bits
    assign RD = (rst==1'b0)?32'h00000000:Mem[A[31:2]];
    //31:2 because the 2 LSBs in RISCv architecture is always 0.
    //So only the remaining bits are necessary to determine the
    //position. eg:- address                0 =>..0000_0000 
    //next address due to byte addressable  4=>..0000_0100<....last 2 digits insignificant as always 0
    //next address due to byte addressable  8=>..0000_1000
    //next address due to byte addressable  c=>..0001_0000            
    initial begin 
//    $readmemh("C:/Users/Prabhatangshu Phukan/Downloads/RISCV32_PROJECT/memfile.hex", Mem);
//    $readmemh("C:/Users/Prabhatangshu Phukan/Downloads/RISCV32_PROJECT/memfile_pipeline.hex", Mem);
//    $readmemh("C:/Users/Prabhatangshu Phukan/Downloads/RISCV32_PROJECT/fibonacci_x6.hex", Mem);
//    $readmemh("C:/Users/Prabhatangshu Phukan/Downloads/RISCV32_PROJECT/sum_x2.hex", Mem);
  //  $readmemh("C:/Users/Prabhatangshu Phukan/Downloads/RISCV32_PROJECT/memfile_pipeline.hex", Mem);
       $readmemh("C:/Users/Prabhatangshu Phukan/Downloads/RISCV32_PROJECT/lw_tb.hex", Mem);
//   $readmemh("C:/Users/Prabhatangshu Phukan/Downloads/RISCV32_PROJECT/fibonacci_with_stop.hex", Mem);
    end
//    initial begin 
//        Mem[0] = 32'hFFC4A303;    //lw x6, -4(x9)
//        Mem[1] = 32'h00832383;    //lw x7, 8(x6)
//        Mem[2] = 32'h0064A423;      //sw x6, 8(x9)
//        Mem[3] = 32'h00B62423;      //sw x11, 0x8(x12)
//        Mem[4] = 32'h0062E233;      //or x4, x5, x6
//    end
endmodule
