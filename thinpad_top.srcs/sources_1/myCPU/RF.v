`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/07 12:08:24
// Design Name: 
// Module Name: RF
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


module RF(
    input wire clk,
    input wire rst,
    input wire [4:0]rs_addr,
    input wire[4:0]rt_addr,
    input wire[4:0]rd_addr,
    input wire rs_en,
    input wire rt_en,
    input wire rd_en,
    output reg[31:0]rs_data,
    output reg[31:0]rt_data,
    input wire [31:0]rd_data
    );
    //(*mark_debug = "true"*)
    reg [31:0]RF[31:0];
     initial begin
         RF[5'h0]=32'b0;
                    RF[5'h1]=32'b0;
                    RF[5'h2]=32'b0;
                    RF[5'h3]=32'b0;
                    RF[5'h4]=32'b0;
                    RF[5'h5]=32'b0;
                    RF[5'h6]=32'b0;
                    RF[5'h7]=32'b0;
                    RF[5'h8]=32'b0;
                    RF[5'h9]=32'b0;
                    RF[5'ha]=32'b0;
                    RF[5'hb]=32'b0;
                    RF[5'hc]=32'b0;
                    RF[5'hd]=32'b0;
                    RF[5'he]=32'b0;
                    RF[5'hf]=32'b0;
                    RF[5'h10]=32'b0;
                    RF[5'h11]=32'b0;
                    RF[5'h12]=32'b0;
                    RF[5'h13]=32'b0;
                    RF[5'h14]=32'b0;
                    RF[5'h15]=32'b0;
                    RF[5'h17]=32'b0;
                    RF[5'h18]=32'b0;
                    RF[5'h19]=32'b0;
                    RF[5'h1a]=32'b0;
                    RF[5'h1b]=32'b0;
                    RF[5'h1c]=32'b0;
                    RF[5'h1d]=32'b0;
                    RF[5'h1e]=32'b0;
                    RF[5'h1f]=32'b0;
    end
    //get rs
    always@(*)
        begin
            if(rst==1'b1)
                begin
                    rs_data=32'b0;
                end
            else 
                begin
                    if(rs_addr==5'b0)
                begin
                    rs_data=32'b0;
                end
            else 
                begin
                    if(rs_en==1'b1)
                        rs_data=RF[rs_addr];
                    else
                        rs_data=32'b0;    
                end
                end
        end
    //get rt
   always@(*)
       begin
           if(rst==1'b1)
               begin
                   rt_data=32'b0;
               end
           else 
               begin
                   if(rt_addr==5'b0)
                       begin
                           rt_data=32'b0;
                       end
                   else
                       begin
                           if(rt_en==1'b1)
                               rt_data=RF[rt_addr];
                       
                           else
                                 rt_data=32'b0;
                       end
               end
       end
    //set rd
    always@(posedge clk)
        begin
            if(rst==1'b0)
                begin
                    if(rd_addr!=5'b0 && rd_en==1'b1)
                        begin
                            RF[rd_addr]<=rd_data;
                        end
                end
        end


endmodule
