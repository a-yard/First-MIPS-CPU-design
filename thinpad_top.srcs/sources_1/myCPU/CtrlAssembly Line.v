`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/10 16:59:22
// Design Name: 
// Module Name: CtrlAssembly Line
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

 (* DONT_TOUCH = "yes" *)
module CtrlAssemblyLine(
    //for Data Harzard
    input wire clk,
    input wire rst,
    input wire [4:0] rs_addr,
    input wire [4:0] rt_addr,
    input wire rs_en,
    input wire rt_en,
    
    input MEM_rd_en,
    input [4:0]MEM_rd_addr,
    input wire MEM_vaild,

    input  WB_rd_en,
    input [4:0]WB_rd_addr,
    input wire WB_vaild,

    input EX_rd_en,
    input [4:0]EX_rd_addr,
    input wire EX_vaild,
   
    output reg [1:0]alu_in1_sel,
    output reg [1:0]alu_in2_sel,

    output reg IF_ID_clear,
    input wire in_pc_sel,
    input wire out_ID_EX_in_pc_sel,
    output wire IF_in_pc_sel,
    input wire [31:0]pr_directives,
    input wire [31:0] EX_directives,
    input wire [31:0] MEM_directives,
    input wire [31:0] WB_directives,
    input wire [31:0] im_directives,
    output wire pc_stop,
    input wire pc_stop_for_AccessStorage,
    input wire cpu_no_stop,
    input wire [31:0]DM_addr
    );
    wire in_lb ;
    assign in_lb = (EX_directives[31:26]==6'b100000 || MEM_directives[31:26]==6'b100000 || WB_directives[31:26]==6'b100000)?1'b1:1'b0;
    wire in_lw;
    assign in_lw = (EX_directives[31:26]==6'b100011  || MEM_directives[31:26]==6'b100011 || WB_directives[31:26]==6'b100011)?1'b1:1'b0;
    wire in_sb;
    reg flag;
    assign in_sb = (EX_directives[31:26]==6'b101000  || MEM_directives[31:26]==6'b101000 || WB_directives[31:26]==6'b101000)?1'b1:1'b0;
   assign pc_stop =(flag==1'b1 || cpu_no_stop==1'b0 )?1'b1:1'b0;
    
    wire in_base_addr;
    assign in_base_addr=(DM_addr>=32'h80000000&&DM_addr<=32'h803fffff)?1'b1:1'b0;

    assign IF_in_pc_sel = (pc_stop==1'b1)?in_pc_sel:out_ID_EX_in_pc_sel;


    always@(*)
        begin
            if(rst==1'b1)
                begin
                    flag=1'b0;
                end
            else
                begin
                    if(MEM_vaild==1'b0 && EX_vaild==1'b0)
                        begin
                            flag = 1'b0;            //SB 101000 SW 101011 
                                                    //LB 100000 LW 100011
                        end      //EX_directives[31:26]==6'b100011 || EX_directives[31:26]==6'b100000 || EX_directives[31:26]==6'b101011 || EX_directives[31:26]==6'b101000                                         //&&in_base_addr==1'b1
                    else if(((EX_directives[31:26]==6'b100011 || EX_directives[31:26]==6'b100000)&&((rs_addr==EX_rd_addr && rs_en == 1'b1)||(rt_addr==EX_rd_addr && rt_en == 1'b1))) || (EX_directives[31:26]==6'b101011  ) || pc_stop_for_AccessStorage==1'b1)
                        begin
                            flag = 1'b1;
                        end
                end
        end














    always@(*)
        begin
            if(rst==1'b1)
                begin
                    IF_ID_clear=1'b0;
                end
            else
                begin
                    if(pc_stop==1'b0)
                        begin
                            if(out_ID_EX_in_pc_sel==1'b1)
                        begin
                            IF_ID_clear=1'b1;
                        end
                    else
                        begin
                            IF_ID_clear=1'b0;
                        end
                        end
                    else
                        begin
                            IF_ID_clear=1'b0;
                        end
                end

        end

//FOR RS
    always@(*)
        begin
            if(rst==1'b1)
                begin
                    alu_in1_sel=2'b0;
                end
            else
                begin
                   
                    if(rs_en == 1'b1 && rs_addr!=5'b0)
                        begin                                   //rs_addr==EX_rd_addr && rs_en == 1'b1
                        //      if(pc_stop==1'b1)               //rt_addr==EX_rd_addr && rt_en == 1'b1
                        //     begin
                        //         alu_in1_sel=2'b00;
                        //     end
                        // else
                            
                        //     begin
                            if(rs_addr==EX_rd_addr &&  EX_rd_en==1'b1 &&EX_vaild==1'b1)
                                begin
                                    alu_in1_sel=2'b01;
                                end
                            else if(rs_addr==MEM_rd_addr &&  MEM_rd_en==1'b1 && MEM_vaild==1'b1)
                                begin
                                    alu_in1_sel=2'b10;
                                end
                            else if(rs_addr==WB_rd_addr &&  WB_rd_en==1'b1 && WB_vaild==1'b1)
                                begin
                                    alu_in1_sel=2'b11;
                                end
                            else
                                begin
                                    alu_in1_sel=2'b0;
                                end
                     //   end
                        end
                    else
                        begin
                            alu_in1_sel=2'b0;
                        end
                end
        end
//FOR RT
    always@(*)
        begin
            if(rst==1'b1)
                begin
                    alu_in2_sel=2'b0;
                end
            else
                begin
                    if(rt_en == 1'b1 && rt_addr!=5'b0)
                        begin
                            // if(pc_stop==1'b1)
                            //  begin
                            //     alu_in2_sel=2'b00;
                            // end
                            // else
                           
                            //begin
                            if(rt_addr==EX_rd_addr &&  EX_rd_en==1'b1&&EX_vaild==1'b1)
                                begin
                                    alu_in2_sel=2'b01;
                                end
                            else if(rt_addr==MEM_rd_addr &&  MEM_rd_en==1'b1&&MEM_vaild==1'b1)
                                begin
                                    alu_in2_sel=2'b10;
                                end
                            else if(rt_addr==WB_rd_addr &&  WB_rd_en==1'b1&&WB_vaild==1'b1)
                                begin
                                    alu_in2_sel=2'b11;
                                end
                            else
                                begin
                                    alu_in2_sel=2'b0;
                                end
                       //     end
                        end
                    else
                        begin
                            alu_in2_sel=2'b0;
                        end
                        
                end
        end

endmodule
//    wire flag;//pc_stop_for_AccessStorage==1'b1  ||
//     assign flag = ( im_directives[31:26]==6'b100000 || im_directives[31:26]==6'b100011 || im_directives[31:26]==6'b101000 || im_directives[31:26]==6'b101011)?1'b1:1'b0;
//     //assign pc_stop = (flag==1'b1 && flag2==1'b1)?1'b1:1'b0;
//     reg [2:0]status;
//     reg flag2;
//     always@(posedge clk)
//         if(rst==1'b1)
//             begin
//                 status<=3'b0;
//                 pc_stop<=1'b0;
//             end
//         else
//             begin
//                 case(status)
//                     3'b000:
//                         begin
//                             if(flag==1'b1)
//                                 begin
//                                    pc_stop<=1'b1;
//                                    status<=3'b01;
//                                 end
//                         end
//                     3'b001:
//                         begin
//                             status<=3'b010;
//                         end
//                     3'b010:
//                         begin
//                             status<=3'b011;
                            
//                         end
//                     3'b011:
//                         begin
//                             status<=3'b100;
//                         end
//                     3'b100:
//                         begin

//                             status<=3'b0;
//                         end
//                     3'b101:
//                         begin
//                             status<=3'b110;
                            
//                         end
//                     3'b110:
//                         begin
//                             pc_stop<=1'b0;
//                             status<=3'b111;
//                         end
//                     3'b111:
//                         begin
//                             status<=3'b0;
//                         end
//                 endcase 
//             end