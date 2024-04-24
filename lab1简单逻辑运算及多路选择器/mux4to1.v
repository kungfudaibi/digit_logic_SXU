`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/08 17:35:05
// Design Name: 
// Module Name: mux4to1
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


module mux4to1(
  input [3:0] a,
  input [1:0] b,
  output reg c
);
  always@(b or a) begin
    if (b == 2'b00) c = a[0];
    else if (b == 2'b01) c = a[1];
    else if (b == 2'b10) c = a[2];
    else if (b == 2'b11) c = a[3];
  end
endmodule
