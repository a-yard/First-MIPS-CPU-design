`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/09 14:57:29
// Design Name: 
// Module Name: mux4_1
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


module mux4_1(
    input wire rst,
    input wire [31:0]in1,
    input wire [31:0]in2,
    input wire [31:0]in3,
    input wire [31:0]in4,
    output reg[31:0]out,
    input wire [1:0]sel,
    input wire clk
    );
    always@(*)
        begin
            if(rst==1'b1)
                begin
                    out=32'b0;
                end
            else if(rst==1'b0)
                begin
                    case(sel)
                        2'b00:
                            out=in1;
                        2'b01:
                            out=in2;
                        2'b10:
                            out=in3;
                        2'b11:
                            out=in4;
                        default:
                            out=32'b0;
                    endcase
                end
            else
                begin
                    out=32'b0;
                end
        end
endmodule
