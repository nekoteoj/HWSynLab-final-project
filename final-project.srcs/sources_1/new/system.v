`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/18/2019 03:11:02 PM
// Design Name: 
// Module Name: system
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


//============================================================================
// Host design containing A-Z80 and a few peripherials
//
// This module defines a host board to be run on an FPGA.
//
//  Copyright (C) 2016  Goran Devic
//
//  This program is free software; you can redistribute it and/or modify it
//  under the terms of the GNU General Public License as published by the Free
//  Software Foundation; either version 2 of the License, or (at your option)
//  any later version.
//
//  This program is distributed in the hope that it will be useful, but WITHOUT
//  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
//  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
//  more details.
//
//  You should have received a copy of the GNU General Public License along
//  with this program; if not, write to the Free Software Foundation, Inc.,
//  51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
//============================================================================
module system
(
    input wire CLOCK_100,
    input wire KEY0,            // KEY0 is reset
    input wire KEY1,            // KEY1 generates a maskable interrupt (INT)
    input wire KEY2,            // KEY2 generates a non-maskable interrupt (NMI)
    input  wire PS2Data,
    input  wire PS2Clk,
    output wire UART_TXD,
    output wire [3:0] an,
    output wire [6:0] seg,
    output wire dp,
    output wire [3:0]vgaRed, vgaGreen, vgaBlue,
    output wire Hsync, Vsync,
    output wire [15:0] led
);
`default_nettype none

// Basic wires and the reset logic
wire uart_tx;
wire reset;
wire locked;

//assign reset = locked & ~KEY0;
assign reset = ~KEY0;
//assign UART_TXD = uart_tx;

// ----------------- CPU PINS -----------------
wire nM1;
wire nMREQ;
wire nIORQ;
wire nRD;
wire nWR;
wire nRFSH;
wire nHALT;
wire nBUSACK;

wire nWAIT = 1;
wire nBUSRQ = 1;
wire nINT = ~KEY1;
wire nNMI = ~KEY2;

wire [15:0] A;
reg [7:0] D /* synthesis keep */;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Instantiate PLL
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
wire pll_clk;
wire clk_uart; // 50MHz clock for UART

//clock pll ( .CLK_IN1(CLOCK_100), .CLK_OUT1(pll_clk), .CLK_OUT2(clk_uart), .LOCKED(locked) );

clock_generator clock_gen(.cpu_clk(pll_clk), .clk(CLOCK_100));
//clock_divider #(200) clk_dvvv(pll_clk, CLOCK_100);
//assign led = A;
//assign pll_clk = CLOCK_100;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Clocks
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
wire clk_cpu = pll_clk; // CPU clock == PLL1 clock

// Test code: Divide pll clock with a power of 2 to reduce effective CPU clock
// reg [0:0] counter = 0;
// always @(posedge pll_clk)
// begin
//     if (counter==1'b0)
//         clk_cpu <= ~clk_cpu;
//     counter <= counter - 1'b1;
// end

