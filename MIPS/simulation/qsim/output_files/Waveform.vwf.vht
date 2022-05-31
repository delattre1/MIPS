-- Copyright (C) 2020  Intel Corporation. All rights reserved.
-- Your use of Intel Corporation's design tools, logic functions 
-- and other software and tools, and any partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Intel Program License 
-- Subscription Agreement, the Intel Quartus Prime License Agreement,
-- the Intel FPGA IP License Agreement, or other applicable license
-- agreement, including, without limitation, that your use is for
-- the sole purpose of programming logic devices manufactured by
-- Intel and sold by Intel or its authorized distributors.  Please
-- refer to the applicable agreement for further details, at
-- https://fpgasoftware.intel.com/eula.

-- *****************************************************************************
-- This file contains a Vhdl test bench with test vectors .The test vectors     
-- are exported from a vector file in the Quartus Waveform Editor and apply to  
-- the top level entity of the current Quartus project .The user can use this   
-- testbench to simulate his design using a third-party simulation tool .       
-- *****************************************************************************
-- Generated on "05/24/2022 19:54:06"
                                                             
-- Vhdl Test Bench(with test vectors) for design  :          MIPS_INTERMEDIARIA
-- 
-- Simulation tool : 3rd Party
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY MIPS_INTERMEDIARIA_vhd_vec_tst IS
END MIPS_INTERMEDIARIA_vhd_vec_tst;
ARCHITECTURE MIPS_INTERMEDIARIA_arch OF MIPS_INTERMEDIARIA_vhd_vec_tst IS
-- constants                                                 
-- signals                                                   
SIGNAL AND_DBG : STD_LOGIC;
SIGNAL BEQ_DEBUG : STD_LOGIC;
SIGNAL HEX0 : STD_LOGIC_VECTOR(6 DOWNTO 0);
SIGNAL HEX1 : STD_LOGIC_VECTOR(6 DOWNTO 0);
SIGNAL HEX2 : STD_LOGIC_VECTOR(6 DOWNTO 0);
SIGNAL HEX3 : STD_LOGIC_VECTOR(6 DOWNTO 0);
SIGNAL HEX4 : STD_LOGIC_VECTOR(6 DOWNTO 0);
SIGNAL HEX5 : STD_LOGIC_VECTOR(6 DOWNTO 0);
SIGNAL INA_ULA_DBG : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL INB_ULA_DBG : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL KEY : STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL LEDR : STD_LOGIC_VECTOR(9 DOWNTO 0);
SIGNAL PC_DEBUG : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL RD_DEBUG : STD_LOGIC_VECTOR(4 DOWNTO 0);
SIGNAL RE_DEBUG : STD_LOGIC;
SIGNAL RS_DEBUG : STD_LOGIC_VECTOR(4 DOWNTO 0);
SIGNAL RT_DEBUG : STD_LOGIC_VECTOR(4 DOWNTO 0);
SIGNAL SelMuxJMP_DEBUG : STD_LOGIC;
SIGNAL SW : STD_LOGIC_VECTOR(9 DOWNTO 0);
SIGNAL ULA_DEBUG : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL WE_DEBUG : STD_LOGIC;
COMPONENT MIPS_INTERMEDIARIA
	PORT (
	AND_DBG : OUT STD_LOGIC;
	BEQ_DEBUG : OUT STD_LOGIC;
	HEX0 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
	HEX1 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
	HEX2 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
	HEX3 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
	HEX4 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
	HEX5 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
	INA_ULA_DBG : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
	INB_ULA_DBG : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
	KEY : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
	LEDR : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
	PC_DEBUG : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
	RD_DEBUG : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
	RE_DEBUG : OUT STD_LOGIC;
	RS_DEBUG : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
	RT_DEBUG : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
	SelMuxJMP_DEBUG : OUT STD_LOGIC;
	SW : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
	ULA_DEBUG : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
	WE_DEBUG : OUT STD_LOGIC
	);
END COMPONENT;
BEGIN
	i1 : MIPS_INTERMEDIARIA
	PORT MAP (
-- list connections between master ports and signals
	AND_DBG => AND_DBG,
	BEQ_DEBUG => BEQ_DEBUG,
	HEX0 => HEX0,
	HEX1 => HEX1,
	HEX2 => HEX2,
	HEX3 => HEX3,
	HEX4 => HEX4,
	HEX5 => HEX5,
	INA_ULA_DBG => INA_ULA_DBG,
	INB_ULA_DBG => INB_ULA_DBG,
	KEY => KEY,
	LEDR => LEDR,
	PC_DEBUG => PC_DEBUG,
	RD_DEBUG => RD_DEBUG,
	RE_DEBUG => RE_DEBUG,
	RS_DEBUG => RS_DEBUG,
	RT_DEBUG => RT_DEBUG,
	SelMuxJMP_DEBUG => SelMuxJMP_DEBUG,
	SW => SW,
	ULA_DEBUG => ULA_DEBUG,
	WE_DEBUG => WE_DEBUG
	);

-- KEY[0]
t_prcs_KEY_0: PROCESS
BEGIN
	KEY(0) <= '1';
	WAIT FOR 10000 ps;
	FOR i IN 1 TO 49
	LOOP
		KEY(0) <= '0';
		WAIT FOR 10000 ps;
		KEY(0) <= '1';
		WAIT FOR 10000 ps;
	END LOOP;
	KEY(0) <= '0';
WAIT;
END PROCESS t_prcs_KEY_0;
END MIPS_INTERMEDIARIA_arch;
