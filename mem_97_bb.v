// megafunction wizard: %LPM_RAM_DP%VBB%
// GENERATION: STANDARD
// VERSION: WM1.0
// MODULE: lpm_ram_dp 

// ============================================================
// File Name: mem_97.v
// Megafunction Name(s):
// 			lpm_ram_dp
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

module mem_97 (
	clock,
	data,
	rdaddress,
	wraddress,
	wren,
	q);

	input	  clock;
	input	[17:0]  data;
	input	[7:0]  rdaddress;
	input	[7:0]  wraddress;
	input	  wren;
	output	[17:0]  q;
`ifndef ALTERA_RESERVED_QIS
// synopsys translate_off
`endif
	tri0	  wren;
`ifndef ALTERA_RESERVED_QIS
// synopsys translate_on
`endif

endmodule

// ============================================================
// CNX file retrieval info
// ============================================================
// Retrieval info: PRIVATE: BlankMemory NUMERIC "1"
// Retrieval info: PRIVATE: CLRdata NUMERIC "0"
// Retrieval info: PRIVATE: CLRq NUMERIC "0"
// Retrieval info: PRIVATE: CLRrdaddress NUMERIC "0"
// Retrieval info: PRIVATE: CLRrren NUMERIC "0"
// Retrieval info: PRIVATE: CLRwraddress NUMERIC "0"
// Retrieval info: PRIVATE: CLRwren NUMERIC "0"
// Retrieval info: PRIVATE: Clock NUMERIC "0"
// Retrieval info: PRIVATE: INTENDED_DEVICE_FAMILY STRING "FLEX10KE"
// Retrieval info: PRIVATE: MIFfilename STRING ""
// Retrieval info: PRIVATE: REGdata NUMERIC "1"
// Retrieval info: PRIVATE: REGq NUMERIC "1"
// Retrieval info: PRIVATE: REGrdaddress NUMERIC "1"
// Retrieval info: PRIVATE: REGrren NUMERIC "1"
// Retrieval info: PRIVATE: REGwraddress NUMERIC "1"
// Retrieval info: PRIVATE: REGwren NUMERIC "1"
// Retrieval info: PRIVATE: SYNTH_WRAPPER_GEN_POSTFIX STRING "0"
// Retrieval info: PRIVATE: UseDPRAM NUMERIC "0"
// Retrieval info: PRIVATE: UseLCs NUMERIC "0"
// Retrieval info: PRIVATE: WidthAddr NUMERIC "8"
// Retrieval info: PRIVATE: WidthData NUMERIC "18"
// Retrieval info: PRIVATE: enable NUMERIC "0"
// Retrieval info: PRIVATE: rden NUMERIC "0"
// Retrieval info: CONSTANT: INTENDED_DEVICE_FAMILY STRING "FLEX10KE"
// Retrieval info: CONSTANT: LPM_INDATA STRING "REGISTERED"
// Retrieval info: CONSTANT: LPM_OUTDATA STRING "REGISTERED"
// Retrieval info: CONSTANT: LPM_RDADDRESS_CONTROL STRING "REGISTERED"
// Retrieval info: CONSTANT: LPM_TYPE STRING "LPM_RAM_DP"
// Retrieval info: CONSTANT: LPM_WIDTH NUMERIC "18"
// Retrieval info: CONSTANT: LPM_WIDTHAD NUMERIC "8"
// Retrieval info: CONSTANT: LPM_WRADDRESS_CONTROL STRING "REGISTERED"
// Retrieval info: CONSTANT: RDEN_USED STRING "FALSE"
// Retrieval info: CONSTANT: USE_EAB STRING "ON"
// Retrieval info: USED_PORT: clock 0 0 0 0 INPUT NODEFVAL clock
// Retrieval info: USED_PORT: data 0 0 18 0 INPUT NODEFVAL data[17..0]
// Retrieval info: USED_PORT: q 0 0 18 0 OUTPUT NODEFVAL q[17..0]
// Retrieval info: USED_PORT: rdaddress 0 0 8 0 INPUT NODEFVAL rdaddress[7..0]
// Retrieval info: USED_PORT: wraddress 0 0 8 0 INPUT NODEFVAL wraddress[7..0]
// Retrieval info: USED_PORT: wren 0 0 0 0 INPUT GND wren
// Retrieval info: CONNECT: @data 0 0 18 0 data 0 0 18 0
// Retrieval info: CONNECT: q 0 0 18 0 @q 0 0 18 0
// Retrieval info: CONNECT: @wraddress 0 0 8 0 wraddress 0 0 8 0
// Retrieval info: CONNECT: @rdaddress 0 0 8 0 rdaddress 0 0 8 0
// Retrieval info: CONNECT: @wren 0 0 0 0 wren 0 0 0 0
// Retrieval info: CONNECT: @wrclock 0 0 0 0 clock 0 0 0 0
// Retrieval info: CONNECT: @rdclock 0 0 0 0 clock 0 0 0 0
// Retrieval info: LIBRARY: lpm lpm.lpm_components.all
// Retrieval info: GEN_FILE: TYPE_NORMAL mem_97.v TRUE
// Retrieval info: GEN_FILE: TYPE_NORMAL mem_97.inc FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL mem_97.cmp TRUE
// Retrieval info: GEN_FILE: TYPE_NORMAL mem_97.bsf TRUE FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL mem_97_inst.v FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL mem_97_bb.v TRUE
// Retrieval info: LIB_FILE: lpm
