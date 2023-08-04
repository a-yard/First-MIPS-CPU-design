`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/09 14:29:21
// Design Name: 
// Module Name: AccessStorage
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
`define status_IDLE 3'b000
`define status_READ_0 3'b001
`define status_READ_1 3'b010
`define status_WRITE_0 3'b011
`define status_WRITE_1 3'b100
 (* DONT_TOUCH = "yes" *)
module AccessStorage(
    //BaseRAM信号
    inout wire[31:0] base_ram_data,  //BaseRAM数据，低8位与CPLD串口控制器共�???????????
    output wire[19:0] base_ram_addr, //BaseRAM地址
    output wire[3:0] base_ram_be_n,  //BaseRAM字节使能，低有效。如果不使用字节使能，请保持�???????????0
    output wire base_ram_ce_n,       //BaseRAM片�?�，低有�???????????
    output wire base_ram_oe_n,       //BaseRAM读使能，低有�???????????
    output wire base_ram_we_n,       //BaseRAM写使能，低有�???????????

    //ExtRAM信号
    inout wire[31:0] ext_ram_data,  //ExtRAM数据
    output wire[19:0] ext_ram_addr, //ExtRAM地址
    output wire[3:0] ext_ram_be_n,  //ExtRAM字节使能，低有效。如果不使用字节使能，请保持�???????????0
    output wire ext_ram_ce_n,       //ExtRAM片�?�，低有�???????????
    output wire ext_ram_oe_n,       //ExtRAM读使能，低有�???????????
    output wire ext_ram_we_n,       //ExtRAM写使能，低有�???????????


    input wire rst,
    input wire[31:0]IM_addr,
    input wire[31:0]DM_addr,
    input wire cpu_R_en,
    input wire cpu_W_en,
    input wire [31:0]IN_DM,
    output reg[31:0]IM_out,
    output reg[31:0]DM_out,

    output wire pc_stop,
    input wire [3:0]cpu_EX_MEM_AccessStorage_manner,

    input wire AccessStorage_valid
    );



//DM_ADDR 
wire in_base_addr;
assign in_base_addr=(DM_addr>=32'h80000000&&DM_addr<=32'h803fffff)?1'b1:1'b0;
wire in_ext_addr;
assign in_ext_addr =  (DM_addr>=32'h80400000&&DM_addr<=32'h807fffff)?1'b1:1'b0;


//baseram and extram bridge
wire base_data_z;

wire ext_data_z;


assign pc_stop =(AccessStorage_valid==1'b1 && in_base_addr && (cpu_R_en==1'b0 || cpu_W_en==1'b0))?1'b1:1'b0;
assign base_ram_data=(AccessStorage_valid==1'b1 && base_data_z==1'b0 )?IN_DM:32'bz;
assign base_data_z = ( AccessStorage_valid==1'b1 &&in_base_addr && (cpu_R_en==1'b1 && cpu_W_en==1'b0))?1'b0:1'b1;
assign base_ram_addr = (AccessStorage_valid==1'b1 && in_base_addr&& (cpu_R_en==1'b0 || cpu_W_en==1'b0))?{DM_addr[21:2]}:{{2{1'b0}},IM_addr[21:2]};
assign base_ram_be_n = 4'b0;
assign base_ram_ce_n = 1'b0;
assign base_ram_oe_n = (AccessStorage_valid==1'b1 && in_base_addr&& (cpu_R_en==1'b0 || cpu_W_en==1'b0))?cpu_R_en:1'b0;//***
assign base_ram_we_n = (AccessStorage_valid==1'b1 && in_base_addr&& (cpu_R_en==1'b0 || cpu_W_en==1'b0))?cpu_W_en:1'b1;//***

always@(*)
    begin
        if(!(AccessStorage_valid==1'b1 && in_base_addr && (cpu_R_en ==1'b0 || cpu_W_en==1'b0)))
            begin
                IM_out=base_ram_data;
            end
        else    
            begin
                IM_out=IM_out;
            end
    end
wire [31:0]DM_out_DATA;
//assign IM_out=(in_base_addr && (cpu_R_en ==1'b0 || cpu_W_en==1'b0))?base_ram_data:32'b0;
assign DM_out_DATA=(AccessStorage_valid==1'b1 && in_base_addr && (cpu_R_en==1'b0 && cpu_W_en==1'b1))?base_ram_data:ext_ram_data;
always@(*)
    begin
        if(rst==1'b1)
            begin
                DM_out=32'b0;
            end
        else
            begin
                case(cpu_EX_MEM_AccessStorage_manner)
                    4'b0000:
                        begin
                            DM_out=DM_out_DATA;
                        end
                    4'b1110:
                        begin
                            DM_out={{24{1'b0}},DM_out_DATA[7:0]};
                        end
                    4'b1101:
                        begin
                            DM_out={{24{1'b0}},DM_out_DATA[15:8]};
                        end
                    4'b1011:
                        begin
                            DM_out={{24{1'b0}},DM_out_DATA[23:16]};
                        end
                    4'b0111:
                        begin
                            DM_out={{24{1'b0}},DM_out_DATA[31:24]};
                        end
                   
                endcase
            end
    end

assign ext_ram_data = (ext_data_z==1'b1)?32'bz:IN_DM;
assign ext_data_z = (in_ext_addr && (cpu_R_en==1'b1 && cpu_W_en==1'b0))?1'b0:1'b1;
assign ext_ram_addr = {DM_addr[21:2]};
assign ext_ram_be_n = 4'b0;
assign ext_ram_ce_n = (AccessStorage_valid==1'b1 && in_ext_addr&&(cpu_R_en==1'b0 || cpu_W_en==1'b0))?1'b0:1'b1;
assign ext_ram_oe_n = (in_ext_addr&& (cpu_R_en==1'b0 && cpu_W_en==1'b1))?cpu_R_en:1'b1;
assign ext_ram_we_n = (in_ext_addr&& (cpu_R_en==1'b1 && cpu_W_en==1'b0))?cpu_W_en:1'b1;

































endmodule
