`timescale 1ns / 1ps



module count(
    input clk , rst_n , en,
    output [7:0] an,
    output [6:0] sseg
    );
    wire [7:0] q_wire;
    wire [3:0] one_wire, ten_wire, hun_wire;
    upcounter u1 (
        .reset_n(rst_n), .clk(clk), .en(en), .q(q_wire)
    );
    bintobcd8 u2 (
        .clk(clk), .rst(rst_n), .bin(q_wire),
        .one(one_wire), .ten(ten_wire), .hun(hun_wire)
    );
    scan_seg_disp u3 (
        .clk(clk), .one(one_wire), .ten(ten_wire), .hun(hun_wire),
        .an(an), .sseg(sseg)
    );

endmodule
//实现计时模块并分频率
module upcounter(
    input reset_n, clk, en,
    output reg [7:0] q
    );
    reg [31:0] cnt;
    initial
        cnt = 0;
    always @(posedge clk , negedge reset_n)begin
        if (!reset_n)begin
            cnt <= 0;
            q <= 0;
        end else if (en)begin
            cnt <= cnt + 1;
        if (cnt == 50000000 && q!=153)begin
            q <= q + 1;
            cnt <= 0;
        end
        end
    end
endmodule
//将二进制数转换为BCD码
module bintobcd8(
    input clk, rst,
    input [7:0] bin,
    output reg [3:0]one,ten,hun);
//     integer i;
 
// always @(*) begin
// 	one 		= 4'd0;
// 	ten 		= 4'd0;
// 	hun 	= 2'd0;
	
// 	for(i = 7; i >= 0; i = i - 1) begin
// 		if (one >= 4'd5)
//             one = one + 4'd3;
// 		if (ten >= 4'd5)
//             ten = ten + 4'd3;
// 		if (hun >= 4'd5)
//             hun = hun + 4'd3;
// 		hun = {hun[0],ten[3]};
// 		ten = {ten[2:0],one[3]};
// 		one = {one[2:0],bin[i]};
// 	end
// end
    reg [17:0] shift_reg;
    reg [3:0] count;
    always@(posedge clk, negedge rst)
    begin
    if(!rst) begin
        one=0;
        ten=0;
        hun=0;
        shift_reg=0;
        count=0;
        end
	else begin
	 	if (count == 0)
        shift_reg = {10'd0, bin};
        if (count < 4'd8) begin
            count = count+1;
            if (shift_reg[11:8]>4)
                shift_reg[11:8]= shift_reg[11:8]+2'b11;
            if (shift_reg[15:12]>4)
                shift_reg[15:12] = shift_reg[15:12]+2'b11;
        shift_reg[17:1] = shift_reg[16:0];
        end
        else if (count==4'd8)  begin
            one= shift_reg[11:8];
            ten = shift_reg[15:12];
            hun= {2'b00,shift_reg[17:16]};
            count = count+1;
            end
            else 
            count = count-9;
        end
    end
endmodule

//扫描显示模块

module scan_seg_disp (
    input clk,
    input [3:0] one, ten, hun,
    output reg [7:0] an,
    output reg [6:0] sseg
    );
    localparam N=20;
    reg [N-1:0] cnt;
    reg [3:0] hex;
    always @(posedge clk)
    begin   
        cnt = cnt + 1;
        case (cnt[N-1 : N-2])
        2'b00:begin
         hex = one;
        an = 8'b11111110;
        end
        2'b01:begin
        hex = ten;
        an = 8'b11111101;
        end
        2'b10:begin
        hex = hun;
        an = 8'b11111011;
        end
        endcase
	end
    always@ (*)begin
        case(hex)
        4'h0:sseg[6:0] = 7'b0000001;
        4'h1:sseg[6:0] = 7'b1001111;
        4'h2:sseg[6:0] = 7'b0010010;
        4'h3:sseg[6:0] = 7'b0000110;
        4'h4:sseg[6:0] = 7'b1001100;
        4'h5:sseg[6:0] = 7'b0100100;
        4'h6:sseg[6:0] = 7'b0100000;
        4'h7:sseg[6:0] = 7'b0001111;
        4'h8:sseg[6:0] = 7'b0000000;
        4'h9:sseg[6:0] = 7'b0000100;
        default:
        sseg[6:0] = 7'b1111111;
        endcase
    end
endmodule
