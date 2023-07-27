`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/08 00:31:39
// Design Name: 
// Module Name: EX_MEM
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


module EX_MEM(
    input wire clk,
    input wire rst,
    input wire ID_EX_to_EX_MEM_valid,
    input wire MEM_WB_allowin,
    output wire EX_MEM_to_MEM_WB_valid,
    output wire EX_MEM_allowin,
    //data
    input wire[31:0]in_EX_MEM_alu_out,
    output reg[31:0]out_EX_MEM_alu_out,
    //ctrl
    input wire [1:0]in_EX_MEM_in_rd_sel,
    output reg [1:0]out_EX_MEM_in_rd_sel,

    input wire in_EX_MEM_in_rd_en,
    output reg out_EX_MEM_in_rd_en,

    input wire in_EX_MEM_DM_R,
    output reg out_EX_MEM_DM_R,

    input wire in_EX_MEM_DM_W,
    output reg out_EX_MEM_DM_W,

    input wire[4:0] in_EX_MEM_rd_addr,
    output reg[4:0] out_EX_MEM_rd_addr,

    input wire [31:0] in_EX_MEM_rt,
    output reg [31:0] out_EX_MEM_rt,

    input wire [3:0] in_EX_MEM_AccessStorage_manner,
    output reg [3:0] out_EX_MEM_AccessStorage_manner,

    input wire [31:0] in_EX_MEM_directives,
    output reg [31:0] out_EX_MEM_directives,

    input wire cpu_no_stop,

    output reg EX_MEM_valid
    );

    reg EX_MEM_ready_go=1'b1;
    assign EX_MEM_allowin = (!EX_MEM_valid || EX_MEM_ready_go && MEM_WB_allowin);//&&cpu_no_stop;
    assign EX_MEM_to_MEM_WB_valid = EX_MEM_ready_go && EX_MEM_valid;//&&cpu_no_stop;


    always@(posedge clk)
        begin
            if(rst==1'b1)
                begin
                    EX_MEM_valid<=1'b0;
                    out_EX_MEM_alu_out<=32'h80400000;
                    out_EX_MEM_in_rd_sel<=2'b0;
                    out_EX_MEM_in_rd_en<=1'b0;
                    out_EX_MEM_DM_R<=1'b0;
                    out_EX_MEM_DM_W<=1'b0;
                    out_EX_MEM_rd_addr<=5'b0;
                    out_EX_MEM_rt<=32'b0;
                    out_EX_MEM_AccessStorage_manner<=4'b0;
                    out_EX_MEM_directives<=32'b0;
                end
            else if(EX_MEM_allowin)
                begin
                    EX_MEM_valid<=ID_EX_to_EX_MEM_valid;
                end

            if(ID_EX_to_EX_MEM_valid && EX_MEM_allowin)
                begin
                    out_EX_MEM_alu_out<=in_EX_MEM_alu_out;
                    out_EX_MEM_in_rd_sel<=in_EX_MEM_in_rd_sel;
                    out_EX_MEM_in_rd_en<=in_EX_MEM_in_rd_en;
                    out_EX_MEM_DM_R<=in_EX_MEM_DM_R;
                    out_EX_MEM_DM_W<=in_EX_MEM_DM_W;
                    out_EX_MEM_rd_addr<=in_EX_MEM_rd_addr;
                    out_EX_MEM_rt<=in_EX_MEM_rt;
                    out_EX_MEM_AccessStorage_manner<=in_EX_MEM_AccessStorage_manner;
                    out_EX_MEM_directives<=in_EX_MEM_directives;
                end
        end
endmodule
