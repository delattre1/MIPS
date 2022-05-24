library ieee;
use ieee.std_logic_1164.all;

entity muxGenerico2x1_1bit is
  -- Total de bits das entradas e saidas
  port (
    inA_MUX, inB_MUX : in std_logic;
    sel_MUX          : in std_logic;
    saida_MUX        : out std_logic
  );
end entity;

architecture comportamento of muxGenerico2x1_1bit is
  begin
    saida_MUX <= inB_MUX when (sel_MUX = '1') else inA_MUX;
end architecture;