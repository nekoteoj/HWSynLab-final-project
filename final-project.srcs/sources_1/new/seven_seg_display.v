`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/18/2019 08:45:29 PM
// Design Name: 
// Module Name: seven_seg_display
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


module seven_seg_display(
    output reg [3:0] an = 4'b1111,
    output wire [6:0] seg,
    output wire dp,
    input wire clk,
    input wire [3:0] num3,
    input wire [3:0] num2,
    input wire [3:0] num1,
    input wire [3:0] num0
);

assign dp = 1;

wire clk_div;
clock_divider #(41) cd(clk_div, clk);

reg [3:0] hex_in = 0;
hex_to_seven_seg hts(.seg_out(seg), .hex_in(hex_in));

reg [1:0] state = 0;

always @(posedge clk_div) begin
    case (state)
        2'b00 : state <= 2'b01;
        2'b01 : state <= 2'b10;
        2'b10 : state <= 2'b11;
        2'b11 : state <= 2'b00;
    endcase
end

always @(state) begin
    case (state)
        2'b00 : an <= 4'b0111;
        2'b01 : an <= 4'b1011;
        2'b10 : an <= 4'b1101;
        2'b11 : an <= 4'b1110;
    endcase
end

always @(state) begin
    case (state)
        2'b00 : hex_in <= num3;
        2'b01 : hex_in <= num2;
        2'b10 : hex_in <= num1;
        2'b11 : hex_in <= num0;
    endcase
end

endmodule
