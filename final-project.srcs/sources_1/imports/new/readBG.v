`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/18/2019 11:33:29 PM
// Design Name: 
// Module Name: readBG
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


module readBG(x,y,color);
input wire [9:0] x;
input wire [9:0] y;
output reg [11:0] color;
    
//parameter DATA_WIDTH=320;
//parameter DATA_HEIGHT=240;
    
reg	[319:0]	data[0:239];
wire [9:0] newX;
wire [9:0] newY;

assign newX = 319-x/2;
assign newY = y/2;

initial
begin
	$readmemb("ping.list",data);
end

always @(x or y) begin
    if(data[newY][newX] == 0)
        color <= 12'b100001001111;
    else 
        color <= 12'b111111111111;
end


endmodule
