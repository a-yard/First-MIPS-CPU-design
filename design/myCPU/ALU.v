`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/08 10:14:31
// Design Name: 
// Module Name: ALU
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

module ALU(
    input [31:0]A,
    input [31:0]B,
    output reg[31:0]result,
    input [5:0]opcode
    );
    wire signed [31:0] signed_A;
    assign signed_A = A;
    wire signed [31:0] signed_B;
    
    assign  signed_B = B;
    wire signed [63:0] tmp;
    assign tmp = signed_B * signed_A;
    always@(*)
    begin
        case(opcode)
            6'b000000:
                //mov
                result=A;
            6'b000001:
                //add
                result=A+B;
            6'b000010:
                //sub
                result = (~B+1)+A;
            6'b000011:
                //AND
                result = A&B;
            6'b000100:
                //or
                result = A | B;
            6'b000101:
                //xor
                result = A^B;
            6'b000110:
                //sll
                result = B<<A;
            6'b000111:
                //srl
                result = ($signed(B)) >>> A; //( {32{A[31]}} << ( 32'd32 - B ) ) | ( A >> B ) ;//$signed(A)>>>B;
            6'b001000:
                //sra
                result = B>>A;
            6'b001001:
                //slt
                if(($signed(A)-$signed(B))<0)
                    result = 32'h1;
                else 
                    result = 32'h0;
            6'b001010:
                //sltu
                if(((A-B)>>31)==32'b1)
                    result = 32'h1;
                else 
                    result = 32'h0; 
            6'b001011:
            //mul
                begin
                    //result = $signed(A) * $signed(B);
                    result = tmp[31:0];
                end   

            default:
                result=32'b0;
        endcase

    end

endmodule

