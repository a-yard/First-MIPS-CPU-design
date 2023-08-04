`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/09 15:04:12
// Design Name: 
// Module Name: Compare
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


module Compare (
    input wire [31:0] in1,
    input wire [31:0] in2,
    output reg result,
    input wire [31:0] directives,
    input wire rst
);
  always @(*)
    if (rst == 1'b1) begin
      result = 1'b0;
    end else begin
      case (directives[31:26])
        6'b000101: begin
          if (in1 == in2) begin
            result = 1'b0;
          end else begin
            result = 1'b1;
          end
        end
        6'b000100: begin
          if (in1 != in2) begin
            result = 1'b0;
          end else begin
            result = 1'b1;
          end

        end
        //bgtz
        6'b000111: begin
          if (in1[31] == 1'b0) begin
            result = 1'b1;
          end else begin
            result = 1'b0;
          end
        end
        //BLTZ
        6'b000001:
          begin
            if (in1[31] == 1'b1) begin
            result = 1'b1;
          end else begin
            result = 1'b0;
          end
          end
        default: begin
          result = 1'b0;
        end
      endcase
    end
endmodule
