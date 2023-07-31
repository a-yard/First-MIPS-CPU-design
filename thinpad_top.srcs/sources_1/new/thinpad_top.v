`default_nettype none

module thinpad_top(
    input wire clk_50M,           //50MHz ʱ������
    input wire clk_11M0592,       //11.0592MHz ʱ�����루���ã��ɲ��ã�

    input wire clock_btn,         //BTN5�ֶ�ʱ�Ӱ�ť??????�أ���������·������ʱΪ1
    input wire reset_btn,         //BTN6�ֶ���λ��ť??????�أ���������·������ʱΪ1

    input  wire[3:0]  touch_btn,  //BTN1~BTN4����ť���أ�����ʱΪ1
    input  wire[31:0] dip_sw,     //32λ���뿪�أ�����"ON"ʱ??????1
    output wire[15:0] leds,       //16λLED�����ʱ1����
    output wire[7:0]  dpy0,       //����ܵ�λ�źţ�����С���㣬���1����
    output wire[7:0]  dpy1,       //����ܸ�λ�źţ�����С���㣬���1����

    //BaseRAM�ź�
    inout wire[31:0] base_ram_data,  //BaseRAM���ݣ���8λ��CPLD���ڿ�������??????
    output wire[19:0] base_ram_addr, //BaseRAM��ַ
    output wire[3:0] base_ram_be_n,  //BaseRAM�ֽ�ʹ�ܣ�����Ч�������ʹ���ֽ�ʹ�ܣ��뱣��??????0
    output wire base_ram_ce_n,       //BaseRAMƬ???������??????
    output wire base_ram_oe_n,       //BaseRAM��ʹ�ܣ�����??????
    output wire base_ram_we_n,       //BaseRAMдʹ�ܣ�����??????

    //ExtRAM�ź�
    inout wire[31:0] ext_ram_data,  //ExtRAM����
    output wire[19:0] ext_ram_addr, //ExtRAM��ַ
    output wire[3:0] ext_ram_be_n,  //ExtRAM�ֽ�ʹ�ܣ�����Ч�������ʹ���ֽ�ʹ�ܣ��뱣��??????0
    output wire ext_ram_ce_n,       //ExtRAMƬ???������??????
    output wire ext_ram_oe_n,       //ExtRAM��ʹ�ܣ�����??????
    output wire ext_ram_we_n,       //ExtRAMдʹ�ܣ�����??????

    //ֱ�������ź�
    output wire txd,  //ֱ�����ڷ�???��
    input  wire rxd,  //ֱ�����ڽ���??????

    //Flash�洢���źţ���??? JS28F640 оƬ�ֲ�
    output wire [22:0]flash_a,      //Flash��ַ��a0����8bitģʽ��Ч??????16bitģʽ����??????
    inout  wire [15:0]flash_d,      //Flash����
    output wire flash_rp_n,         //Flash��λ�źţ�����Ч
    output wire flash_vpen,         //Flashд�����źţ��͵�ƽʱ���ܲ�������??????
    output wire flash_ce_n,         //FlashƬ???�źţ�����??????
    output wire flash_oe_n,         //Flash��ʹ���źţ�����??????
    output wire flash_we_n,         //Flashдʹ���źţ�����??????
    output wire flash_byte_n,       //Flash 8bitģʽѡ�񣬵���Ч����ʹ��flash??????16λģʽʱ����??????1

    //ͼ������ź�
    output wire[2:0] video_red,    //��ɫ����??????3??????
    output wire[2:0] video_green,  //��ɫ����??????3??????
    output wire[1:0] video_blue,   //��ɫ����??????2??????
    output wire video_hsync,       //��ͬ����ˮƽͬ������??????
    output wire video_vsync,       //��ͬ������ֱͬ������??????
    output wire video_clk,         //����ʱ�����
    output wire video_de           //��������Ч�źţ�������������??????
);


    wire[31:0]IM_addr;
    wire[31:0]IM_out;
    wire[31:0]DM_addr;
    wire R_en;
    wire W_en;
    wire[31:0]DM_out;
    wire [31:0]IN_DM;
    wire pc_stop;
    wire cpu_no_stop;
    wire [3:0] cpu_EX_MEM_AccessStorage_manner;
wire locked, clk_10M, clk_20M,clk_25M,clk_30M;
pll_example clock_gen 
 (
  // Clock in ports
  .clk_in1(clk_50M),  // �ⲿʱ������
  // Clock out ports
  .clk_out1(clk_10M), // ʱ�����1��Ƶ����IP���ý�������??????
  .clk_out2(clk_20M), // ʱ�����2��Ƶ����IP���ý�������??????
  .clk_out3(clk_25M),     
  .clk_out4(clk_30M),
  // Status and control signals
  .reset(reset_btn), // PLL��λ����
  .locked(locked)    // PLL����ָʾ���??????"1"��ʾʱ���ȶ�??????
                     // �󼶵�·��λ�ź�Ӧ���������ɣ����£�
 );
reg reset_of_clk10M;
// �첽��λ��ͬ���ͷţ���locked�ź�תΪ�󼶵�·�ĸ�λreset_of_clk10M
always@(posedge clk_10M or negedge locked) begin
    if(~locked) reset_of_clk10M <= 1'b1;
    else        reset_of_clk10M <= 1'b0;
end

reg reset_of_clk20M;
// �첽��λ��ͬ���ͷţ���locked�ź�תΪ�󼶵�·�ĸ�λreset_of_clk10M
always@(posedge clk_20M or negedge locked) begin
    if(~locked) reset_of_clk20M <= 1'b1;
    else        reset_of_clk20M <= 1'b0;
end

reg reset_of_clk25M;
// �첽��λ��ͬ���ͷţ���locked�ź�תΪ�󼶵�·�ĸ�λreset_of_clk10M
always@(posedge clk_25M or negedge locked) begin
    if(~locked) reset_of_clk25M <= 1'b1;
    else        reset_of_clk25M <= 1'b0;
end

reg reset_of_clk30M;
// �첽��λ��ͬ���ͷţ���locked�ź�תΪ�󼶵�·�ĸ�λreset_of_clk10M
always@(posedge clk_30M or negedge locked) begin
    if(~locked) reset_of_clk30M <= 1'b1;
    else        reset_of_clk30M <= 1'b0;
end

wire in_Serial_addr;
assign in_Serial_addr = (DM_addr==32'hBFD003F8 || DM_addr==32'hBFD003FC)?1'b1:1'b0;
wire [7:0]Serial_data_out;
wire AccessStorage_valid;
wire [31:0]SRAN_DATA;
reg [31:0]mySerial_addr;
always@(*)
    begin
        mySerial_addr=DM_addr;
    end
 CtrlSerial CtrlSerialobj(.clk(clk_50M),.rst(reset_of_clk20M),.TxD(txd),.RxD(rxd),.cpu_addr(mySerial_addr),.cpu_r(R_en),
 .cpu_w(W_en),.cpu_DM_OUT(Serial_data_out),.cpu_IN_DM(IN_DM),.directives(IM_out),.cpu_no_stop(cpu_no_stop),.mydata(leds[7:0])
 );

assign DM_out = (in_Serial_addr&&(R_en==1'b0&&W_en==1'b1))?{{24{1'b0}},Serial_data_out}:SRAN_DATA;

myMIPS myMIPSobj(.clk(clk_20M),.rst(reset_of_clk20M),.IM_addr(IM_addr),.IM_out(IM_out),.DM_addr(DM_addr),
.R_en(R_en),.W_en(W_en),.DM_out(DM_out),.pc_stop_for_AccessStorage(pc_stop),.IN_DM(IN_DM),.cpu_no_stop(cpu_no_stop),
.cpu_EX_MEM_AccessStorage_manner(cpu_EX_MEM_AccessStorage_manner),.AccessStorage_valid(AccessStorage_valid)
);
AccessStorage AccessStorageobj(.base_ram_data(base_ram_data),.base_ram_addr(base_ram_addr),.base_ram_be_n(base_ram_be_n),
.base_ram_ce_n(base_ram_ce_n),.base_ram_oe_n(base_ram_oe_n),.base_ram_we_n(base_ram_we_n),.ext_ram_data(ext_ram_data),
.ext_ram_addr(ext_ram_addr),.ext_ram_be_n(ext_ram_be_n),.ext_ram_ce_n(ext_ram_ce_n),.ext_ram_oe_n(ext_ram_oe_n),
.ext_ram_we_n(ext_ram_we_n),.rst(reset_of_clk20M),.IM_addr(IM_addr),.IM_out(IM_out),.DM_addr(DM_addr),.cpu_R_en(R_en),.cpu_W_en(W_en),
.DM_out(SRAN_DATA),.pc_stop(pc_stop),.IN_DM(IN_DM),.cpu_EX_MEM_AccessStorage_manner(cpu_EX_MEM_AccessStorage_manner),
.AccessStorage_valid(AccessStorage_valid)
);




endmodule
