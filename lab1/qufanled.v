`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/08 15:58:34
// Design Name: 
// Module Name: lab2
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


module lab2(
    input [1:0] sw,
    output [3:0] led
    );
    assign led[0] = sw[0];
    assign led[1] = !sw[0];
    assign led[2] = sw[0]|sw[1];
    assign led[3] = sw[0]&sw[1];
    
endmodule
