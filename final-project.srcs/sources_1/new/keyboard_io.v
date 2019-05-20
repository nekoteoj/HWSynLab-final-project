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

module keyboard_io(clk, addr, we, data_in, data_out, dat);

input clk, we;
input [13:0] addr;
input [7:0] data_in;
output reg [7:0] data_out;
output reg [7:0] dat;

reg [7:0] reg_array[1:0];

initial begin
    reg_array[0] = 8'b01010101;
    reg_array[1] = 0;
end

always @(posedge clk)
begin
    if (addr == 14'h1000) begin
        if (we == 1)
            reg_array[0] <= data_in;
        data_out = reg_array[0];
    end else if (addr == 14'h1001) begin
        if (we == 1)
            reg_array[1] <= data_in;
        data_out = reg_array[1];
    end
    dat = reg_array[0];
end

endmodule

