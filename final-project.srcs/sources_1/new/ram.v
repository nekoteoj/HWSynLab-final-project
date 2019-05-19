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

module ram(clk, addr, we, data_in, data_out);
parameter n = 4;

input clk, we;
input [n-1:0] addr;
input [7:0] data_in;
output reg [7:0] data_out;

reg [7:0] reg_array [2**n-1:0];

initial $readmemb("ram.mif", reg_array);

always @(posedge clk)
begin
    if (we == 1)
        reg_array[addr] <= data_in;
    data_out = reg_array[addr];
end

endmodule

