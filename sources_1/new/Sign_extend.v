`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.10.2023 15:35:54
// Design Name: 
// Module Name: Sign_extend
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


module Sign_extend(
    Imm_Ext, In, ImmSrc
    );
    input [31:0]In;
    input [2:0]ImmSrc; //if 0 then sends extend block to extend it as I type Lw instruction or
                  // if 1 then sends extend block to extend it as S type Sw instruction
    output [31:0]Imm_Ext;
    assign Imm_Ext = (ImmSrc ==3'b000)?{{20{In[31]}}, In[31:20]}: //immediate lw
                     (ImmSrc ==3'b101)?{{27{1'b0}}, In[24:20]}:
                     
                     (ImmSrc ==3'b001)?({{20{In[31]}}, {In[31:25], In[11:7]}})://sw
                     
                     (ImmSrc ==3'b010)?({{19{In[31]}},{In[31],In[7],In[30:25],In[11:8]},1'b0})://branch..details of address of PC doesnot require the least significant bit 
                                                                                               //as it is always zero 0==>0, 4==>100, 8==>1000.
                     (ImmSrc ==3'b011)?({{12{In[31]}},{In[19:12],In[20],In[30:21],1'b0}})://jump and link
                     (ImmSrc ==3'b100)?({{In[31:12]},{12{1'b0}}})://lui
                     (ImmSrc == 3'b110)?({{27{1'b0}},In[31:20]})://csr immediate extension
                     32'h00000000;
endmodule
