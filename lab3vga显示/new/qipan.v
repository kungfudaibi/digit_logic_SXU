`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/24 10:26:00
// Design Name: 
// Module Name: qipan
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


module qipan(
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
    if(data_act) begin
        if((hcout < 431 ))begin
            red <= 4'b1111; 
            blue <= 4'b1111;
        end
        else if(hcout < 671 )begin
            red <= 4'b0000;
            blue <= 4'b1001;
        end
        else if((hcout < 911 ))begin
            red <= 4'b0010;
            blue <= 4'b1110;
        end
        else if(hcout < 1151  )begin
            red <= 4'b1000;
            blue <= 4'b1011;
        end
        else if(hcout < 1391 )begin
            red <= 4'b0100;
            blue <= 4'b0100;
        end
        else if(hcout < 1631 )begin
            red <= 4'b0101;
            blue <= 4'b0101;
        end
        else if(hcout < 1871 )begin
            red <= 4'b0110;
            blue <= 4'b0000;
        end
        else begin
            red <= 4'b1000;
            blue <= 4'b0000;
        end
    end
    else begin
        red <= 4'b0000;
        blue <= 4'b0000;
    end
    end
always @(posedge clk) begin
    if (data_act)begin
        if(vcout < 184) begin
            green<= 4'b1111;
        end
        else if (vcout < 325) begin
            green<= 4'b0100;
        end
        else if (vcout < 466) begin
            green<= 4'b0010;
        end
        else if (vcout < 607) begin
            green<= 4'b0011;
        end
        else if (vcout < 748) begin
            green<= 4'b0100;
        end
        else if (vcout < 889) begin
            green<= 4'b0101;
        end
        else if (vcout < 1030) begin
            green<= 4'b0010;
        end
        else begin
            green<= 4'b1111;
        end
    end
    else begin
        green<= 4'b0000;
    end
end
endmodule
