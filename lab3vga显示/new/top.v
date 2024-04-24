`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/24 10:39:54
// Design Name: 
// Module Name: top
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


module top(
    input wire clk,
    input wire [1:0]zhiwei,
    output reg [3:0] red,
    output reg [3:0] green,
    output reg [3:0] blue,
    output reg hsync,
    output reg vsync
);
    wire [3:0] red_qipan, green_qipan, blue_qipan;
    wire [3:0] red_vga, green_vga, blue_vga;
    wire [3:0] red_qioanyihuo, green_qioanyihuo, blue_qioanyihuo;
    wire hsync_qipan, vsync_qipan;
    wire hsync_vga, vsync_vga;
    wire hsync_qioanyihuo, vsync_qioanyihuo;
    wire clk_buf;
    clk_wiz_0 clk_init(
        .clk_out1(clk_buf),
        .clk_in1(clk)
    );

    // 实例化 'qipan'模块
    qipan my_qipan(
        .clk(clk_buf),
        .red(red_qipan),
        .green(green_qipan),
        .blue(blue_qipan),
        .hsync(hsync_qipan),
        .vsync(vsync_qipan)
    );

    // 实例化 'vgadisplay'模块
    vga my_vgadisplay (
        .clk(clk_buf),
        .red(red_vga),
        .green(green_vga),
        .blue(blue_vga),
        .hsync(hsync_vga),
        .vsync(vsync_vga)
    );
    qioanyihuo my_qioanyihuo(
        .clk(clk_buf),
        .red(red_qioanyihuo),
        .green(green_qioanyihuo),
        .blue(blue_qioanyihuo),
        .hsync(hsync_qioanyihuo),
        .vsync(vsync_qioanyihuo)
    );

    // 多路选择器，根据 'zhiwei' 选择输出
    always @(*) begin
        case(zhiwei)
            2'b00: begin
                red = red_qipan;
                green = green_qipan;
                blue = blue_qipan;
                hsync = hsync_qipan;
                vsync = vsync_qipan;
            end
            2'b01: begin
                red = red_vga;
                green = green_vga;
                blue = blue_vga;
                hsync = hsync_vga;
                vsync = vsync_vga;
            end
            2'b10: begin
                red = red_qioanyihuo;
                green = green_qioanyihuo;
                blue = blue_qioanyihuo;
                hsync = hsync_qioanyihuo;
                vsync = vsync_qioanyihuo;
            end
            default: begin
                red = 4'b0000;
                green = 4'b0000;
                blue = 4'b0000;
                hsync = 1'b0;
                vsync = 1'b0;
            end
        endcase
    end
endmodule
