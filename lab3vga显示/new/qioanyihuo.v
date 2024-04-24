`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/24 18:43:26
// Design Name: 
// Module Name: qioanyihuo
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


module qioanyihuo(
   input clk,
    output reg[3:0]red,
    output reg[3:0]green,
    output reg[3:0]blue,
    output wire hsync,
    output wire vsync
    );
    reg  [12:0]hcout, vcout;
    wire hcout_ov, vcout_ov; 
    parameter
    hsync_end = 12'd43, //行同步信号结束
    hdata_begin = 12'd191, //行显示开始 
    hdata_end = 12'd2111, //行显示结束 
    hpixel_end = 12'd2199, //行显示前延结束 
    vsync_end = 12'd4, 
    vdata_begin = 12'd40, 
    vdata_end = 12'd1120, 
    vline_end =12'd1124; 
    assign hcout_ov = (hcout == hpixel_end);//行计数器=2199，扫描一行结束，给出标志位
    always @(posedge clk) begin
    if(hcout_ov)
        hcout <= 0;
    else
        hcout <= hcout + 1;
    end
    //行扫描

    assign vcout_ov = (vcout == vline_end);//场计数器=1124，一帧显示结束，给出标志位
    always @(posedge clk) begin
        if (hcout_ov) begin
            if(vcout_ov)
                vcout <= 0;
            else
                vcout <= vcout + 1;
        end
    end
    //帧扫描

    assign data_act = (hcout >= hdata_begin) && (hcout < hdata_end) && (vcout >= vdata_begin) && (vcout < vdata_end);
    //判断是否在显示区域

    assign hsync = (hcout > hsync_end);
    //行同步信号

    assign vsync = (vcout > vsync_end);
    //帧同步信号

    //显示颜色
    always @(posedge clk) begin
    if(data_act)begin
        if(hcout[8] ^ vcout[8])begin
            red <= 4'b1111;
            green <= 4'b1111;
            blue <= 4'b1111;
        end
        else begin
            red <= 4'b0000;
            green <= 4'b0000;
            blue <= 4'b0000;
        end
        end
    else 
        begin
            red <= 4'b0000;
            green <= 4'b0000;
            blue <= 4'b0000;
        end
end
endmodule
