`default_nettype none

module thinpad_top(
    input wire clk_50M,           //50MHz 时钟输入
    input wire clk_11M0592,       //11.0592MHz 时钟输入（备用，可不用）

    input wire clock_btn,         //BTN5手动时钟按钮??????关，带消抖电路，按下时为1
    input wire reset_btn,         //BTN6手动复位按钮??????关，带消抖电路，按下时为1

    input  wire[3:0]  touch_btn,  //BTN1~BTN4，按钮开关，按下时为1
    input  wire[31:0] dip_sw,     //32位拨码开关，拨到"ON"时??????1
    output wire[15:0] leds,       //16位LED，输出时1点亮
    output wire[7:0]  dpy0,       //数码管低位信号，包括小数点，输出1点亮
    output wire[7:0]  dpy1,       //数码管高位信号，包括小数点，输出1点亮

    //BaseRAM信号
    inout wire[31:0] base_ram_data,  //BaseRAM数据，低8位与CPLD串口控制器共??????
    output wire[19:0] base_ram_addr, //BaseRAM地址
    output wire[3:0] base_ram_be_n,  //BaseRAM字节使能，低有效。如果不使用字节使能，请保持??????0
    output wire base_ram_ce_n,       //BaseRAM片???，低有??????
    output wire base_ram_oe_n,       //BaseRAM读使能，低有??????
    output wire base_ram_we_n,       //BaseRAM写使能，低有??????

    //ExtRAM信号
    inout wire[31:0] ext_ram_data,  //ExtRAM数据
    output wire[19:0] ext_ram_addr, //ExtRAM地址
    output wire[3:0] ext_ram_be_n,  //ExtRAM字节使能，低有效。如果不使用字节使能，请保持??????0
    output wire ext_ram_ce_n,       //ExtRAM片???，低有??????
    output wire ext_ram_oe_n,       //ExtRAM读使能，低有??????
    output wire ext_ram_we_n,       //ExtRAM写使能，低有??????

    //直连串口信号
    output wire txd,  //直连串口发???端
    input  wire rxd,  //直连串口接收??????

    //Flash存储器信号，参??? JS28F640 芯片手册
    output wire [22:0]flash_a,      //Flash地址，a0仅在8bit模式有效??????16bit模式无意??????
    inout  wire [15:0]flash_d,      //Flash数据
    output wire flash_rp_n,         //Flash复位信号，低有效
    output wire flash_vpen,         //Flash写保护信号，低电平时不能擦除、烧??????
    output wire flash_ce_n,         //Flash片???信号，低有??????
    output wire flash_oe_n,         //Flash读使能信号，低有??????
    output wire flash_we_n,         //Flash写使能信号，低有??????
    output wire flash_byte_n,       //Flash 8bit模式选择，低有效。在使用flash??????16位模式时请设??????1

    //图像输出信号
    output wire[2:0] video_red,    //红色像素??????3??????
    output wire[2:0] video_green,  //绿色像素??????3??????
    output wire[1:0] video_blue,   //蓝色像素??????2??????
    output wire video_hsync,       //行同步（水平同步）信??????
    output wire video_vsync,       //场同步（垂直同步）信??????
    output wire video_clk,         //像素时钟输出
    output wire video_de           //行数据有效信号，用于区分消隐??????
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
  .clk_in1(clk_50M),  // 外部时钟输入
  // Clock out ports
  .clk_out1(clk_10M), // 时钟输出1，频率在IP配置界面中设??????
  .clk_out2(clk_20M), // 时钟输出2，频率在IP配置界面中设??????
  .clk_out3(clk_25M),     
  .clk_out4(clk_30M),
  // Status and control signals
  .reset(reset_btn), // PLL复位输入
  .locked(locked)    // PLL锁定指示输出??????"1"表示时钟稳定??????
                     // 后级电路复位信号应当由它生成（见下）
 );
reg reset_of_clk10M;
// 异步复位，同步释放，将locked信号转为后级电路的复位reset_of_clk10M
always@(posedge clk_10M or negedge locked) begin
    if(~locked) reset_of_clk10M <= 1'b1;
    else        reset_of_clk10M <= 1'b0;
end

reg reset_of_clk20M;
// 异步复位，同步释放，将locked信号转为后级电路的复位reset_of_clk10M
always@(posedge clk_20M or negedge locked) begin
    if(~locked) reset_of_clk20M <= 1'b1;
    else        reset_of_clk20M <= 1'b0;
end

reg reset_of_clk25M;
// 异步复位，同步释放，将locked信号转为后级电路的复位reset_of_clk10M
always@(posedge clk_25M or negedge locked) begin
    if(~locked) reset_of_clk25M <= 1'b1;
    else        reset_of_clk25M <= 1'b0;
end

reg reset_of_clk30M;
// 异步复位，同步释放，将locked信号转为后级电路的复位reset_of_clk10M
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




// wire myclk_5;
// wire mylocked;
// mydiv_clk instance_name
//    (
//     // Clock out ports
//     .clk_out1(myclk_5),     // output clk_out1
//     // Status and control signals
//     .reset(reset_btn), // input reset
//     .mylocked(mylocked),       // output mylocked
//    // Clock in ports
//     .clk_in1(clk_50M));  

// reg reset_of_clk5M;
// // 异步复位，同步释放，将locked信号转为后级电路的复位reset_of_clk10M
// always@(posedge myclk_5 or negedge mylocked) begin
//     if(~mylocked) reset_of_clk5M <= 1'b1;
//     else        reset_of_clk5M <= 1'b0;
// end
// always@(posedge clk_10M or posedge reset_of_clk10M) begin
//     if(reset_of_clk10M)begin
//         // Your Code
//     end
//     else begin
//         // Your Code
//     end
// end

endmodule
