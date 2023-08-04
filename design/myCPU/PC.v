`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/07 11:35:51
// Design Name: 
// Module Name: PC
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


module PC(
    input wire rst,
    input wire clk,
    input wire IF_ID_allowin,
    output wire PC_to_IF_ID_valid,
    output reg[31:0] im_addr,
    input wire [31:0]nextpc,
    input wire pc_stop
    );
    wire pc_valid_in;
    assign pc_valid_in=1'b1;
   
    reg pc_valid;
    wire PC_ready_go;
    assign PC_ready_go=1'b1;//!pc_stop;
    assign PC_allowin = (!pc_valid || PC_ready_go && IF_ID_allowin);//&&!pc_stop;
    assign PC_to_IF_ID_valid = PC_ready_go && pc_valid;//&&!pc_stop;
    
   

    always@(posedge clk)
        begin
            if(rst==1'b1)
                begin
                    pc_valid<=1'b1;
                    im_addr<=32'h80000000;
                end
            else if(PC_allowin)
                begin
                    pc_valid<=pc_valid_in;
                end

            if(pc_valid_in && PC_allowin)
                begin
                    im_addr<=nextpc;
                end

        end
endmodule
