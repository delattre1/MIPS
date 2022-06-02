library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity decoderGenerico is
  port   (
	 Opcode: in std_logic_vector(5 downto 0);
	 Output: out std_logic_vector(8 downto 0)
  );
end entity;

architecture arch_name of decoderGenerico is
  -- Constantes de Opcode --
  constant LW    : std_logic_vector(5 downto 0) := "100011";
  constant SW    : std_logic_vector(5 downto 0) := "101011";
  constant BEQ   : std_logic_vector(5 downto 0) := "000100";
  constant JMP   : std_logic_vector(5 downto 0) := "000010";
  constant TipoR : std_logic_vector(5 downto 0) := "000000";
  
  -- Sinais de Habilita e SelMux --
  alias SelMuxPc         : std_logic is Output(0);
  alias SelMuxRtRd       : std_logic is Output(1);
  alias habEscritaReg    : std_logic is Output(2);
  alias SelMuxRtImediato : std_logic is Output(3);
  alias ULAop            : std_logic is Output(4);
  alias SelMuxULAMem     : std_logic is Output(5);
  alias BEQ_signal       : std_logic is Output(6);
  alias habLeituraMEM    : std_logic is Output(7);
  alias habEscritaMEM    : std_logic is Output(8);
  
begin
	-- SelMuxPc
	SelMuxPc <= '1' when (Opcode = JMP) else '0';

  -- SelMuxRtRd
	SelMuxRtRd <= '1' when (Opcode = TipoR) else '0';

  -- Habilita Escrita Reg 3 (Banco de registadores)
	habEscritaReg <= '0' when (Opcode = SW or Opcode = BEQ) else '1';

  -- SelMuxRtImediato
	SelMuxRtImediato <= '1' when (Opcode = LW or Opcode = SW) else '0';

	-- Operacao da ULA
  -- Quando Opcode = TipoR, utiliza-se o 'funct'
  ULAop  <= '1' when (Opcode = TipoR) else '0';

  -- SelMuxULAMem
	SelMuxULAMem <= '0' when (Opcode = TipoR) else '1';

  -- BEQ
  BEQ_signal <= '1' when (Opcode = BEQ) else '0';

  -- Habilita Leitura RAM
	habLeituraMEM <= '1' when (Opcode = LW) else '0';

	-- Habilita Escrita RAM
  habEscritaMEM <= '1' when (Opcode = SW) else '0';
	
end architecture;