// ----------------- INTERNAL WIRES -----------------
wire [7:0] RamData; // Data writer from the RAM module
wire [7:0] CpuData;
wire [7:0] KeyboardData;
wire [7:0] VGAData;
assign CpuData = nRD==0 ? D[7:0] : {nIORQ,nRD,nWR}==3'b011 ? 8'h80 : {8{1'bz}};

wire RamWE;
assign RamWE = nIORQ==1 && nRD==1 && nWR==0;

wire uart_busy;
wire UartWE;
assign UartWE = nIORQ==0 && nRD==1 && nWR==0;

// Memory map:
//   0000 - 3FFF  16Kb RAM
always @(*) // always_comb
begin
    case ({nIORQ,nRD,nWR})
        // -------------------------------- Memory read --------------------------------
        3'b101: begin
            D[7:0] = RamData;
            if (A[13:0] == 14'h37F0 || A[13:0] == 14'h37F1) begin
                D[7:0] = KeyboardData;
            end else if (A[13:0] >= 14'h2000 && A[13:0] <= 14'h36FF) begin
                D[7:0] = VGAData;
            end
        end
        // -------------------------------- Memory write -------------------------------
        3'b110: D[7:0] = CpuData;
        // ---------------------------------- IO write ---------------------------------
        3'b010: D[7:0] = CpuData;
        // ---------------------------------- IO read ----------------------------------
        3'b001: D[7:0] = {7'b0000000, uart_busy};
        // IO read *** Interrupts test ***
        // This value will be pushed on the data bus on an IORQ access which
        // means that:
        // In IM0: this is the opcode of an instruction to execute, set it to 0xFF
        // In IM2: this is a vector, set it to 0x80 (to correspond to a test program Hello World)
        3'b011: D[7:0] = 8'h80;
    default:
        D[7:0] = {8{1'bz}};
    endcase
end

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Instantiate A-Z80 CPU module
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
z80_top_direct_n z80_(
    .nM1 (nM1),
    .nMREQ (nMREQ),
    .nIORQ (nIORQ),
    .nRD (nRD),
    .nWR (nWR),
    .nRFSH (nRFSH),
    .nHALT (nHALT),
    .nBUSACK (nBUSACK),

    .nWAIT (nWAIT),
    .nINT (nINT),
    .nNMI (nNMI),
    .nRESET (reset),
    .nBUSRQ (nBUSRQ),

    .CLK (clk_cpu),
    .A (A),
    .D (CpuData)
);

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Instantiate 16K of RAM memory
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ram #( .n(14)) ram_(
    .addr(A[13:0]),
    .clk(clk_cpu),
    .data_in(D),
    .we(RamWE),
    .data_out(RamData)
);


//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Instantiate Background VGA
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
wire [9:0] vga_x;
wire [9:0] vga_y;
wire vga_color;
reg  [15:0] keycodev=0;
vga_test vga(
    .clk(CLOCK_100), 
//    .sw(sw),
//    .push({btnL, btnU}),
    .hsync(Hsync),
    .vsync(Vsync),
    .rgb({vgaRed, vgaGreen, vgaBlue}),
    .x(vga_x),
    .y(vga_y),
    .color(vga_color),
    .keycodev(keycodev)
);

vga_io(
    .addr(A[13:0]),
    .clk(clk_cpu),
    .data_in(D),
    .we(RamWE),
    .data_out(VGAData),
    .x(vga_x),
    .y(vga_y),
    .color(vga_color),
    .debug(led[1:0])
);

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Instantiate keyboard
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    wire        tready;
    wire        ready;
    wire        tstart;
    reg         start=0;
    reg         CLK50MHZ=0;
    wire [31:0] tbuf;
    wire [15:0] keycode;
    wire [ 7:0] tbus;
    reg  [ 2:0] bcount=0;
    wire        flag;
    reg         cn=0;
    
    always @(posedge(CLOCK_100))begin
        CLK50MHZ<=~CLK50MHZ;
    end
    
    PS2Receiver uut (
        .clk(CLK50MHZ),
        .kclk(PS2Clk),
        .kdata(PS2Data),
        .keycode(keycode),
        .oflag(flag)
    );
    
    reg [15:0] outcode = 0;
    always @(posedge flag) begin
        outcode <= keycode;
    end
    
    wire [3:0] num3,num2,num1,num0;
    assign {num3, num2, num1, num0} = keycodev;

    // ledDisplay ledDis(led,num3,num2,num1,num0);
    
    seven_seg_display ssd(
    .an(an),
    .seg(seg),
    .dp(dp),
    .clk(CLOCK_100),
    .num3(num3),
    .num2(num2),
    .num1(num1),
    .num0(num0)
    );
    
    wire tx;
    assign UART_TXD = tx;
    
    always@(keycode)
        if (keycode[7:0] == 8'hf0) begin
            cn <= 1'b0;
            bcount <= 3'd0;
        end else if (keycode[15:8] == 8'hf0) begin
            cn <= keycode != keycodev;
            bcount <= 3'd5;
        end else begin
            cn <= keycode[7:0] != keycodev[7:0] || keycodev[15:8] == 8'hf0;
            bcount <= 3'd2;
        end
    
    always@(posedge CLOCK_100)
        if (flag == 1'b1 && cn == 1'b1) begin
            start <= 1'b1;
            keycodev <= keycode;
        end else
            start <= 1'b0;
            
    bin2ascii #(
        .NBYTES(2)
    ) conv (
        .I(keycodev),
        .O(tbuf)
    );
    
    uart_buf_con tx_con (
        .clk    (CLOCK_100),
        .bcount (bcount),
        .tbuf   (tbuf  ),  
        .start  (start ), 
        .ready  (ready ), 
        .tstart (tstart),
        .tready (tready),
        .tbus   (tbus  )
    );
    
    uart_tx get_tx (
        .clk    (CLOCK_100),
        .start  (tstart),
        .tbus   (tbus),
        .tx     (tx),
        .ready  (tready)
    );
    
    wire [15:0] ooo;
    keyboard_io keyboard_io_(
        .clk(clk_cpu),
        .addr(A[13:0]),
        .we(RamWE),
        .data_in(keycodev),
        .data_out(KeyboardData),
        .dat(ooo)
    );
    // assign led = ooo;

endmodule
