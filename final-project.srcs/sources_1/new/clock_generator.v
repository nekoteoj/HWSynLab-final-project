`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/19/2019 03:15:46 PM
// Design Name: 
// Module Name: clock_generator
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


module clock_generator(
    output reg cpu_clk = 0,
    input wire clk
);

reg [2:0] counter = 0;

always @(posedge clk) begin
    counter <= counter + 1;
    if (counter == 3'b101) begin
        counter <= 0;
        cpu_clk <= ~cpu_clk;
    end
end

endmodule
