`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/09 11:33:13
// Design Name: 
// Module Name: ID
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
module ID(
    input wire rst,
    input wire[31:0]directives,
    input wire Compare_result,
    output reg rs_en,
    output reg rt_en,
    output reg rd_en,
    output reg alu_in1_sel,
    output reg alu_in2_sel,
    output reg in_pc_sel,
    output reg[1:0] in_rd_sel,
    output reg DM_R,
    output reg DM_W,
    output reg [5:0] alu_option,
    output reg [4:0] rd_addr,
    output reg [4:0] rs_addr,

    output reg sel_rs_sel
    );
    always@(*)
        begin
            if(rst==1'b1)
                begin
                    rs_en=1'b0;
                    rt_en=1'b0;
                    rd_en=1'b0;
                    alu_in1_sel=1'b0;
                    alu_in2_sel=1'b0;
                    in_pc_sel=1'b0;
                    in_rd_sel=2'b0;
                    DM_R=1'b0;
                    DM_W=1'b0;
                    alu_option=6'b000000;
                    rd_addr=5'b0;
                    rs_addr=5'b0;
                    sel_rs_sel=1'b0;
                end
            else
                begin
                    rs_addr=directives[25:21];
                    in_pc_sel=1'b0;
                    sel_rs_sel=1'b0;
                    case(directives[31:26])
                    //r �??
                        6'b000000:
                            begin
                                rs_en=1'b1;
                                rt_en=1'b1;
                                rd_en=1'b1;
                                alu_in1_sel=1'b0;
                                alu_in2_sel=1'b0;
                                in_rd_sel=2'b0;
                                DM_R=1'b0;
                                DM_W=1'b0;
                                rd_addr=directives[15:11];
                                case(directives[5:0])
                                    //SLT
                                    6'b101010:
                                        begin
                                            alu_option=6'b001001;
                                        end
                                    //SRAV
                                    6'b000111:
                                        begin
                                            alu_option = 6'b000111;
                                        end
                                    
                                    //addu
                                    6'b100001:
                                        begin
                                            alu_option=6'b000001;
                                        end
                                    //and
                                    6'b100100:
                                        begin
                                            alu_option=6'b000011;
                                        end
                                    //or
                                    6'b100101://100101
                                        begin
                                            alu_option=6'b000100;
                                        end
                                    //xor
                                    6'b100110://100110
                                        begin
                                            alu_option=6'b000101;
                                        end
                                    //sll
                                    6'b000000:
                                        begin
                                            alu_option=6'b000110;
                                            //rs_addr=directives[10:6];
                                            rs_en=1'b0;
                                            sel_rs_sel=1'b1;
                                        end
                                    //srl 
                                    6'b000010:
                                        begin
                                            alu_option=6'b001000;
                                            //rs_addr=directives[10:6];
                                            rs_en=1'b0;
                                            sel_rs_sel=1'b1;
                                        end
                                    //jr
                                    6'b001000:
                                        begin
                                            in_pc_sel=1'b1;
                                            rt_en=1'b0;
                                            rd_en=1'b0;
                                            alu_option=6'b000000;
                                        end
                                    default:
                                        begin
                                            alu_option=6'b000000;
                                        end
                                endcase
                            end
                    //mul
                        6'b011100:
                            begin
                                rs_en=1'b1;
                                rt_en=1'b1;
                                rd_en=1'b1;
                                alu_in1_sel=1'b0;
                                alu_in2_sel=1'b0;
                                in_rd_sel=2'b0;
                                DM_R=1'b0;
                                DM_W=1'b0;
                                rd_addr=directives[15:11];
                                alu_option=6'b001011;
                            end 
                    //ori
                        6'b001101://001101
                            begin
                                rs_en=1'b1;
                                rt_en=1'b0;
                                rd_en=1'b1;
                                alu_in1_sel=1'b0;
                                alu_in2_sel=1'b1;
                                in_rd_sel=2'b0;
                                DM_R=1'b0;
                                DM_W=1'b0;
                                alu_option=6'b000100;
                                rd_addr=directives[20:16];
                            end
                    //xori
                        6'b001110://001110
                            begin
                                rs_en=1'b1;
                                rt_en=1'b0;
                                rd_en=1'b1;
                                alu_in1_sel=1'b0;
                                alu_in2_sel=1'b1;
                                in_rd_sel=2'b0;
                                DM_R=1'b0;
                                DM_W=1'b0;
                                alu_option=6'b000101;
                                rd_addr=directives[20:16];
                            end
                    //addi
                        6'b001000://001000
                            begin
                                rs_en=1'b1;
                                rt_en=1'b0;
                                rd_en=1'b1;
                                alu_in1_sel=1'b0;
                                alu_in2_sel=1'b1;
                                in_rd_sel=2'b0;
                                DM_R=1'b0;
                                DM_W=1'b0;
                                alu_option=6'b000001;
                                rd_addr=directives[20:16];
                            end
                    //addiu
                    6'b001001://001001
                             begin
                                rs_en=1'b1;
                                rt_en=1'b0;
                                rd_en=1'b1;
                                alu_in1_sel=1'b0;
                                alu_in2_sel=1'b1;
                                in_rd_sel=2'b0;
                                DM_R=1'b0;
                                DM_W=1'b0;
                                alu_option=6'b000001;
                                rd_addr=directives[20:16];
                            end
                    //andi
                    6'b001100://001100 
                            begin
                                rs_en=1'b1;
                                rt_en=1'b0;
                                rd_en=1'b1;
                                alu_in1_sel=1'b0;
                                alu_in2_sel=1'b1;
                                in_rd_sel=2'b0;
                                DM_R=1'b0;
                                DM_W=1'b0;
                                alu_option=6'b000011;
                                rd_addr=directives[20:16];
                            end
                    //lw
                        6'b100011:
                            begin
                                rs_en=1'b1;
                                rt_en=1'b0;
                                rd_en=1'b1;
                                alu_in1_sel=1'b0;
                                alu_in2_sel=1'b1;
                                in_rd_sel=2'b01;
                                DM_R=1'b1;
                                DM_W=1'b0;
                                alu_option=6'b000001;
                                rd_addr=directives[20:16];
                            end
                    //lb
                        6'b100000:
                            begin
                                rs_en=1'b1;
                                rt_en=1'b0;
                                rd_en=1'b1;
                                alu_in1_sel=1'b0;
                                alu_in2_sel=1'b1;
                                in_rd_sel=2'b01;
                                DM_R=1'b1;
                                DM_W=1'b0;
                                alu_option=6'b000001;
                                rd_addr=directives[20:16];
                            end
                    //sw 
                        6'b101011:
                            begin
                                rs_en=1'b1;
                                rt_en=1'b1;
                                rd_en=1'b0;
                                alu_in1_sel=1'b0;
                                alu_in2_sel=1'b1;
                                in_rd_sel=2'b0;
                                DM_R=1'b0;
                                DM_W=1'b1;
                                alu_option=6'b000001;
                                rd_addr=5'b0;
                                
                            end
                    //sb
                        6'b101000:
                            begin
                                rs_en=1'b1;
                                rt_en=1'b1;
                                rd_en=1'b0;
                                alu_in1_sel=1'b0;
                                alu_in2_sel=1'b1;
                                in_rd_sel=2'b0;
                                DM_R=1'b0;
                                DM_W=1'b1;
                                alu_option=6'b000001;
                                rd_addr=5'b0;
                                
                            end
                    //bne
                        6'b000101:
                            begin
                                rs_en=1'b1;
                                rt_en=1'b1;
                                rd_en=1'b0;
                                alu_in1_sel=1'b0;
                                alu_in2_sel=1'b0;
                                in_rd_sel=2'b0;
                                DM_R=1'b0;
                                DM_W=1'b0;
                                alu_option=6'b000000;
                                rd_addr=5'b0;
                                in_pc_sel = Compare_result;
                                // if(Compare_result==1'b1)
                                //     begin
                                //         in_pc_sel=1'b1;
                                //     end
                                // else    
                                //     begin
                                //         in_pc_sel=1'b0;
                                //     end
                            end
                    //beq
                        6'b000100:
                            begin
                                rs_en=1'b1;
                                rt_en=1'b1;
                                rd_en=1'b0;
                                alu_in1_sel=1'b0;
                                alu_in2_sel=1'b0;
                                in_rd_sel=2'b0;
                                DM_R=1'b0;
                                DM_W=1'b0;
                                alu_option=6'b000000;
                                rd_addr=5'b0;
                                in_pc_sel = Compare_result;
                                // if(Compare_result==1'b1)
                                //     begin
                                //         in_pc_sel=1'b1;
                                //     end
                                // else    
                                //     begin
                                //         in_pc_sel=1'b0;
                                //     end
                            end
                    //bgtz
                    6'b000111:
                        begin
                                rs_en=1'b1;
                                rt_en=1'b0;
                                rd_en=1'b0;
                                alu_in1_sel=1'b0;
                                alu_in2_sel=1'b0;
                                in_rd_sel=2'b0;
                                DM_R=1'b0;
                                DM_W=1'b0;
                                alu_option=6'b000000;
                                rd_addr=5'b0;
                                in_pc_sel = Compare_result;
                                // if(Compare_result==1'b1)
                                //     begin
                                //         in_pc_sel=1'b1;
                                //     end
                                // else    
                                //     begin
                                //         in_pc_sel=1'b0;
                                //     end
                            end
                    //BLTZ
                        6'b000001:
                            begin
                                rs_en=1'b1;
                                rt_en=1'b0;
                                rd_en=1'b0;
                                alu_in1_sel=1'b0;
                                alu_in2_sel=1'b0;
                                in_rd_sel=2'b0;
                                DM_R=1'b0;
                                DM_W=1'b0;
                                alu_option=6'b000000;
                                rd_addr=5'b0;
                                in_pc_sel = Compare_result;
                                // if(Compare_result==1'b1)
                                //     begin
                                //         in_pc_sel=1'b1;
                                //     end
                                // else    
                                //     begin
                                //         in_pc_sel=1'b0;
                                //     end
                            end
                    //lui
                        6'b001111:
                            begin
                                rs_en=1'b0;
                                rt_en=1'b0;
                                rd_en=1'b1;
                                alu_in1_sel=1'b0;
                                alu_in2_sel=1'b1;
                                in_rd_sel=2'b0;
                                DM_R=1'b0;
                                DM_W=1'b0;
                                alu_option=6'b000001;
                                rd_addr=directives[20:16];
                            end
                    //j
                        6'b000010:
                            begin
                                rs_en=1'b0;
                                rt_en=1'b0;
                                rd_en=1'b0;
                                alu_in1_sel=1'b0;
                                alu_in2_sel=1'b0;
                                in_rd_sel=2'b0;
                                DM_R=1'b0;
                                DM_W=1'b0;
                                alu_option=6'b000000;
                                rd_addr=5'b0;
                                in_pc_sel=1'b1;
                               
                            end
                        //jal
                        6'b000011:
                            begin
                                rs_en=1'b0;
                                rt_en=1'b0;
                                rd_en=1'b1;
                                alu_in1_sel=1'b1;
                                alu_in2_sel=1'b0;
                                in_rd_sel=2'b0;
                                DM_R=1'b0;
                                DM_W=1'b0;
                                alu_option=6'b000000;
                                rd_addr=5'b11111;
                                in_pc_sel=1'b1;
                            end
                        default:
                            begin
                                rs_en=1'b0;
                                rt_en=1'b0;
                                rd_en=1'b0;
                                alu_in1_sel=1'b0;
                                alu_in2_sel=1'b0;
                                in_pc_sel=1'b0;
                                in_rd_sel=2'b0;
                                DM_R=1'b0;
                                DM_W=1'b0;
                                alu_option=6'b000000;
                                rd_addr=5'b0;
                                sel_rs_sel=1'b0;
                            end
                    endcase
                end
        end
endmodule
