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
  constant ADDI   : std_logic_vector(5 downto 0) := "001000";
  constant BNE    : std_logic_vector(5 downto 0) := "000101";
  constant ORI    : std_logic_vector(5 downto 0) := "001101";
  constant SLTI   : std_logic_vector(5 downto 0) := "001010";
  
begin
	
	Output <= "010" when (Opcode = LW or Opcode = SW or Opcode = ADDI) else 
             "110" when (Opcode = BEQ or Opcode = BNE) else
				 "001" when (Opcode = ORI) else
             "111" when (Opcode = SLTI) else
             "000";

	
end architecture;