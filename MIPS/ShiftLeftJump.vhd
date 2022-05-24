library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ShiftLeftJump is
    generic(
		  larguraDados: natural := 26
	  );
    port(
        DataInput : in  std_logic_vector(larguraDados-1 downto 0);
        DataOutput: out std_logic_vector(larguraDados-1 downto 0)
	 );
end entity;

architecture componente of ShiftLeftJump is
    begin
        DataOutput <= DataInput(larguraDados-3 downto 0) & "00";
end architecture;