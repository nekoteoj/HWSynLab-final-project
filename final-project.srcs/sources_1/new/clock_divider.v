`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/18/2019 07:46:29 PM
// Design Name: 
// Module Name: clock_divider
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


module clock_divider #(parameter PERIOD=41)(
    output reg clkDiv = 0,
    input wire clk
);

reg [26:0] counter = 0;
reg [26:0] count_time = 50000 * PERIOD;

always @(posedge clk) begin
    counter = counter + 1;
    if (counter == count_time) begin
        counter = 0;
        clkDiv = !clkDiv;
    end
end

endmodule
