`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/08 00:31:01
// Design Name: 
// Module Name: ID_EX
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


module ID_EX(
    input wire clk,
    input wire rst,
    input wire IF_ID_to_ID_EX_valid,
    input wire EX_MEM_allowin,
    output wire ID_EX_to_EX_MEM_valid,
    output wire ID_EX_allowin,
    //data
    input wire[31:0]in_ID_EX_EXIMM,
    output reg[31:0]out_ID_EX_EXIMM,

    input wire[31:0]in_ID_EX_rs,
    output reg[31:0]out_ID_EX_rs,

    input wire[31:0]in_ID_EX_rt,
    output reg[31:0]out_ID_EX_rt,

    input wire[31:0]in_ID_EX_directives,
    output reg[31:0]out_ID_EX_directives,
    //ctrl
    input wire in_ID_EX_rd_en,
    output reg out_ID_EX_rd_en,

    input wire in_ID_EX_alu_in1_sel,
    output reg out_ID_EX_alu_in1_sel,

    input wire in_ID_EX_alu_in2_se1,
    output reg out_ID_EX_alu_in2_se1,

    input wire [1:0]in_ID_EX_in_rd_sel,
    output reg [1:0]out_ID_EX_in_rd_sel,

    input wire in_ID_EX_DM_R,
    output reg out_ID_EX_DM_R,

    input wire in_ID_EX_DM_W,
    output reg out_ID_EX_DM_W,

    input wire [5:0]in_ID_EX_alu_option,
    output reg [5:0]out_ID_EX_alu_option,

    input wire [4:0]in_ID_EX_rd_addr,
    output reg [4:0]out_ID_EX_rd_addr,

    input wire [31:0]in_ID_EX_jal_addr,
    output reg [31:0]out_ID_EX_jal_addr,

    input wire in_ID_EX_in_pc_sel,
    output reg out_ID_EX_in_pc_sel,


    input wire[31:0] in_ID_EX_DM_addr_arbitration,
    output reg[31:0] out_ID_EX_DM_addr_arbitration,
    

    output reg ID_EX_valid
    );
   // reg ID_EX_valid;DM_addr_arbitration
    reg ID_EX_ready_go=1'b1;
    assign ID_EX_allowin=(!ID_EX_valid || ID_EX_ready_go && EX_MEM_allowin);
    assign ID_EX_to_EX_MEM_valid = ID_EX_valid && ID_EX_ready_go;

    always@(posedge clk)
        begin
            if(rst==1'b1)
                begin
                    ID_EX_valid<=1'b0;
                    out_ID_EX_EXIMM<=32'b0;
                    out_ID_EX_rs<=32'b0;
                    out_ID_EX_rt<=32'b0;
                    out_ID_EX_directives<=32'b0;
                    //ctrl
                    out_ID_EX_rd_en<=1'b0;
                    out_ID_EX_alu_in1_sel<=1'b0;
                    out_ID_EX_alu_in2_se1<=1'b0;
                    out_ID_EX_in_rd_sel<=2'b0;
                    out_ID_EX_DM_R<=1'b0;
                    out_ID_EX_DM_W<=1'b0;
                    out_ID_EX_alu_option<=6'b0;
                    out_ID_EX_rd_addr<=5'b0;
                    out_ID_EX_jal_addr<=32'b0;
                    out_ID_EX_in_pc_sel<=1'b0;

                    out_ID_EX_DM_addr_arbitration<=32'b0;
                end
            else if(ID_EX_allowin)
                begin
                    ID_EX_valid<=IF_ID_to_ID_EX_valid;
                end

            if(IF_ID_to_ID_EX_valid && ID_EX_allowin)
                begin
                    
                    out_ID_EX_EXIMM<=in_ID_EX_EXIMM;
                    out_ID_EX_rs<=in_ID_EX_rs;
                    out_ID_EX_rt<=in_ID_EX_rt;
                    out_ID_EX_directives<=in_ID_EX_directives;
                   //ctrl 
                    out_ID_EX_rd_en<=in_ID_EX_rd_en;
                    out_ID_EX_alu_in1_sel<=in_ID_EX_alu_in1_sel;
                    out_ID_EX_alu_in2_se1<=in_ID_EX_alu_in2_se1;
                    out_ID_EX_in_rd_sel<=in_ID_EX_in_rd_sel;
                    out_ID_EX_DM_R<=in_ID_EX_DM_R;
                    out_ID_EX_DM_W<=in_ID_EX_DM_W;
                    out_ID_EX_alu_option<=in_ID_EX_alu_option;
                    out_ID_EX_rd_addr<=in_ID_EX_rd_addr;

                    out_ID_EX_jal_addr<=in_ID_EX_jal_addr;
                    out_ID_EX_in_pc_sel<=in_ID_EX_in_pc_sel;

                    out_ID_EX_DM_addr_arbitration<=in_ID_EX_DM_addr_arbitration;
                end

        end
endmodule
