library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity decoderULAOpcode is
  port   (
	 Opcode : in std_logic_vector(5 downto 0);
	 Output : out std_logic_vector(2 downto 0)
  );
end entity;

architecture arch_name of decoderULAOpcode is
  constant LW     : std_logic_vector(5 downto 0) := "100011";
  constant SW     : std_logic_vector(5 downto 0) := "101011";
  constant BEQ    : std_logic_vector(5 downto 0) := "000100";
  
begin
	
	Output <= "010" when (Opcode = LW or Opcode = SW) else 
             "110" when (Opcode = BEQ) else
             "000";
	
end architecture;