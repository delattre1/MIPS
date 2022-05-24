library ieee;
use ieee.std_logic_1164.all;

entity muxGenerico4x1_1bit is
  port (
    inA_MUX, inB_MUX, inC_MUX, inD_MUX : in std_logic;
    sel_MUX     :  in std_logic_vector(1 downto 0);
    saida_MUX   : out std_logic
  );
end entity;

architecture comportamento of muxGenerico4x1_1bit is
  begin
  
    saida_MUX <= inA_MUX when (sel_MUX = "00") else 
		 inB_MUX when (sel_MUX = "01") else 
		 inC_MUX when (sel_MUX = "10") else 
		 inD_MUX;
					  
end architecture;
