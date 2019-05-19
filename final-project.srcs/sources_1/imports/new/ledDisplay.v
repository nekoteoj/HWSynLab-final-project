`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/19/2019 02:05:05 PM
// Design Name: 
// Module Name: ledDisplay
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


module ledDisplay(
    output [15:0]led,
    input wire [3:0] num3, 
    input wire [3:0] num2, 
    input wire [3:0] num1, 
    input wire [3:0] num0
    );
   
assign led = {num3, num2, num1, num0};

endmodule



