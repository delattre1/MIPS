library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity decoderULAFunct is
  port   (
	 Funct  : in std_logic_vector(5 downto 0);
	 Output : out std_logic_vector(2 downto 0)
  );
end entity;

architecture arch_name of decoderULAFunct is
  constant ADD    : std_logic_vector(5 downto 0) := "100000";
  constant SUB    : std_logic_vector(5 downto 0) := "100010";
  constant SLT    : std_logic_vector(5 downto 0) := "101010";
  constant PL_AND : std_logic_vector(5 downto 0) := "100100";
  constant PL_OR  : std_logic_vector(5 downto 0) := "100101";

  
begin
	
	Output <= "000"  when (Funct = PL_AND) else 
             "001"  when (Funct = PL_OR)  else
             "010"  when (Funct = ADD)    else
             "110"  when (Funct = SUB)    else
             "111"  when (Funct = SLT)    else 
             "000";
	
end architecture;