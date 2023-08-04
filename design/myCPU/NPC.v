`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/07 11:36:04
// Design Name: 
// Module Name: NPC
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


module NPC(
input wire [31:0]nowpc,
output reg [31:0]nextpc,
input wire rst
    );
always @(*)
begin
    if(rst==1'b1)
        nextpc=32'h80000004;
    else if(rst==1'b0)
        nextpc=nowpc+4'h4;
    else
        nextpc=32'b0;
end
endmodule
