`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.12.2023 10:32:12
// Design Name: 
// Module Name: CSRreg
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


module CSR_block(
    clk, rst,
    PC, Addr, write_data, rd_ctrl,wr_ctrl,
    int_exc,
    CSR_rdata, epc_evec,CSR_wd_selectM
    );
    input clk, rst;
    input rd_ctrl,wr_ctrl;
    input [31:0]PC ,write_data;
    input int_exc;
    input [11:0]Addr;
    input [1:0]CSR_wd_selectM;
    output [31:0]CSR_rdata, epc_evec;
    
    wire [31:0]CSRRS_CSRRSI,CSRRC_CSRRCI,CSRRW_CSRRWI,mux_out;
    
    reg [31:0]CSR_reg[4095:0]; //4096 registers each of 32 bits
    
    integer i;
    
    localparam instret = 12'hC02,
               rdcycle = 12'hC00;
    
    assign CSRRW_CSRRWI = write_data;
    assign CSRRS_CSRRSI = write_data | CSR_reg[Addr];
    assign CSRRC_CSRRCI = ~(write_data)&CSR_reg[Addr];
    
    Mux3 mcsr(
    .a(CSRRW_CSRRWI), 
    .b(CSRRS_CSRRSI), 
    .c(CSRRC_CSRRCI),
    .d(), 
    .s(CSR_wd_selectM), 
    .y(mux_out)
    );
                
//               mip = 12'h344, 
//               mie = 12'h304, 
//               mstatus =12'h300, 
//               mcause = 12'h342, 
//               mtvec = 12'h305, 
//               mepc = 12'h341;
//               
    always@(PC) begin
        CSR_reg[instret] = CSR_reg[instret]+1;   //instret register  at 12'hC02
        CSR_reg[rdcycle] = CSR_reg[instret]*5+3; //rdcycle register
    end 
    

//Much like register here depending on the address the read/write operation is performed on the
//CSR and is read is high then only we are reading the output else we always get a zero at the output
 assign CSR_rdata = (rst == 1'b1 &(rd_ctrl == 1'b1))?CSR_reg[Addr]:32'h0000_0000;
    //writing in the negative edge             
     always @(posedge clk or negedge rst)
        if(!rst) begin
            for(i=0; i<4096; i=i+1) begin
                CSR_reg[i] <=32'h0000_0000;
            end
        end
        else 
            if(wr_ctrl ==1'b1 )begin
                CSR_reg[Addr] <=mux_out;
                      
//                    instret: CSR_reg[instret]<
//                    mip:  CSR_reg[mip]<=CSR_wr;
//                    mie: CSR_reg[mie]<=CSR_wr;
//                    mstatus: CSR_reg[mstatus]<=CSR_wr;
//                    mcause: CSR_reg[mcause]<=CSR_wr;
//                    mtvec:  CSR_reg[mtvec]<=CSR_wr;
//                    mepc:  CSR_reg[mepc]<=CSR_wr;
 end               
endmodule

