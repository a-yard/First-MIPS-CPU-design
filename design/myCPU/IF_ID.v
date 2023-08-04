`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/08 00:29:29
// Design Name: 
// Module Name: IF_ID
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


module IF_ID(
    input wire rst,
    input wire clk,
    input wire ID_EX_allowin,
    input wire PC_to_IF_ID_valid,
    output wire IF_ID_to_ID_EX_valid,
    output wire IF_ID_allowin,
    //data
    input wire [31:0]in_IF_ID_directives,
    output reg [31:0]out_IF_ID_directives,

    input wire[31:0]in_IF_ID_im_addr,
    output reg[31:0]out_IF_ID_im_addr,
    input wire IF_ID_clear,
    input wire cpu_no_stop,
    input wire pc_stop
    );
    reg IF_ID_valid;
    wire IF_ID_ready_go;//=1'b1;
    assign IF_ID_ready_go=!pc_stop;
    assign IF_ID_allowin=(!IF_ID_valid||IF_ID_ready_go&&ID_EX_allowin);//&&cpu_no_stop;//&&!pc_stop;
    assign IF_ID_to_ID_EX_valid = IF_ID_ready_go&&IF_ID_valid;//&&cpu_no_stop;//&&!pc_stop;
    
    always@(posedge clk )
        begin
            if(rst==1'b1)
                begin
                    //初始�???
                    IF_ID_valid<=1'b0;
                    out_IF_ID_directives<=32'b0;
                    out_IF_ID_im_addr<=32'b0;
                end
            else if(IF_ID_allowin)
                begin
                    IF_ID_valid<=PC_to_IF_ID_valid;
                end

            if(PC_to_IF_ID_valid && IF_ID_allowin || IF_ID_clear)
                begin
                    if(IF_ID_clear==1'b0)
                        begin
                            out_IF_ID_directives<=in_IF_ID_directives;
                            out_IF_ID_im_addr<=in_IF_ID_im_addr;
                        end
                    else if(IF_ID_clear==1'b1)
                        begin
                            out_IF_ID_directives<=32'b0;
                            out_IF_ID_im_addr<=32'b0;
                        end
                end
        end
endmodule
