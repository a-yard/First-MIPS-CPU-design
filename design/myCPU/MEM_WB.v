`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/08 00:32:15
// Design Name: 
// Module Name: MEM_WB
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


module MEM_WB(
    input wire clk,
    input wire rst,
    input wire EX_MEM_to_MEM_WB_valid,
    output wire MEM_WB_allowin,
    //data
    input wire[31:0]in_MEM_WB_in_rd_data,
    output reg[31:0]out_MEM_WB_in_rd_data,

    input wire[4:0]in_MEM_WB_rd_addr,
    output reg[4:0]out_MEM_WB_rd_addr,


    input wire in_MEM_WB_rd_en,
    output reg out_MEM_WB_rd_en,

    input wire [31:0]in_MEM_WB_directives,
    output reg [31:0]out_MEM_WB_directives,

    input wire cpu_no_stop,

    output reg MEM_WB_valid
    );
    //reg MEM_WB_valid;
    reg MEM_WB_ready_go=1'b1;

    assign MEM_WB_allowin=(!MEM_WB_valid || MEM_WB_ready_go);//&&cpu_no_stop;


    always@(posedge clk)
        begin
            if(rst==1'b1)
                begin
                    MEM_WB_valid<=1'b0;
                    out_MEM_WB_in_rd_data<=32'b0;
                    out_MEM_WB_rd_addr<=5'b0;
                    out_MEM_WB_rd_en<=1'b0;
                    out_MEM_WB_directives<=32'b0;
                end
            else if(MEM_WB_allowin)
                begin
                    MEM_WB_valid<=EX_MEM_to_MEM_WB_valid;
                end

            if(EX_MEM_to_MEM_WB_valid && MEM_WB_allowin)
                begin
                    out_MEM_WB_in_rd_data<=in_MEM_WB_in_rd_data;
                    out_MEM_WB_rd_addr<=in_MEM_WB_rd_addr;

                    out_MEM_WB_rd_en<=in_MEM_WB_rd_en;
                    out_MEM_WB_directives<=in_MEM_WB_directives;

                end
        end
endmodule
