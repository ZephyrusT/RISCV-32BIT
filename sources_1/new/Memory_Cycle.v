`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Prabhat@51056
// 
// Create Date: 24.10.2023 12:06:51
// Design Name: 
// Module Name: Memory_Cycle
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
`include "Data_Memory.v"

module Memory_Cycle(
    clk, rst,
    ALUResultM, WriteDataM, PCPlus4M, RDM, RegWriteM,MemWriteM,ResultSrcM,PCM,ImmExtM,
    RegWriteW, ResultSrcW, ALUResultW, ReadDataW, RDW,PCPlus4W,RD1M,
    read_data,RS1M,
    CSR_reg_wrM,CSR_reg_rdM,CSR_rdataW,CSR_wd_selectM,RD1M_RS1M_sel
    );
    input [31:0]ALUResultM, WriteDataM, PCPlus4M, PCM, RD1M;
    input [31:0]ImmExtM;
    input [4:0]RDM,RS1M;
    input [2:0]RegWriteM;
    input [1:0]ResultSrcM, MemWriteM;
    input clk, rst;
    input CSR_reg_wrM,CSR_reg_rdM;
    input [1:0]CSR_wd_selectM;
    input RD1M_RS1M_sel;
    
    output [2:0]RegWriteW  ;
    output [31:0]ALUResultW, ReadDataW,PCPlus4W;
    output [4:0] RDW;
    output [1:0]ResultSrcW;
    output [31:0]read_data,CSR_rdataW;
    
    wire[31:0]ReadDataM,CSR_rdataM;
    wire [31:0]write_data;
    
 // Intermediate Registers
    reg [2:0]RegWriteM_r;
    reg [1:0]ResultSrcM_r;
    reg [31:0]ALUResultM_r, ReadDataM_r, PCPlus4M_r, CSR_rdataM_r;
    reg [4:0]RDM_r;
    
    Data_Memory Data_Memory(
    .A(ALUResultM), 
    .WD(WriteDataM), 
    .RD(ReadDataM), 
    .WE(MemWriteM), 
    .rst(rst), 
    .clk(clk),
    .read_data(read_data)
    );
    
    //csr reg addition
    //csr RD1 and RS1D mux select
    Mux csr_rd1_rs1d(
    .Y(write_data), 
    .A(RD1M), 
    .B({{27{1'b0}},{RS1M}}), 
    .S(RD1M_RS1M_sel)
    );
    
    CSR_block CSR_block(
    .clk(clk), 
    .rst(rst),
    .PC(PCM), 
    .Addr(ImmExtM[11:0]), 
    .write_data(write_data), 
    .rd_ctrl(CSR_reg_rdM),
    .wr_ctrl(CSR_reg_wrM),
    .int_exc(),
    .CSR_rdata(CSR_rdataM),
    .epc_evec(),
    .CSR_wd_selectM(CSR_wd_selectM)
    );
    
    always @(posedge clk or negedge rst) begin
         if(rst==1'b0) begin
            ReadDataM_r<=32'h0000_0000;
            ALUResultM_r <=32'h0000_0000;
            RDM_r<=5'h00;
            PCPlus4M_r<=32'h0000_0000;
            RegWriteM_r<=3'b000;
            ResultSrcM_r<=2'b00; 
            CSR_rdataM_r<=32'h0000_0000;   
         end  
         else begin
            ReadDataM_r<=ReadDataM;
            ALUResultM_r <=ALUResultM;
            RDM_r<=RDM;
            PCPlus4M_r<=PCPlus4M;
            RegWriteM_r<=RegWriteM;
            ResultSrcM_r<=ResultSrcM;
            CSR_rdataM_r<=CSR_rdataM; 
         end        
    end
         assign ReadDataW = (rst==1'b0)?1'b0:ReadDataM_r;
         assign ALUResultW = (rst==1'b0)?32'h0000_0000:ALUResultM_r;
         assign RDW = (rst==1'b0)?5'b0_0000:RDM_r;
         assign PCPlus4W = (rst==1'b0)?32'h0000_0000:PCPlus4M_r;
         assign RegWriteW = (rst==1'b0)?3'b000:RegWriteM_r;
         assign ResultSrcW = (rst==1'b0)?2'b00:ResultSrcM_r;
         assign CSR_rdataW = (rst==1'b0)?32'h0000_0000:CSR_rdataM_r;
endmodule
