`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/18/2019 03:10:08 PM
// Design Name: 
// Module Name: ram
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

module vga_io(clk, addr, we, data_in, x, y, data_out, color, debug);

input wire clk, we;
input [13:0] addr;
input [7:0] data_in;
input wire [9:0] x;
input wire [9:0] y;
output reg [7:0] data_out;
output reg color;
output reg [1:0] debug = 0;

reg [9:0] reg_array[9:0];

wire [13:0] row;
wire [13:0] col;

assign row = (addr - 14'h2000) / 80;
assign col = (addr - 14'h2000) % 80;

integer i;
initial begin
    for (i = 0; i < 60; i = i + 1) begin
//        reg_array[i] = 80'b0;
        reg_array[i] = 80'b11;
    end
end

always @(posedge clk)
begin
    if (addr >= 14'h2000 && addr <= 14'h36FF) begin
        if (we == 1) begin
//            reg_array[row][col] <= data_in[0];
//            reg_array[row][col] <= 1;
            debug[1] = 1;
        end
        data_out = { 7'b0, reg_array[row][col] };
    end
    debug[0] = reg_array[0][0];
end

always @(x or y) begin
    color = reg_array[y/8][x/8];
end

endmodule
