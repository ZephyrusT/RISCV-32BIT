`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.10.2023 09:45:52
// Design Name: 
// Module Name: Main_Decoder
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


module Main_Decoder(Op,funct3,RS1D,RegWrite,Jump,ImmSrc,ALUSrc,MemWrite,ResultSrc,Branch,ALUOp, PCSrc,
        CSR_reg_wr,CSR_reg_rd,RdD,CSR_wd_select, RD1_RS1_sel);
    
//    input zero; not input in pipelined version 
    input [6:0]Op;
    input [2:0]funct3;
    input [4:0]RS1D, RdD;
    
    output  ALUSrc,Branch, PCSrc,Jump;
    output [2:0]RegWrite;
    output [1:0]ALUOp,ResultSrc,MemWrite;
    output [2:0]ImmSrc;
    output CSR_reg_wr,CSR_reg_rd;
    output [1:0]CSR_wd_select;
    output RD1_RS1_sel;
    
    wire branch;
    
    assign RegWrite = ((Op == 7'b0000011 & funct3 == 3'b010)| 
                        Op == 7'b0110011 |
                        Op == 7'b0010011 |//i-type
                        Op == 7'b1101111 |
                       (Op == 7'b1110011 & funct3 !==3'b000)|//csrrw
                        Op==7'b0110111) ? 3'b001 :
                        (Op == 7'b0000011 & funct3 == 3'b000)? 3'b010: //lb
                        (Op == 7'b0000011 & funct3 == 3'b001)? 3'b011: //lh
                        (Op == 7'b0000011 & funct3 == 3'b100)? 3'b100: //lbu
                        (Op == 7'b0000011 & funct3 == 3'b101)? 3'b101: //lhu
                        3'b000 ;
    //csr doesnot fall in any of the cases below so it takes the default 000 case for immediate extend 
    //But we have to concatenate the csr address input to only 12 bits 
    
    //incase of CSR with immediate field we need to have a case for immediate extension
    assign ImmSrc = (Op == 7'b1101111) ? 3'b011 :
                    (Op == 7'b0100011) ? 3'b001 : 
                    (Op == 7'b1100011) ? 3'b010 :   
                    (Op == 7'b0110111) ? 3'b100 :
                    (Op == 7'b1110011 &(funct3[2]==1'b1)) ? 3'b110://csr immediate extension
                    (Op ==7'b0010011 &
                    (funct3==3'b001|funct3==3'b101))?3'b101: //slli srli srai
                                         3'b000 ;
                                         
    assign ALUSrc = (Op == 7'b0000011 |
                     Op == 7'b0100011 |
                     Op == 7'b0010011 |//I-type
//                     Op == 7'b1110011 |
                     Op==7'b0110111) ? 1'b1 :1'b0 ;
                     
    assign MemWrite = (Op == 7'b0100011 & funct3 == 3'b010) ? 2'b01 : //sw
                      (Op == 7'b0100011 & funct3 == 3'b000) ? 2'b11 : //sb store byte      => 8 bits
                      (Op == 7'b0100011 & funct3 == 3'b001) ? 2'b10 : //sh store half word =>16 bits
                                           2'b00 ;
                                           
    assign ResultSrc =  (Op == 7'b0000011) ? 2'b01 :
                        (Op == 7'b0110011|Op == 7'b0010011) ? 2'b00 :
                        (Op == 7'b1110011)?2'b11://csrrw
                        (Op == 7'b1101111) ? 2'b10 :
                                            2'b00 ;
                                            
    assign Branch = (Op == 7'b1100011) ? 1'b1 :
                                         1'b0 ;
                                         
    assign ALUOp = (Op==7'b0110111)?2'b11:                       //load
                   (Op == 7'b0110011|Op == 7'b0010011) ? 2'b10 : //r-type and i-type
                   (Op == 7'b1100011) ? 2'b01 :                  //branch instructions
                                        2'b00 ; 
    assign Jump = (Op==7'b1101111)?1'b1:1'b0;           
   ///CSR logic below
   
   //Read is always performed if the instruction is any of these(CSRRS, CSRRC or CSRRSI, CSRRCI)
   //If the instruction is CSRRW or CSRRWI then we have to check if rd is equal to zero or not
   //if it is zero then the instruction shall not read the CSR.
   assign CSR_reg_rd = ((Op==7'b1110011 & funct3[1:0]!=2'b01)|((Op==7'b1110011 & funct3[1:0]==2'b01)&(RdD!=5'b000_00)))?1'b1:1'b0;
   //Write is always performed if the instruction is CSRRW or CSRRWI.
   //For the other instructions(CSRRS, CSRRC and CSRRSI, CSRRCI) the write 
   //is only performed if rs1 is not equal to x0. 
   assign CSR_reg_wr = ((Op==7'b1110011 & funct3[1:0] ==2'b01)|((Op==7'b1110011 & funct3[1:0] !=2'b01)&RS1D!=5'b000_00))?1'b1:1'b0;
   //opcode for generating CSR select lines for write data
   assign CSR_wd_select = (Op == 7'b1110011 & funct3[1:0] ==2'b01)?2'b00://csrrw and csrrwi                            
                          (Op == 7'b1110011 & funct3[1:0] ==2'b10)?2'b01://csrrs and csrrsi
                          (Op == 7'b1110011 & funct3[1:0] ==2'b11)?2'b10://csrrc and csrrci   
                                                                   2'b00;                    
   assign RD1_RS1_sel = (Op == 7'b1110011 & funct3[2]==1'b1)?1'b1:1'b0;//for csr register immediate and non immediate CSRRW,CSRRWI or others
                                                                      //if funct3[2] == 1 then rs1 is the immediate 
                                                                      //else the value located at destination RS1 is the write value.
                                                                             
endmodule

