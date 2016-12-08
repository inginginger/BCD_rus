// megafunction wizard: %LPM_MUX%
// GENERATION: STANDARD
// VERSION: WM1.0
// MODULE: lpm_mux 

// ============================================================
// File Name: muxRS.v
// Megafunction Name(s):
// 			lpm_mux
//
// Simulation Library Files(s):
// 			lpm
// ============================================================
// ************************************************************
// THIS IS A WIZARD-GENERATED FILE. DO NOT EDIT THIS FILE!
//
// 9.0 Build 184 04/29/2009 SP 1 SJ Web Edition
// ************************************************************


//Copyright (C) 1991-2009 Altera Corporation
//Your use of Altera Corporation's design tools, logic functions 
//and other software and tools, and its AMPP partner logic 
//functions, and any output files from any of the foregoing 
//(including device programming or simulation files), and any 
//associated documentation or information are expressly subject 
//to the terms and conditions of the Altera Program License 
//Subscription Agreement, Altera MegaCore Function License 
//Agreement, or other applicable license agreement, including, 
//without limitation, that your use is for the sole purpose of 
//programming logic devices manufactured by Altera and sold by 
//Altera or its authorized distributors.  Please refer to the 
//applicable agreement for further details.


// synopsys translate_off
`timescale 1 ps / 1 ps
// synopsys translate_on
module muxRS (
	data0,
	data1,
	sel,
	result);

	input	  data0;
	input	  data1;
	input	  sel;
	output	  result;

	wire [0:0] sub_wire0;
	wire  sub_wire6 = data1;
	wire [0:0] sub_wire1 = sub_wire0[0:0];
	wire  result = sub_wire1;
	wire  sub_wire2 = sel;
	wire  sub_wire3 = sub_wire2;
	wire  sub_wire4 = data0;
	wire [1:0] sub_wire5 = {sub_wire6, sub_wire4};

	lpm_mux	lpm_mux_component (
				.sel (sub_wire3),
				.data (sub_wire5),
				.result (sub_wire0)
				// synopsys translate_off
				,
				.aclr (),
				.clken (),
				.clock ()
				// synopsys translate_on
				);
	defparam
		lpm_mux_component.lpm_size = 2,
		lpm_mux_component.lpm_type = "LPM_MUX",
		lpm_mux_component.lpm_width = 1,
		lpm_mux_component.lpm_widths = 1;


endmodule

// ============================================================
// CNX file retrieval info
// ============================================================
// Retrieval info: PRIVATE: INTENDED_DEVICE_FAMILY STRING "FLEX10KE"
// Retrieval info: PRIVATE: SYNTH_WRAPPER_GEN_POSTFIX STRING "0"
// Retrieval info: CONSTANT: LPM_SIZE NUMERIC "2"
// Retrieval info: CONSTANT: LPM_TYPE STRING "LPM_MUX"
// Retrieval info: CONSTANT: LPM_WIDTH NUMERIC "1"
// Retrieval info: CONSTANT: LPM_WIDTHS NUMERIC "1"
// Retrieval info: USED_PORT: data0 0 0 0 0 INPUT NODEFVAL data0
// Retrieval info: USED_PORT: data1 0 0 0 0 INPUT NODEFVAL data1
// Retrieval info: USED_PORT: result 0 0 0 0 OUTPUT NODEFVAL result
// Retrieval info: USED_PORT: sel 0 0 0 0 INPUT NODEFVAL sel
// Retrieval info: CONNECT: result 0 0 0 0 @result 0 0 1 0
// Retrieval info: CONNECT: @data 0 0 1 1 data1 0 0 0 0
// Retrieval info: CONNECT: @data 0 0 1 0 data0 0 0 0 0
// Retrieval info: CONNECT: @sel 0 0 1 0 sel 0 0 0 0
// Retrieval info: LIBRARY: lpm lpm.lpm_components.all
// Retrieval info: GEN_FILE: TYPE_NORMAL muxRS.v TRUE
// Retrieval info: GEN_FILE: TYPE_NORMAL muxRS.inc FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL muxRS.cmp TRUE
// Retrieval info: GEN_FILE: TYPE_NORMAL muxRS.bsf TRUE FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL muxRS_inst.v FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL muxRS_bb.v TRUE
// Retrieval info: LIB_FILE: lpm
