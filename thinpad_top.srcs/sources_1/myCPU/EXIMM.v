`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/07 13:22:25
// Design Name: 
// Module Name: EXIMM
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


module EXIMM(
    input wire rst,
    input wire [31:0]directives,
    output reg[31:0] IMM_DATA
    );
    always@(*)
        begin
            if(rst==1'b1)
                begin
                    IMM_DATA=32'b0;
                end
            else
                begin
                    case(directives[31:26])
                            //sll or srl
                            6'b000000:
                                begin
                                    IMM_DATA={{27{1'b0}},directives[10:6]};
                                end
                            //ori
                            6'b001101:
                                begin
                                    IMM_DATA={{16{1'b0}},directives[15:0]};
                                end
                            //xori
                            6'b001110:
                                begin
                                    IMM_DATA={{16{1'b0}},directives[15:0]};
                                end
                            //addi:
                            6'b001000:
                                begin
                                    IMM_DATA={{16{directives[15]}},directives[15:0]};
                                end
                            //addiu
                            6'b001001:
                                begin
                                    IMM_DATA={{16{directives[15]}},directives[15:0]};
                                end
                            //andi
                            6'b001100:
                                begin
                                    IMM_DATA={{16{1'b0}},directives[15:0]};
                                end
                            //lui
                            6'b001111:
                                begin
                                    IMM_DATA={directives[15:0],{16{1'b0}}};
                                end
                            
                            //bne
                            6'b000101:
                                begin
                                    IMM_DATA={{14{directives[15]}},directives[15:0],{2{1'b0}}};
                                end
                            //beq
                            6'b000100 :
                                begin
                                    IMM_DATA={{14{directives[15]}},directives[15:0],{2{1'b0}}};
                                end
                            //bgtz
                            6'b000111:
                                begin
                                    IMM_DATA={{14{directives[15]}},directives[15:0],{2{1'b0}}};
                                end
                            //BLTZ
                            6'b000001:
                                begin
                                    IMM_DATA={{14{directives[15]}},directives[15:0],{2{1'b0}}};
                                end
                            //lw
                            6'b100011:
                                begin
                                    IMM_DATA={{16{directives[15]}},directives[15:0]};
                                end
                            //lb
                            6'b100000:
                                begin
                                    IMM_DATA={{16{directives[15]}},directives[15:0]};
                                end
                            //sw
                            6'b101011:
                                begin
                                    IMM_DATA={{16{directives[15]}},directives[15:0]};
                                end
                            //sb
                            6'b101000:
                                begin
                                    IMM_DATA={{16{directives[15]}},directives[15:0]};
                                end
                            //j
                            6'b000010:
                                begin
                                    IMM_DATA={{4{1'b0}},directives[25:0],{2{1'b0}}};
                                end
                            //jal
                            6'b000011:
                                begin
                                    IMM_DATA={{4{1'b0}},directives[25:0],{2{1'b0}}};
                                end
                            default:    
                                begin
                                    IMM_DATA=32'b0;
                                end
                    endcase
                end

        end
endmodule
