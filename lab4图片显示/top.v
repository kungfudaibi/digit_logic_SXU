`timescale 1ns / 1ps

module top(
    input clk,
    output wire [3:0]red,
    output wire [3:0]green,
    output wire [3:0]blue,
    output wire hsync,
    output wire vsync
    );
    wire clk_vga;
    clk_wiz_0 clk_wiz_0_inst(
        .clk_in1(clk),
        .clk_out1(clk_vga)
    );
    vga vga_inst(
        .clk(clk_vga),
        .red(red),
        .green(green),
        .blue(blue),
        .hsync(hsync),
        .vsync(vsync)
    );
endmodule
module vga(
    input clk,
    output reg[3:0]red,
    output reg[3:0]green,
    output reg[3:0]blue,
    output wire hsync,
    output wire vsync
    );
    reg [15:0] addr;
    wire [15:0] dout;
    blk_mem_gen_0 inst(
        .clka(clk),
        .ena(1'b1),
        .addra(addr),
        .douta(dout)
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
    always@(posedge clk)begin 
        if (data_act) begin
            if( vcout >= 480 && vcout < 680) begin
                if (hcout >= 951 && hcout < 1151) begin
                    red <= dout[15:12];
                    green <= dout[10:7]; 
                    blue <= dout[4:1]; 
                    addr <= addr + 1;
            end
            else begin
                red <= 4'b0;
                green <= 4'b0;
                blue <= 4'b0;
            end
        end
            else begin
                addr <= 0;
                red <= 4'b0;
                green <= 4'b0;
                blue <= 4'b0;
            end
        end
        else begin
            red <= 4'b0;
            green <= 4'b0;
            blue <= 4'b0;
        end
    end
endmodule
