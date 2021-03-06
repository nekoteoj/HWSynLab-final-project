//----------------------------------------------------------------------------
//  A-Z80 CPU Copyright (C) 2014,2018  Goran Devic, www.baltazarstudios.com
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
//----------------------------------------------------------------------------
// Copyright (C) 1991-2013 Altera Corporation
// Your use of Altera Corporation's design tools, logic functions 
// and other software and tools, and its AMPP partner logic 
// functions, and any output files from any of the foregoing 
// (including device programming or simulation files), and any 
// associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License 
// Subscription Agreement, Altera MegaCore Function License 
// Agreement, or other applicable license agreement, including, 
// without limitation, that your use is for the sole purpose of 
// programming logic devices manufactured by Altera and sold by 
// Altera or its authorized distributors.  Please refer to the 
// applicable agreement for further details.

// PROGRAM		"Quartus II 64-Bit"
// VERSION		"Version 13.0.1 Build 232 06/12/2013 Service Pack 1 SJ Web Edition"
// CREATED		"Sat Nov 08 09:37:58 2014"

module address_mux(
	select,
	in0,
	in1,
	out
);


input wire	select;
input wire	[15:0] in0;
input wire	[15:0] in1;
output wire	[15:0] out;

wire	SYNTHESIZED_WIRE_0;
wire	[15:0] SYNTHESIZED_WIRE_1;
wire	[15:0] SYNTHESIZED_WIRE_2;




assign	SYNTHESIZED_WIRE_1 = in0 & {SYNTHESIZED_WIRE_0,SYNTHESIZED_WIRE_0,SYNTHESIZED_WIRE_0,SYNTHESIZED_WIRE_0,SYNTHESIZED_WIRE_0,SYNTHESIZED_WIRE_0,SYNTHESIZED_WIRE_0,SYNTHESIZED_WIRE_0,SYNTHESIZED_WIRE_0,SYNTHESIZED_WIRE_0,SYNTHESIZED_WIRE_0,SYNTHESIZED_WIRE_0,SYNTHESIZED_WIRE_0,SYNTHESIZED_WIRE_0,SYNTHESIZED_WIRE_0,SYNTHESIZED_WIRE_0};

assign	SYNTHESIZED_WIRE_2 = in1 & {select,select,select,select,select,select,select,select,select,select,select,select,select,select,select,select};

assign	SYNTHESIZED_WIRE_0 =  ~select;

assign	out = SYNTHESIZED_WIRE_1 | SYNTHESIZED_WIRE_2;


endmodule
