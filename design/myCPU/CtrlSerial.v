`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/13 16:21:44
// Design Name: 
// Module Name: CtrlSerial
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

`define free 3'b000
`define TXD_1 3'b001
`define TXD_2 3'b010
`define RXD_1 3'b011
`define RXD_2 3'b100
`define RXD_3 3'b101

module CtrlSerial(
    input wire clk,
    input wire rst,
    output wire TxD,
    input wire RxD,
    input wire [31:0]cpu_addr,
    input wire cpu_r,
    input wire cpu_w,
    input wire [31:0]directives,
    output wire [7:0]cpu_DM_OUT,
    input wire[31:0]cpu_IN_DM,
    output wire cpu_no_stop,
    output wire [7:0] mydata
    );
    wire TxD_busy;
    wire RxD_data_ready;
	reg TxD_start;
	reg [7:0] TxD_data;
    reg RxD_clear;
	wire [7:0] RxD_data;
    reg [7:0]reg_RXD_DATA;
    reg [3:0] Serial_status_TXD;
   reg [3:0] Serial_status_RXD;
    wire in_Serial_addr_XD;
    assign in_Serial_addr_XD = (cpu_addr==32'hBFD003F8)?1'b1:1'b0;
    wire in_Serial_addr_no_XD;
    assign in_Serial_addr_no_XD = (cpu_addr==32'hBFD003FC)?1'b1:1'b0;

    async_transmitter async_transmitterobj(.clk(clk),.TxD_data(TxD_data),.TxD(TxD),.TxD_start(TxD_start),.TxD_busy(TxD_busy));
    async_receiver async_receiverobj(.clk(clk),.RxD(RxD),.RxD_data_ready(RxD_data_ready),.RxD_clear(RxD_clear),.RxD_data(RxD_data));
    assign cpu_no_stop =1'b1;//!TxD_busy;   
    assign cpu_DM_OUT = (in_Serial_addr_no_XD==1'b1)?{{5{1'b0}},RxD_data_ready,~TxD_busy}:reg_RXD_DATA;//:RxD_data;//
    

    assign mydata={1'b0,Serial_status_RXD,~RxD_clear,RxD_data_ready,~TxD_busy};//{{6{1'b0}},RxD_clear};


    wire Serial_TXD;
    assign Serial_TXD=(cpu_w==1'b0 && in_Serial_addr_XD&&TxD_busy==1'b0)?1'b1:1'b0;
   
    always@(posedge clk)
        begin
            if(rst==1'b1)
                begin
                    Serial_status_TXD<=3'b000;
                    TxD_data<=8'b0;
                    
                end
            else
                begin
                    
                    case(Serial_status_TXD)
                        `free:
                            begin//Serial_TXD
                                if(Serial_TXD==1'b1)
                                    begin
                                        TxD_data<=cpu_IN_DM[7:0];
                                        Serial_status_TXD<=`TXD_1;
                                    end
                            end
                        `TXD_1:
                            begin
                                TxD_start<=1'b1;
                                Serial_status_TXD<=`TXD_2;
                            end
                        `TXD_2:
                            begin
                                TxD_start<=1'b0;
                                Serial_status_TXD<=`free;
                            end
                       
                    endcase
                end
        end

   wire Serial_RXD;
   assign Serial_RXD = (cpu_r==1'b0 && in_Serial_addr_XD)?1'b1:1'b0;
    always@(posedge clk)
        begin
            if(rst==1'b1)
                begin
                    Serial_status_RXD<=3'b000;
                    reg_RXD_DATA<=8'b0;
                    RxD_clear<=1'b1;
                end
            else
                begin
                    case(Serial_status_RXD)
                        `free:
                            begin
                                RxD_clear=1'b0;//Serial_RXD
                                if(Serial_RXD==1'b1)
                                    begin
                                        if(RxD_data_ready==1'b1)
                                            begin
                                                reg_RXD_DATA<=RxD_data;
                                                Serial_status_RXD<=`RXD_1;
                                            end
                                    end
                            end

                        `RXD_1:
                            begin
                                RxD_clear<=1'b1;
                                Serial_status_RXD<=`free;
                                
                            end
                        default:
                            begin
                                Serial_status_RXD<=3'b000;
                                reg_RXD_DATA<=8'b0;
                                RxD_clear<=1'b0;
                            end
                        // `RXD_2:
                        //     begin
                        //         RxD_clear<=1'b0;
                        //         Serial_status_RXD<=`RXD_3;
                        //     end
                        // `RXD_3:
                        //     begin
                        //         RxD_clear<=1'b1;
                        //         Serial_status_RXD<=`free;
                        //     end
                    endcase
                end
        end

endmodule
