`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/09 01:32:43
// Design Name: 
// Module Name: myMIPS
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


module myMIPS(
    input wire rst,
    input wire clk,
(*mark_debug = "true"*)    output wire[31:0]IM_addr,
(*mark_debug = "true"*)   input wire[31:0]IM_out,
(*mark_debug = "true"*)   output [31:0]DM_addr,
(*mark_debug = "true"*)    output wire R_en,
(*mark_debug = "true"*)    output wire W_en,
(*mark_debug = "true"*)    input wire[31:0]DM_out,
(*mark_debug = "true"*)    output wire [31:0]IN_DM,
    output wire [3:0]cpu_EX_MEM_AccessStorage_manner,

 
 (*mark_debug = "true"*)   input wire pc_stop_for_AccessStorage,
    input wire cpu_no_stop,
 (*mark_debug = "true"*)   output reg AccessStorage_valid
    );
    wire pc_stop;


    wire[31:0] NPC_nextpc;
    wire[31:0]inpc_sel_out;
    wire IF_ID_allowin;
    wire PC_to_IF_ID_valid;
    wire ID_EX_allowin;
    wire IF_ID_to_ID_EX_valid;
(*mark_debug = "true"*)wire [31:0]out_IF_ID_directives;
(*mark_debug = "true"*)   wire[31:0]out_IF_ID_im_addr;

    wire IF_ID_clear;
(*mark_debug = "true"*)    wire [31:0]IMM_DATA;
    wire [31:0]rs;
    wire [31:0]rt;
    wire Compare_result;
    wire rs_en;
    wire rt_en;
    wire rd_en;
    wire alu_in1_sel;
    wire alu_in2_se1;
(*mark_debug = "true"*)    wire in_pc_sel;
    wire[1:0] in_rd_sel;
    wire DM_R;
    wire DM_W;
    wire [5:0] alu_option;
    wire [4:0] rd_addr;
    wire [4:0] rs_addr;
    wire [31:0]jal_addr;
 (*mark_debug = "true"*)   wire [31:0]AssemblyLine_rs;
 (*mark_debug = "true"*)   wire [31:0]AssemblyLine_rt;
    wire EX_MEM_allowin;
    wire ID_EX_to_EX_MEM_valid;
    wire[31:0]out_ID_EX_EXIMM;
    wire[31:0]out_ID_EX_rs;
    wire[31:0]out_ID_EX_rt;
    (*mark_debug = "true"*)wire[31:0]out_ID_EX_directives;

    wire out_ID_EX_rd_en;
    wire out_ID_EX_alu_in1_sel;
    wire out_ID_EX_alu_in2_se1;
    wire [1:0]out_ID_EX_in_rd_sel;
    wire out_ID_EX_DM_R;
    wire out_ID_EX_DM_W;
    wire [5:0]out_ID_EX_alu_option;
    wire [4:0]out_ID_EX_rd_addr;
    wire [31:0]alu_in1_out;
    wire [31:0]alu_in2_out;
  (*mark_debug = "true"*)    wire [31:0]alu_out;
    wire MEM_WB_allowin;
    wire EX_MEM_to_MEM_WB_valid;
    wire[31:0]out_EX_MEM_alu_out;
    wire [1:0]out_EX_MEM_in_rd_sel;
    wire out_EX_MEM_in_rd_en;
    wire out_EX_MEM_DM_R;
    wire out_EX_MEM_DM_W;
    wire[4:0] out_EX_MEM_rd_addr;
    wire [31:0]out_EX_MEM_rt;
    wire [3:0] out_EX_MEM_AccessStorage_manner;
    wire [31:0]DM_DATA_out;
    wire [31:0]in_rd_data;
    wire [31:0]out_MEM_WB_in_rd_data;
    wire [4:0]out_MEM_WB_rd_addr;

    wire out_MEM_WB_rd_en;
    wire [1:0]CtrlAssemblyLinealu_in1_sel;
    wire [1:0]CtrlAssemblyLinealu_in2_sel;

    reg [3:0] AccessStorage_manner;
    wire IF_in_pc_sel;

 (*mark_debug = "true"*)   wire out_ID_EX_in_pc_sel;
    wire [31:0]out_ID_EX_jal_addr;
    (*mark_debug = "true"*)wire ID_EX_valid;

    (*mark_debug = "true"*)wire [31:0] out_EX_MEM_directives;
    (*mark_debug = "true"*)wire EX_MEM_valid;
    (*mark_debug = "true"*)wire [31:0]out_MEM_WB_directives;
    (*mark_debug = "true"*)wire MEM_WB_valid;

    NPC NPCobj(.nowpc(IM_addr),.nextpc(NPC_nextpc),.rst(rst));
//    wire [31:0]readly_jal_addr;
//    assign readly_jal_addr = (out_ID_EX_in_pc_sel==1'b1)?out_ID_EX_jal_addr:jal_addr;
    mux2_1 inpc_sel_obj(.rst(rst),.in1(NPC_nextpc),.in2(out_ID_EX_jal_addr),.sel(out_ID_EX_in_pc_sel),.out(inpc_sel_out));


    PC PCobj(.rst(rst),.clk(clk),.IF_ID_allowin(IF_ID_allowin),.PC_to_IF_ID_valid(PC_to_IF_ID_valid),.im_addr(IM_addr),.nextpc(inpc_sel_out),
    .pc_stop(pc_stop_for_AccessStorage)
    );

    










    IF_ID IF_IDobj(.rst(rst),.clk(clk),.ID_EX_allowin(ID_EX_allowin),.PC_to_IF_ID_valid(PC_to_IF_ID_valid),.IF_ID_to_ID_EX_valid(IF_ID_to_ID_EX_valid),
    .IF_ID_allowin(IF_ID_allowin),.in_IF_ID_directives(IM_out),.out_IF_ID_directives(out_IF_ID_directives),.in_IF_ID_im_addr(IM_addr),.out_IF_ID_im_addr(out_IF_ID_im_addr),
    .IF_ID_clear(IF_ID_clear),.cpu_no_stop(cpu_no_stop),.pc_stop(pc_stop)
    );
    








    Compute_Addr Compute_Addrobj(.rst(rst),.EXIMM(IMM_DATA),.nowpc(IM_addr),.jal_addr(jal_addr),.directives(out_IF_ID_directives),
    .rs_data(AssemblyLine_rs)
    );
    wire sel_rs_sel;
    EXIMM EXIMMobj(.rst(rst),.directives(out_IF_ID_directives),.IMM_DATA(IMM_DATA));
    ID IDobj(.rst(rst),.directives(out_IF_ID_directives),.Compare_result(Compare_result),.rs_en(rs_en),.rt_en(rt_en),.rd_en(rd_en),.alu_in1_sel(alu_in1_sel),
    .alu_in2_sel(alu_in2_se1),.in_pc_sel(in_pc_sel),.in_rd_sel(in_rd_sel),.DM_R(DM_R),.DM_W(DM_W),.alu_option(alu_option),.rd_addr(rd_addr),.rs_addr(rs_addr),
    .sel_rs_sel(sel_rs_sel)
    );

    RF RFobj(.rst(rst),.rs_addr(rs_addr),.rt_addr(out_IF_ID_directives[20:16]),.rd_addr(out_MEM_WB_rd_addr),.rs_en(rs_en),.rt_en(rt_en),
    .rd_en(out_MEM_WB_rd_en),.rs_data(rs),.rt_data(rt),.rd_data(out_MEM_WB_in_rd_data),.clk(clk)
    );

    Compare Compareobj(.in1(AssemblyLine_rs),.in2(AssemblyLine_rt),.result(Compare_result),.directives(out_IF_ID_directives),.rst(rst));
   
   //aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
    mux4_1 AssemblyLine_alu_in1obj(.rst(rst),.sel(CtrlAssemblyLinealu_in1_sel),.out(AssemblyLine_rs),.in1(rs),
    .in2(alu_out),.in3(out_EX_MEM_alu_out),.in4(out_MEM_WB_in_rd_data),.clk(clk)
    );
    mux4_1 AssemblyLine_alu_in2obj(.rst(rst),.sel(CtrlAssemblyLinealu_in2_sel),.out(AssemblyLine_rt),.in1(rt),
    .in2(alu_out),.in3(in_rd_data),.in4(out_MEM_WB_in_rd_data),.clk(clk)
    );
    wire [31:0] sel_rs_out;
    mux2_1 sel_rs(.rst(rst),.in1(AssemblyLine_rs),.in2(IMM_DATA),.out(sel_rs_out),.sel(sel_rs_sel));


    wire [31:0] DM_addr_arbitration;
    assign DM_addr_arbitration = IMM_DATA + AssemblyLine_rs;
    wire [31:0]out_ID_EX_DM_addr_arbitration;

    // wire in_ID_EX_in_pc_sel;
    // assign in_ID_EX_in_pc_sel = (in_pc_sel==1'b1 && pc_stop==1'b1)?1'b1:1'b0;

    ID_EX ID_EXobj(.clk(clk),.rst(rst),.IF_ID_to_ID_EX_valid(IF_ID_to_ID_EX_valid),.EX_MEM_allowin(EX_MEM_allowin),.ID_EX_to_EX_MEM_valid(ID_EX_to_EX_MEM_valid),
    .ID_EX_allowin(ID_EX_allowin),.in_ID_EX_EXIMM(IMM_DATA),.out_ID_EX_EXIMM(out_ID_EX_EXIMM),.in_ID_EX_rs(sel_rs_out),.out_ID_EX_rs(out_ID_EX_rs),
    .in_ID_EX_rt(AssemblyLine_rt),.out_ID_EX_rt(out_ID_EX_rt),.in_ID_EX_directives(out_IF_ID_directives),.out_ID_EX_directives(out_ID_EX_directives),
    .in_ID_EX_rd_en(rd_en),.out_ID_EX_rd_en(out_ID_EX_rd_en),.in_ID_EX_alu_in1_sel(alu_in1_sel),.out_ID_EX_alu_in1_sel(out_ID_EX_alu_in1_sel),
    .in_ID_EX_alu_in2_se1(alu_in2_se1),.out_ID_EX_alu_in2_se1(out_ID_EX_alu_in2_se1),.in_ID_EX_in_rd_sel(in_rd_sel),.out_ID_EX_in_rd_sel(out_ID_EX_in_rd_sel),
    .in_ID_EX_DM_R(DM_R),.out_ID_EX_DM_R(out_ID_EX_DM_R),.in_ID_EX_DM_W(DM_W),.out_ID_EX_DM_W(out_ID_EX_DM_W),.in_ID_EX_alu_option(alu_option),
    .out_ID_EX_alu_option(out_ID_EX_alu_option),.in_ID_EX_rd_addr(rd_addr),.out_ID_EX_rd_addr(out_ID_EX_rd_addr),
    .ID_EX_valid(ID_EX_valid),
    .in_ID_EX_in_pc_sel(in_pc_sel),.out_ID_EX_in_pc_sel(out_ID_EX_in_pc_sel),.in_ID_EX_jal_addr(jal_addr),.out_ID_EX_jal_addr(out_ID_EX_jal_addr),
    .in_ID_EX_DM_addr_arbitration(DM_addr_arbitration),.out_ID_EX_DM_addr_arbitration(out_ID_EX_DM_addr_arbitration)
    );

    







    mux2_1 alu_in1_obj(.rst(rst),.in1(out_ID_EX_rs),.in2(IM_addr),.sel(out_ID_EX_alu_in1_sel),.out(alu_in1_out));

    mux2_1 alu_in2_obj(.rst(rst),.in1(out_ID_EX_rt),.in2(out_ID_EX_EXIMM),.sel(out_ID_EX_alu_in2_se1),.out(alu_in2_out));
    
    ALU ALUobj(.A(alu_in1_out),.B(alu_in2_out),.result(alu_out),.opcode(out_ID_EX_alu_option));
    
  //  assign AccessStorage_manner={~alu_out[3],~alu_out[2],~alu_out[1],~alu_out[0]};

    always@(*)
        begin
            if(rst==1'b1)
                begin
                    AccessStorage_manner=4'b0;
                end
            else    
                begin
                    if(out_ID_EX_directives[31:26]==6'b101000 || out_ID_EX_directives[31:26]==6'b100000)
                        begin
                            case(alu_out[1:0])
                                2'b00:
                                    begin
                                        AccessStorage_manner=4'b1110;
                                    end
                                2'b01:
                                    begin
                                        AccessStorage_manner=4'b1101;
                                    end
                                2'b10:
                                    begin
                                        AccessStorage_manner=4'b1011;
                                    end
                                2'b11:
                                    begin
                                        AccessStorage_manner=4'b0111;
                                    end
                            endcase
                        end
                    else
                        begin
                            AccessStorage_manner=4'b0;
                        end
                end
        end




    
    EX_MEM EX_MEMobj(.clk(clk),.rst(rst),.ID_EX_to_EX_MEM_valid(ID_EX_to_EX_MEM_valid),.MEM_WB_allowin(MEM_WB_allowin),
    .EX_MEM_to_MEM_WB_valid(EX_MEM_to_MEM_WB_valid),.EX_MEM_allowin(EX_MEM_allowin),.in_EX_MEM_alu_out(alu_out),.out_EX_MEM_alu_out(out_EX_MEM_alu_out),
    .in_EX_MEM_in_rd_sel(out_ID_EX_in_rd_sel),.out_EX_MEM_in_rd_sel(out_EX_MEM_in_rd_sel),.in_EX_MEM_DM_R(out_ID_EX_DM_R),.out_EX_MEM_DM_R(out_EX_MEM_DM_R),
    .in_EX_MEM_DM_W(out_ID_EX_DM_W),.out_EX_MEM_DM_W(out_EX_MEM_DM_W),.in_EX_MEM_rd_addr(out_ID_EX_rd_addr),.out_EX_MEM_rd_addr(out_EX_MEM_rd_addr),
    .in_EX_MEM_in_rd_en(out_ID_EX_rd_en),.out_EX_MEM_in_rd_en(out_EX_MEM_in_rd_en),.in_EX_MEM_rt(out_ID_EX_rt),.out_EX_MEM_rt(out_EX_MEM_rt),
    .in_EX_MEM_AccessStorage_manner(AccessStorage_manner),.out_EX_MEM_AccessStorage_manner(out_EX_MEM_AccessStorage_manner),
    .cpu_no_stop(cpu_no_stop),.in_EX_MEM_directives(out_ID_EX_directives),.out_EX_MEM_directives(out_EX_MEM_directives),
    .EX_MEM_valid(EX_MEM_valid)
    );






    assign DM_addr=out_EX_MEM_alu_out;//out_EX_MEM_alu_out;
    assign R_en=!out_EX_MEM_DM_R;
    assign W_en=!out_EX_MEM_DM_W;
    
    assign DM_DATA_out=DM_out;
    assign IN_DM = out_EX_MEM_rt;
    assign cpu_EX_MEM_AccessStorage_manner = out_EX_MEM_AccessStorage_manner;
//    assign AccessStorage_valid = (EX_MEM_to_MEM_WB_valid==1'b1 && (out_EX_MEM_DM_R==1'b1 || out_EX_MEM_DM_W==1'b1))?1'b1:1'b0;
    always@(*)
        begin
            if(rst==1'b1)
                begin
                    AccessStorage_valid=1'b0;
                end
            else
                begin
                    AccessStorage_valid = (EX_MEM_to_MEM_WB_valid==1'b1 && (out_EX_MEM_DM_R==1'b1 || out_EX_MEM_DM_W==1'b1))?1'b1:1'b0;
                end
        end
    //aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
    mux4_1 mux4_1obj(.rst(rst),.sel(out_EX_MEM_in_rd_sel),.out(in_rd_data),.in1(out_EX_MEM_alu_out),.in2(DM_DATA_out),.in3(32'b0),
    .in4(32'b0),.clk(clk)
    );
    




    
    MEM_WB MEM_WBobj(.rst(rst),.clk(clk),.EX_MEM_to_MEM_WB_valid(EX_MEM_to_MEM_WB_valid),.MEM_WB_allowin(MEM_WB_allowin),.in_MEM_WB_in_rd_data(in_rd_data),
    .out_MEM_WB_in_rd_data(out_MEM_WB_in_rd_data),.in_MEM_WB_rd_addr(out_EX_MEM_rd_addr),.out_MEM_WB_rd_addr(out_MEM_WB_rd_addr),
    .in_MEM_WB_rd_en(out_EX_MEM_in_rd_en),.out_MEM_WB_rd_en(out_MEM_WB_rd_en),.cpu_no_stop(cpu_no_stop),.in_MEM_WB_directives(out_EX_MEM_directives),
    .out_MEM_WB_directives(out_MEM_WB_directives),.MEM_WB_valid(MEM_WB_valid)
    );
   










    
    CtrlAssemblyLine CtrlAssemblyLineobj(
    .MEM_rd_en(out_EX_MEM_in_rd_en),.MEM_rd_addr(out_EX_MEM_rd_addr),.WB_rd_en(out_MEM_WB_rd_en),.WB_rd_addr(out_MEM_WB_rd_addr),.EX_rd_en(out_ID_EX_rd_en),.EX_rd_addr(out_ID_EX_rd_addr),
    .alu_in1_sel(CtrlAssemblyLinealu_in1_sel),.alu_in2_sel(CtrlAssemblyLinealu_in2_sel),.IF_ID_clear(IF_ID_clear),.pr_directives(out_ID_EX_directives),
    .rst(rst),.rs_addr(rs_addr),.rt_addr(out_IF_ID_directives[20:16]),.rs_en(rs_en),.rt_en(rt_en),
    .pc_stop(pc_stop),.pc_stop_for_AccessStorage(pc_stop_for_AccessStorage),.clk(clk),.EX_directives(out_ID_EX_directives),
    .MEM_directives(out_EX_MEM_directives),.cpu_no_stop(cpu_no_stop),.WB_directives(out_MEM_WB_directives),
    .EX_vaild(ID_EX_valid),.MEM_vaild(EX_MEM_valid),.WB_vaild(MEM_WB_valid),.im_directives(out_IF_ID_directives),
    .in_pc_sel(in_pc_sel),.out_ID_EX_in_pc_sel(out_ID_EX_in_pc_sel),.IF_in_pc_sel(IF_in_pc_sel),.DM_addr(out_ID_EX_DM_addr_arbitration)
    );

endmodule
