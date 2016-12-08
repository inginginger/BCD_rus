// megafunction wizard: %LPM_CONSTANT%
// GENERATION: STANDARD
// VERSION: WM1.0
// MODULE: lpm_constant 

// ============================================================
// File Name: constant5500.v
// Megafunction Name(s):
// 			lpm_constant
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
module constant5500 (
	result);

	output	[15:0]  result;

	wire [15:0] sub_wire0;
	wire [15:0] result = sub_wire0[15:0];

	lpm_constant	lpm_constant_component (
				.result (sub_wire0));
	defparam
		lpm_constant_component.lpm_cvalue = 21760,
		lpm_constant_component.lpm_hint = "ENABLE_RUNTIME_MOD=NO",
		lpm_constant_component.lpm_type = "LPM_CONSTANT",
		lpm_constant_component.lpm_width = 16;


endmodule

// ============================================================
// CNX file retrieval info
// ============================================================
// Retrieval info: PRIVATE: INTENDED_DEVICE_FAMILY STRING "FLEX10KE"
// Retrieval info: PRIVATE: JTAG_ENABLED NUMERIC "0"
// Retrieval info: PRIVATE: JTAG_ID STRING "NONE"
// Retrieval info: PRIVATE: Radix NUMERIC "16"
// Retrieval info: PRIVATE: SYNTH_WRAPPER_GEN_POSTFIX STRING "0"
// Retrieval info: PRIVATE: Value NUMERIC "21760"
// Retrieval info: PRIVATE: nBit NUMERIC "16"
// Retrieval info: CONSTANT: LPM_CVALUE NUMERIC "21760"
// Retrieval info: CONSTANT: LPM_HINT STRING "ENABLE_RUNTIME_MOD=NO"
// Retrieval info: CONSTANT: LPM_TYPE STRING "LPM_CONSTANT"
// Retrieval info: CONSTANT: LPM_WIDTH NUMERIC "16"
// Retrieval info: USED_PORT: result 0 0 16 0 OUTPUT NODEFVAL result[15..0]
// Retrieval info: CONNECT: result 0 0 16 0 @result 0 0 16 0
// Retrieval info: LIBRARY: lpm lpm.lpm_components.all
// Retrieval info: GEN_FILE: TYPE_NORMAL constant5500.v TRUE
// Retrieval info: GEN_FILE: TYPE_NORMAL constant5500.inc FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL constant5500.cmp TRUE
// Retrieval info: GEN_FILE: TYPE_NORMAL constant5500.bsf TRUE FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL constant5500_inst.v FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL constant5500_bb.v TRUE
// Retrieval info: LIB_FILE: lpm