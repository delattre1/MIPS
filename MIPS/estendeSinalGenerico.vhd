library ieee;
use ieee.std_logic_1164.all;

entity estendeSinalGenerico is
    generic
    (
        larguraDadoEntrada : natural  :=    16;
        larguraDadoSaida   : natural  :=    32
    );
    port
    (
        -- Input ports
        estendeSinal_IN : in  std_logic_vector(larguraDadoEntrada-1 downto 0);
        -- Output ports
        estendeSinal_OUT: out std_logic_vector(larguraDadoSaida-1 downto 0);
		  -- Selector ORI
		  ORI             : in  std_logic

    );
end entity;

architecture comportamento of estendeSinalGenerico is
	signal saida_MUX_Extensor: std_logic;

begin
		MUX_Estensor: entity work.muxGenerico2x1_1bit
		port map( 
			inA_MUX   => estendeSinal_IN(15),
			inB_MUX   => '0',
			sel_MUX   => ORI,
			saida_MUX => saida_MUX_Extensor
		);

		estendeSinal_OUT <= (31 downto 16 => saida_MUX_Extensor) & estendeSinal_IN;
end architecture;



    

