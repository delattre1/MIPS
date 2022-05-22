library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Ulinha_overflow is
   port(
	inputA   		 : in  std_logic;
	inputB   		 : in  std_logic;
	inverteB 		 : in  std_logic;
	SLT      		 : in  std_logic;
	operacao 		 : in  std_logic_vector(1 downto 0);
	carryIn  		 : in  std_logic;
	carryOut 		 : out std_logic;
	saida    		 : out std_logic;
	resultado_adder : out std_logic
);
end entity;

architecture componente of Ulinha_overflow is
   signal outMUX_B  : std_logic;
   signal outAND_AB : std_logic;
   signal outOR_AB  : std_logic;
   signal outSUM_AB : std_logic;

begin


outAND_AB <= (inputA and outMUX_B);
outOR_AB  <= (inputA or  outMUX_B);
resultado_adder <= outSUM_AB;
	
MUX_B: entity work.muxGenerico2x1_1bit
   port map( 
      inA_MUX    => inputB,
      inB_MUX    => not(inputB),
      sel_MUX    => inverteB,
      saida_MUX  => outMUX_B
   );

Adder :  entity work.somadorGenerico_1bit
   port map( 
      inputA   => inputA, 
      inputB   => outMUX_B, 
      carryIn  => carryIn,
      carryOut => carryOut,
      saida    => outSUM_AB
   );

Mux_resultado_ulinha: entity work.muxGenerico4x1_1bit
   port map( 
      inA_MUX    => outAND_AB,
      inB_MUX    => outOR_AB,
      inC_MUX    => outSUM_AB,
      inD_MUX    => SLT,
      sel_MUX    => operacao,
      saida_MUX  => saida
   );

end architecture;
