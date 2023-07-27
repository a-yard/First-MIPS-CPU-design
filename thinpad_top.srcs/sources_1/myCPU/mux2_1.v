`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/07 11:57:44
// Design Name: 
// Module Name: mux2_1
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


module mux2_1(
    input wire [31:0]in1,
    input wire [31:0]in2,
    input wire sel,
    output reg[31:0]out,
    input wire rst
    );
    
    always@(*)
    begin
        if(rst==1'b1)
        begin
            out=32'b0;
        end
        else if(rst==1'b0)
        begin
            
            if(sel==1'b1)
                begin
                     out=in2;
                end
            else if(sel==1'b0)
                begin
                    out=in1;
                end
            else
                begin
                    out=32'b0;
                end
        end
        else
        begin
            out=32'b0;
        end
    end
endmodule
