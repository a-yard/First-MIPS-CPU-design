`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/10 00:33:30
// Design Name: 
// Module Name: Compute_Addr
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


module Compute_Addr(
    input wire rst,
    input wire[31:0] EXIMM,
    input wire[31:0] nowpc,
    output reg[31:0] jal_addr,
    input wire [31:0] directives,
    input wire [31:0] rs_data
    );
    always@(*)
        begin
            if(rst==1'b1)
                begin
                    jal_addr=32'b0;
                end
            else
                begin
                    if(directives[31:26]==6'b000010 || directives[31:26]==6'b000011)
                        begin
                            jal_addr={nowpc[31:28],EXIMM[27:0]};
                        end
                    else if(directives[31:26]==6'b000000 && directives[5:0]==6'b001000)
                        begin
                            jal_addr=rs_data;
                        end
                    else
                        begin
                            jal_addr=EXIMM+nowpc;
                        end
                end
        end
endmodule
